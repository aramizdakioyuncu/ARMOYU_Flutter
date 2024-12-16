import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/news.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class NewsPageController extends GetxController {
  late var user = Rxn<User>();
  late var news = Rxn<News>();

  var isfirstfetch = true.obs;
  var newsfetchProcess = false.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;

    user.value = arguments['user'] as User;
    news.value = arguments['news'] as News;

    if (news.value!.newsContent == "") {
      fetchnewscontent();
    }
  }

  Future<void> fetchnewscontent() async {
    if (newsfetchProcess.value) {
      return;
    }
    newsfetchProcess.value = true;

    NewsFetchResponse response =
        await API.service.newsServices.fetchnews(newsID: news.value!.newsID);

    if (!response.result.status) {
      log(response.result.description);
      newsfetchProcess.value = false;
      fetchnewscontent();
      return;
    }

    news.value!.newsContent = response.response!.content!;
    var document = parse(news.value!.newsContent);
    news.value!.newsContent = document.outerHtml;
    newsfetchProcess.value = false;
  }
}
