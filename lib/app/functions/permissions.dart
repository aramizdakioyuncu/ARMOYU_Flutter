// import 'package:permission_handler/permission_handler.dart';

// class Permissions {
//   static Future<void> requestMicrophonePermission() async {
//     final PermissionStatus status = await Permission.microphone.request();
//     if (status == PermissionStatus.granted) {
//       // Microphone permission granted
//       // Use the microphone here
//       print("qwe");
//     } else if (status == PermissionStatus.permanentlyDenied) {
//       // Permission permanently denied, guide the user to app settings
//       await openAppSettings();
//     } else {
//       // Handle other permission status (denied, undetermined)
//       print("---");
//     }
//   }
// }
