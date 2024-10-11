import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/text.dart';

import 'package:flutter/material.dart';

import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';

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
  Timer? timer;
  int passwordtimer = 120;
  Color countdownColor = Colors.green;

  bool step1 = true;
  bool step2 = false;

  bool resetpasswordProcess = false;
  bool resetpasswordauthProcess = false;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (passwordtimer == 0) {
          setState(() {
            countdownColor = Colors.red;
            timer.cancel();
          });
        } else {
          passwordtimer--;

          if (passwordtimer < 30) {
            countdownColor = Colors.red;
          } else if (passwordtimer < 60) {
            countdownColor = Colors.orange;
          } else if (passwordtimer < 90) {
            countdownColor = Colors.yellow;
          } else if (passwordtimer < 120) {
            countdownColor = Colors.green;
          }
          setstatefunction();
        }
      },
    );
  }

  Future<void> forgotmypassword() async {
    if (resetpasswordProcess) {
      return;
    }

    if (_emailController.text == "" || _usernameController.text == "") {
      String text = "Boş olan bırakmayın!";
      ARMOYUWidget.stackbarNotification(context, text);
      return;
    }

    String type = "mail";
    if (isSelected[0] == true) {
      type = "telefon";
    }

    resetpasswordProcess = true;
    setstatefunction();

    FunctionService f =
        FunctionService(currentUser: User(userName: "", password: ""));
    Map<String, dynamic> response = await f.forgotpassword(
        _usernameController.text, _emailController.text, type); //sa

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, text);
      }
      log(text);
      resetpasswordProcess = false;
      setstatefunction();
      return;
    }

    passwordtimer = response["aciklamadetay"];
    step1 = false;
    step2 = true;
    resetpasswordProcess = false;
    setstatefunction();
    startTimer();
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

    FunctionService f =
        FunctionService(currentUser: User(userName: "", password: ""));
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
      backgroundColor: ARMOYU.backgroundcolor,
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
                      CustomTextfields.costum3(
                        title: "Kullanıcı Adı",
                        controller: _usernameController,
                        isPassword: false,
                        preicon: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 16),
                      CustomTextfields.costum3(
                        title: "E-posta",
                        controller: _emailController,
                        isPassword: false,
                        preicon: const Icon(Icons.email),
                      ),
                      const SizedBox(height: 16),
                      ToggleButtons(
                        isSelected: isSelected,
                        onPressed: (int index) {
                          for (int buttonIndex = 0;
                              buttonIndex < isSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }

                          setstatefunction();
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.alarm,
                              size: 40,
                              color: countdownColor,
                            ),
                            const SizedBox(width: 5),
                            CustomText.costum1(
                              passwordtimer.toString(),
                              size: 40,
                              weight: FontWeight.bold,
                              color: countdownColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextfields.number(
                        placeholder: "Kod",
                        controller: _codeController,
                        length: 6,
                        icon: const Icon(Icons.sms),
                      ),
                      const SizedBox(height: 16),
                      CustomTextfields.costum3(
                        title: "Şifre",
                        controller: _passwordController,
                        isPassword: true,
                        preicon: const Icon(Icons.lock_outline),
                      ),
                      const SizedBox(height: 16),
                      CustomTextfields.costum3(
                          title: "Şifre Tekrar",
                          controller: _repasswordController,
                          isPassword: true,
                          preicon: const Icon(Icons.lock_outline)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: passwordtimer != 0,
                            child: CustomButtons.costum1(
                              text: "Kaydet",
                              onPressed: forgotmypassworddone,
                              loadingStatus: resetpasswordauthProcess,
                            ),
                          ),
                          Visibility(
                            visible: passwordtimer == 0,
                            child: CustomButtons.costum1(
                              text: "Tekrar Kod Gönder",
                              onPressed: forgotmypassword,
                              loadingStatus: resetpasswordProcess,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
