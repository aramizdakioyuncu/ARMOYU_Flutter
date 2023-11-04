// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';

class Screen {
  static double get screenWidth =>
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width;
  static double get screenHeight =>
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.height;
  // Diğer ekran özellikleri ekleyebilirsiniz.
}
