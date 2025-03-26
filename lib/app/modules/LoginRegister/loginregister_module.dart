import 'package:armoyu/app/modules/LoginRegister/login_page/bindings/login_binding.dart';
import 'package:armoyu/app/modules/LoginRegister/login_page/views/login_view.dart';
import 'package:armoyu/app/modules/LoginRegister/register_page/bindings/register.binding.dart';
import 'package:armoyu/app/modules/LoginRegister/register_page/views/register_view.dart';
import 'package:armoyu/app/modules/LoginRegister/resetpassword_page/bindings/resetpassword_binding.dart';
import 'package:armoyu/app/modules/LoginRegister/resetpassword_page/views/resetpassword_view.dart';
import 'package:get/get.dart';

class LoginRegisterpageModule {
  static const route = '/';

  static final List<GetPage> routes = [
    GetPage(
      name: "$route/login",
      page: () => const LoginpageView(),
      binding: LoginpageBinding(),
    ),
    GetPage(
      name: "$route/register",
      page: () => const RegisterpageView(),
      binding: RegisterpageBinding(),
    ),
    GetPage(
      name: "$route/forgot-password",
      page: () => const ResetPasswordpageView(),
      binding: ResetPasswordpageBinding(),
    ),
  ];
}
