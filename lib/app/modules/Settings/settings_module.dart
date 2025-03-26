import 'package:armoyu/app/modules/Settings/SettingsPage/about/bindings/about_settings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/about/views/about_settings_view.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/account/bindings/account_settings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/account/views/account_settings_view.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/accountstatus/bindings/accountstatus_settings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/accountstatus/views/accountstatus_settings_view.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/blockedlist/bindings/blockedlist_settings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/blockedlist/views/blockedlist_settings_view.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/datasaving/bindings/datasaving_settings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/datasaving/views/datasaving_settings_view.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/devicepermission/bindings/devicepermission_settings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/devicepermission/views/devicepermissions_settings_view.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/help/bindings/helpsettings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/help/views/helpsettings_view.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/languages/bindings/languages_settings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/languages/views/languages_settings_view.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/notification/bindings/notification_settings_binding.dart';
import 'package:armoyu/app/modules/Settings/SettingsPage/notification/views/notification_setttings_view.dart';
import 'package:armoyu/app/modules/Settings/_main/bindings/setttings_binding.dart';
import 'package:armoyu/app/modules/Settings/_main/views/settings_view.dart';
import 'package:get/get.dart';

class SettingsModule {
  static const route = '/settings';

  static final List<GetPage> routes = [
    GetPage(
      name: route,
      page: () => const SettingsView(),
      binding: SetttingsBinding(),
    ),
    GetPage(
      name: "$route/notifications",
      page: () => const NotificationsettingsView(),
      binding: NotificationsettingsBinding(),
    ),
    GetPage(
      name: "$route/account",
      page: () => const AccountsettingsView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: "$route/accountstatus",
      page: () => const AccountstatusSettingsView(),
      binding: AccountstatusSettingsBinding(),
    ),
    GetPage(
      name: "$route/about",
      page: () => const AboutSettingsView(),
      binding: AboutSettingsBinding(),
    ),
    GetPage(
      name: "$route/help",
      page: () => const HelpsettingsView(),
      binding: HelpsettingsBinding(),
    ),
    GetPage(
      name: "$route/blockedlist",
      page: () => const BlockedlistSettingsView(),
      binding: BlockedlistSettingsBinding(),
    ),
    GetPage(
      name: "$route/devicepermission",
      page: () => const DevicepermissionsSettingsView(),
      binding: DevicepermissionSettingsBinding(),
    ),
    GetPage(
      name: "$route/datasaver",
      page: () => const DatasavingSettingsView(),
      binding: DatasavingSettingsBinding(),
    ),
    GetPage(
      name: "$route/languages",
      page: () => const LanguagesSettingsView(),
      binding: LanguagesSettingsBinding(),
    ),
  ];
}
