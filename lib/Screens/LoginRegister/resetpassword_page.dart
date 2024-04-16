import 'dart:developer';

import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/functions_service.dart';

import 'package:flutter/material.dart';

import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/textfields.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  String passwordtimer = "120";

  bool step1 = true;
  bool step2 = false;

  bool resetpasswordProcess = false;
  bool resetpasswordauthProcess = false;
  DateTime dateTime = DateTime.now();

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

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
      ARMOYUWidget.stackbarNotification(context, text);
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

    String type = "mail";
    if (isSelected[0] == true) {
      type = "telefon";
    }

    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.forgotpassword(
        _usernameController.text, _emailController.text, type); //sa

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, text);
      }
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
      ARMOYUWidget.stackbarNotification(context, text);
      log(text);

      setState(() {
        resetpasswordauthProcess = false;
      });
      return;
    }

    if (_passwordController.text != _repasswordController.text) {
      String text = "Parolalar uyuşmadı!";
      ARMOYUWidget.stackbarNotification(context, text);
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
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, text);
      }
      log(text);

      setState(() {
        resetpasswordauthProcess = false;
      });
      return;
    }
    step1 = true;
    step2 = false;

    if (mounted) {
      Navigator.of(context).pop();
    }
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
                const SizedBox(height: 60),
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/armoyu512.png'), // Analog görselinizin yolunu ekleyin
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Visibility(
                  visible: step1,
                  child: Column(
                    children: [
                      CustomTextfields(setstate: setstatefunction).costum3(
                        title: "Kullanıcı Adı",
                        controller: _usernameController,
                        isPassword: false,
                        preicon: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 16),
                      CustomTextfields(setstate: setstatefunction).costum3(
                        title: "E-posta",
                        controller: _emailController,
                        isPassword: false,
                        preicon: const Icon(Icons.email),
                      ),
                      const SizedBox(height: 16),
                      // CustomButtons.Costum2(Icon(Icons.date_range),
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
                      const SizedBox(height: 16),
                      CustomButtons.costum1(
                        text: "Devam et",
                        onPressed: forgotmypassword,
                        loadingStatus: resetpasswordProcess,
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 10),
                      CustomTextfields.number(
                        "Kod",
                        controller: _codeController,
                        length: 6,
                        icon: const Icon(Icons.sms),
                      ),
                      const SizedBox(height: 16),
                      CustomTextfields(setstate: setstatefunction).costum3(
                        title: "Şifre",
                        controller: _passwordController,
                        isPassword: true,
                        preicon: const Icon(Icons.lock_outline),
                      ),
                      const SizedBox(height: 16),
                      CustomTextfields(setstate: setstatefunction).costum3(
                          title: "Şifre Tekrar",
                          controller: _repasswordController,
                          isPassword: true,
                          preicon: const Icon(Icons.lock_outline)),
                      const SizedBox(height: 16),
                      CustomButtons.costum1(
                        text: "Kaydet",
                        onPressed: forgotmypassworddone,
                        loadingStatus: resetpasswordauthProcess,
                      ),
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
