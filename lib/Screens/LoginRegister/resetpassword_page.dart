// ignore_for_file: avoid_print, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'dart:developer';

import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/notifications.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/textfields.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _birthdayController = TextEditingController();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  String passwordtimer = "120";

  bool step1 = true;
  bool step2 = false;

  bool resetpasswordProcess = false;
  bool resetpasswordauthProcess = false;
  DateTime dateTime = DateTime.now();

  // Future<DateTime?> pickDate() => showDatePicker(
  //     context: context,
  //     initialDate: dateTime,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now());

  // Future<void> datepicker() async {
  //   final date = await pickDate();
  //   if (date == null) return;
  //   setState(() => dateTime = date);
  //   _birthdayController.text =
  //       "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  // }

  Future<void> forgotmypassword() async {
    setState(() {
      resetpasswordProcess = true;
    });

    if (_emailController.text == "" || _usernameController.text == "") {
      String text = "Boş olan bırakmayın!";
      CustomNotifications.stackbarNotification(context, text);
      log(text);

      setState(() {
        resetpasswordProcess = false;
      });
      return;
    }

    // List<String> words = _birthdayController.text.split("/");
    // String gun = words[0];
    // String ay = words[1];
    // String yil = words[2];

    // String yeniformat = "$yil-$ay-$gun";

    String Type = "mail";
    if (isSelected[0] == true) {
      Type = "telefon";
    }

    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.forgotpassword(
        _usernameController.text, _emailController.text, Type); //sa

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      CustomNotifications.stackbarNotification(context, text);
      log(text);

      setState(() {
        resetpasswordProcess = false;
      });
      return;
    }

    log(response["aciklamadetay"].toString());
    passwordtimer = response["aciklamadetay"].toString();
    step1 = false;
    step2 = true;
  }

  Future<void> forgotmypassworddone() async {
    setState(() {
      resetpasswordauthProcess = true;
    });

    if (_codeController.text == "" ||
        _passwordController.text == "" ||
        _repasswordController.text == "") {
      String text = "Boş alan bırakmayın!";
      CustomNotifications.stackbarNotification(context, text);
      log(text);

      setState(() {
        resetpasswordauthProcess = false;
      });
      return;
    }

    if (_passwordController.text != _repasswordController.text) {
      String text = "Parolalar uyuşmadı!";
      CustomNotifications.stackbarNotification(context, text);
      log(text);

      setState(() {
        resetpasswordauthProcess = false;
      });
      return;
    }

    // List<String> words = _birthdayController.text.split("/");
    // String gun = words[0];
    // String ay = words[1];
    // String yil = words[2];

    // String yeniformat = "$yil-$ay-$gun";
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.forgotpassworddone(
        // yeniformat,
        _usernameController.text,
        _emailController.text,
        _codeController.text,
        _passwordController.text,
        _repasswordController.text); //sa

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      CustomNotifications.stackbarNotification(context, text);
      log(text);

      setState(() {
        resetpasswordauthProcess = false;
      });
      return;
    }
    step1 = true;
    step2 = false;
    Navigator.of(context).pop();
  }

  List<bool> isSelected = [false, true];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 60),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/armoyu512.png'), // Analog görselinizin yolunu ekleyin
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Visibility(
                  visible: step1,
                  child: Column(
                    children: [
                      CustomTextfields().Costum1("Kullanıcı Adı",
                          _usernameController, false, Icon(Icons.person)),
                      SizedBox(height: 16),
                      CustomTextfields().Costum1("E-posta", _emailController,
                          false, Icon(Icons.email)),
                      SizedBox(height: 16),
                      // CustomButtons().Costum2(Icon(Icons.date_range),
                      //     _birthdayController.text, datepicker),
                      // SizedBox(height: 16),
                      ToggleButtons(
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelected[buttonIndex] = true;
                              } else {
                                isSelected[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.phone_iphone_rounded,
                              size: 50,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.mail,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      CustomButtons().Costum1(
                          "Devam et", forgotmypassword, resetpasswordProcess),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Şifreyi hatırladıysan ",
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Giriş Yap",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: step2,
                  child: Column(
                    children: [
                      Text(passwordtimer.toString()),
                      SizedBox(height: 10),
                      CustomTextfields()
                          .number("Kod", _codeController, 6, Icon(Icons.sms)),
                      SizedBox(height: 16),
                      CustomTextfields().Costum1("Şifre", _passwordController,
                          true, Icon(Icons.lock_outline)),
                      SizedBox(height: 16),
                      CustomTextfields().Costum1(
                          "Şifre Tekrar",
                          _repasswordController,
                          true,
                          Icon(Icons.lock_outline)),
                      SizedBox(height: 16),
                      CustomButtons().Costum1("Kaydet", forgotmypassworddone,
                          resetpasswordauthProcess),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
