// ignore_for_file: non_constant_identifier_names, deprecated_member_use, file_names

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ARMOYU {
  static String Name = "0";
  static String SecurityDetail = "0";

  static Color? appbarColor;
  static Color? bodyColor;

  static Color? color;
  static Color? bacgroundcolor;

  static Color? textColor;
  static Color? textbackColor;
  static Color? texthintColor;

  static Color? buttonColor;

  static double get screenWidth =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double get screenHeight =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

  static List<CameraDescription>? cameras;
}
