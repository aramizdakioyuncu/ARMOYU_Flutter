import 'package:ARMOYU/app/modules/poll/poll_detail/controllers/poll_detail_controller.dart';
import 'package:ARMOYU/app/modules/utils/newphotoviewer.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PollDetailView extends StatelessWidget {
  const PollDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PollDetailController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.survey.value!.surveyQuestion.questionValue,
          overflow: TextOverflow.ellipsis,
        ),
        // backgroundColor: ARMOYU.appbarColor,
        actions: [
          IconButton(
            onPressed: () async => await controller.refreshSurvey(),
            icon: const Icon(Icons.refresh),
          ),
          Visibility(
            visible: controller.survey.value!.surveyOwner.userID ==
                controller.currentUserAccounts.value.user.value.userID,
            child: IconButton(
              onPressed: () async => await controller.deleteSurvey(),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 3,
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      controller.survey.value!.surveyQuestion.questionImages ==
                              null
                          ? 0
                          : controller.survey.value!.surveyQuestion
                              .questionImages!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MediaViewer(
                              currentUser: controller
                                  .currentUserAccounts.value.user.value,
                              media: controller
                                  .survey.value!.surveyQuestion.questionImages!,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        width: Get.width,
                        height: Get.height / 3,
                        imageUrl: controller.survey.value!.surveyQuestion
                            .questionImages![index].mediaURL.normalURL.value,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: WidgetUtility.specialText(
                              context,
                              currentUserAccounts:
                                  controller.currentUserAccounts.value,
                              controller
                                  .survey.value!.surveyQuestion.questionValue,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundImage: CachedNetworkImageProvider(
                                  controller.survey.value!.surveyOwner.avatar!
                                      .mediaURL.minURL.value,
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection:
                                    Axis.horizontal, // Yatay kaydırma için
                                child: Text(
                                  controller
                                      .survey.value!.surveyOwner.displayName
                                      .toString(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //Result
                    Column(
                      children: [
                        Column(
                          children: List.generate(
                              controller.survey.value!.surveyOptions.length,
                              (index) {
                            return RadioListTile<String>(
                              contentPadding: const EdgeInsets.all(0),
                              title: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        controller.survey.value!
                                            .surveyOptions[index].value,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: controller.survey.value!
                                        .surveyOptions[index].percentage,
                                  ),
                                  builder: (context, value, _) => Stack(
                                    children: [
                                      LinearProgressIndicator(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        semanticsLabel: "Oylama Oranı",
                                        semanticsValue: "%10",
                                        minHeight: 20,
                                        color: controller
                                                    .survey
                                                    .value!
                                                    .surveyOptions[index]
                                                    .percentage >=
                                                0.5
                                            ? Colors.amber
                                            : Colors.red,
                                        value: value,
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: 65,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${controller.survey.value!.surveyOptions[index].percentage * 100 == 100 ? "100" : controller.survey.value!.surveyOptions[index].percentage * 100 == 0 ? "0" : (controller.survey.value!.surveyOptions[index].percentage * 100).toStringAsFixed(2)}%",
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              value: controller
                                  .survey.value!.surveyOptions[index].answerID
                                  .toString(),
                              activeColor: Colors.amber,
                              groupValue: controller.selectedOption.value,
                              onChanged: controller.survey.value!.didIVote ||
                                      controller.answerSurveyProccess.value ||
                                      !controller.survey.value!.surveyStatus
                                  ? null
                                  : (value) {
                                      // setState(() {
                                      controller.selectedOption.value = value!;
                                      // });
                                    },
                            );
                          }),
                        ),
                        Visibility(
                          visible: !controller.survey.value!.didIVote &&
                              controller.survey.value!.surveyStatus,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButtons.costum1(
                              text: "OYLA",
                              onPressed: () async =>
                                  await controller.answerfunction(),
                              loadingStatus: controller.answerSurveyProccess,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
