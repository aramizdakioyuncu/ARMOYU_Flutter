import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/modules/Business/joinus_page/controllers/joinus_controller.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinUsBusinessView extends StatelessWidget {
  final User currentUser;

  const JoinUsBusinessView({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      JoinusController(currentUser: currentUser),
    );
    return Scaffold(
      // backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        title: CustomText.costum1('Bize Katıl'),
        // backgroundColor: ARMOYU.appbarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: [
              Container(color: ARMOYU.bodyColor, height: 1),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/armoyu512.png',
                  height: 150,
                  width: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText.costum1(
                  "* Cep telefon numarasını sisteme kayıt etmiş olmak.\n* Profil fotoğrafı varsayılan logodan farklı olmak.\n* Hiç ceza almamış ve insanları kışkırtmamış olmak.",
                  align: TextAlign.left,
                  color: Colors.red,
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButtons.costum2(
                    text: controller.category.value != null
                        ? '${controller.category.value}'
                        : 'Bir Öğe Seçin',
                    onPressed: () {
                      WidgetUtility.cupertinoselector(
                        context: context,
                        title: "Ekip Seçimi",
                        setstatefunction: controller.setstatefunction,
                        list: controller.departmentList.map((item) {
                          return item.map((key, value) {
                            return MapEntry(key, value["category"].toString());
                          });
                        }).toList(),
                        onChanged: (valueID, value) {
                          if (valueID == -1) {
                            return;
                          }
                          controller.category.value = value;

                          controller.filtereddepartmentdetailList.value =
                              controller.departmentdetailList.where((item) {
                            return item.values.first["category"] ==
                                controller.category;
                          }).toList();

                          controller.categorydetail.value = "Bir pozisyon Seç";
                          controller.departmentabout.value = "";
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButtons.costum2(
                  text: controller.categorydetail.value != null
                      ? '${controller.categorydetail.value}'
                      : 'Bir pozisyon Seç',
                  onPressed: () {
                    WidgetUtility.cupertinoselector(
                      context: context,
                      title: "Bir pozisyon Seç",
                      setstatefunction: controller.setstatefunction,
                      list: controller.filtereddepartmentdetailList.map((item) {
                        return item.map((key, value) {
                          return MapEntry(key, value["value"].toString());
                        });
                      }).toList(),
                      onChanged: (valueID, value) {
                        if (valueID == -1) {
                          return;
                        }
                        controller.categorydetail.value = value;
                        controller.positionID = controller
                            .filtereddepartmentdetailList[valueID]
                            .values
                            .first["ID"];
                        controller.departmentabout.value = controller
                            .filtereddepartmentdetailList[valueID]
                            .values
                            .first["about"]
                            .toString();
                      },
                    );
                  },
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText.costum1(
                    controller.departmentabout.value,
                    align: TextAlign.left,
                    color: Colors.amber,
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextfields.costum3(
                    title: "Neden ekibe katılmak istiyorsun?",
                    minLines: 5,
                    maxLength: 200,
                    minLength: 20,
                    controller: controller.whyjointheteamController,
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextfields.costum3(
                    title: "Neden bu yetkiyi seçtin?",
                    minLines: 3,
                    maxLength: 100,
                    minLength: 10,
                    controller: controller.whypositionController,
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextfields.costum3(
                    title: "Bize haftada kaç gün ayırabilirsin?",
                    minLines: 2,
                    maxLength: 50,
                    minLength: 5,
                    controller: controller.howmuchtimedoyouspareController,
                  ),
                ),
              ),
              Obx(
                () => CustomButtons.costum1(
                  text: "Gönder",
                  onPressed: () async => await controller.requestjoinfunction(),
                  loadingStatus: controller.requestProccess,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
