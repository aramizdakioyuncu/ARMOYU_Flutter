import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/news.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:get/get.dart';

class NewsPageController extends GetxController {
  late var news = Rxn<News>();

  var isfirstfetch = true.obs;
  var newsfetchProcess = false.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;

    news.value = arguments['news'] as News;

    if (news.value!.newsContent == null) {
      fetchnewscontent();
    }
  }

  Future<void> fetchnewscontent() async {
    if (newsfetchProcess.value) {
      return;
    }
    newsfetchProcess.value = true;

    NewsFetchResponse response =
        await API.service.newsServices.fetchdetail(newsID: news.value!.newsID);

    if (!response.result.status) {
      log(response.result.description);
      newsfetchProcess.value = false;
      fetchnewscontent();
      return;
    }

    news.value!.newsContent = Rx(response.response!.content!);
    newsfetchProcess.value = false;
  }
}
