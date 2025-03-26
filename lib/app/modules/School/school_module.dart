import 'package:armoyu/app/modules/School/school_login/binding/school_login_binding.dart';
import 'package:armoyu/app/modules/School/school_login/views/school_login_view.dart';
import 'package:armoyu/app/modules/School/_main/bindings/school_binding.dart';
import 'package:armoyu/app/modules/School/_main/views/school_view.dart';
import 'package:get/get.dart';

class SchoolModule {
  static const route = '/school';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SchoolView(),
      binding: SchoolBinding(),
    ),
    GetPage(
      name: "$route/login",
      page: () => const SchoolLoginView(),
      binding: SchoolLoginBinding(),
    ),
  ];
}
