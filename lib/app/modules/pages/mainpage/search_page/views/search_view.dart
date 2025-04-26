import 'dart:developer';

import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/pages/_main/controllers/pages_controller.dart';

import 'package:armoyu/app/modules/pages/mainpage/search_page/controllers/search_controller.dart';
import 'package:armoyu/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:armoyu/app/widgets/appbar_widget.dart';
import 'package:armoyu/app/widgets/bottomnavigationbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final bool appbar;
  final ScrollController scrollController;
  const SearchView({
    super.key,
    required this.currentUserAccounts,
    required this.appbar,
    required this.scrollController,
  });

  @override
  State<SearchView> createState() => _SearchPagePage();
}

class _SearchPagePage extends State<SearchView>
    with AutomaticKeepAliveClientMixin<SearchView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final currentAccountController = Get.find<AppPageController>();
    final currentAccountController = Get.find<PagesController>(
      tag: widget.currentUserAccounts.user.value.userID.toString(),
    );
    log("*****${currentAccountController.currentUserAccount.user.value.displayName}");

    final mainpagecontroller = Get.find<MainPageController>(
      tag: widget.currentUserAccounts.user.value.userID.toString(),
    );

    final controller = Get.put(
      SearchPageController(
        currentUserAccounts: currentAccountController.currentUserAccount,
        searchController: mainpagecontroller.appbarSearchTextController.value,
      ),
      tag: widget.currentUserAccounts.user.value.userID.toString(),
    );

    return Scaffold(
      appBar: AppbarWidget.custom(),
      body: Obx(
        () => controller.widgetSearch.isNotEmpty
            ? ListView.builder(
                controller: ScrollController(),
                itemCount: controller.widgetSearch.length,
                itemBuilder: (context, index) {
                  return controller.widgetSearch[index];
                },
              )
            : SingleChildScrollView(
                controller: mainpagecontroller.searchScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    controller.widgetNews.value!,
                    const SizedBox(height: 10),
                    controller.widgetTPCard.widget.value!,
                    const SizedBox(height: 10),
                    controller.widgetPOPCard.widget.value!,
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomnavigationBar.custom1(),
    );
  }
}
