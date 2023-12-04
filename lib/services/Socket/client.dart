// // ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, non_constant_identifier_names, unused_local_variable

// import 'dart:convert';
// import 'dart:io';
// import 'dart:isolate';

// import 'package:ARMOYU/Services/Socket/socket.dart';

// Isolate? isolute_listen;
// ReceivePort? receiveport_listen;

// Isolate? isolate_send;
// ReceivePort? receiveport_send;

// Future<void> main() async {
//   //Flutter
//   String clientID = "1";
//   String receiverID = "11107";

//   String username = "berkaytikenoglu";
//   String password = "bekobeko52";

//   if (1 == 1) {
//     print('Kimliğinizi girin: ');
//     clientID = stdin.readLineSync()!;

//     print('Kullanıcıadı girin: ');
//     username = stdin.readLineSync()!;

//     print('parola girin girin: ');
//     password = stdin.readLineSync()!;

//     print('Alıcı kimliği girin: ');
//     receiverID = stdin.readLineSync()!;
//   }

//   try {
//     receiveport_listen = ReceivePort();

//     receiveport_send = ReceivePort();

//     Isolate.spawn(isolateSendMessage,
//         [receiveport_send!.sendPort, clientID, username, password, receiverID]);

//     Isolate.spawn(isolateListenMessage, [
//       receiveport_listen!.sendPort,
//       clientID,
//       username,
//       password,
//       receiverID
//     ]);

//     receiveport_listen!.listen(
//       (message) {
//         String message2 = "";

//         try {
//           var jsonData = jsonDecode(message);
//           Map<String, dynamic> responseData = jsonData;

//           if (responseData["sender_id"].toString() == clientID) {
//             return;
//           }

//           if (responseData["receiver_id"].toString() == clientID) {
//             message2 = responseData["message"].toString();
//           }
//         } catch (e) {
//           print("json hatası");
//         }

//         if (message2 != "") {
//           message = message2;
//         }
//         print("listen:" + message);
//       },
//     );

//     receiveport_send!.listen(
//       (message) {
//         String message2 = "";

//         try {
//           var jsonData = jsonDecode(message);
//           Map<String, dynamic> responseData = jsonData;

//           if (responseData["sender_id"].toString() == clientID) {
//             return;
//           }

//           if (responseData["receiver_id"].toString() == clientID) {
//             message2 = responseData["message"].toString();
//           }
//         } catch (e) {
//           print("json hatası");
//         }
//         print("Send:" + message);
//       },
//     );
//   } catch (e) {
//     print('Hata: $e');
//   }
// }

// Future<void> isolateSendMessage(List<dynamic> arguments) async {
//   final SendPort sendPort = arguments.first;
//   final String SenderID = arguments[1];
//   final String username = arguments[2];
//   final String password = arguments[3];
//   final String ReceiverID = arguments.last;

//   try {
//     var socket = await Socket.connect(
//         ARMOYU_Socket.serverHost, ARMOYU_Socket.serverPort);

//     while (true) {
//       ARMOYU_Socket socket2 =
//           ARMOYU_Socket(socket, SenderID, username, password, ReceiverID);
//       String input = stdin.readLineSync()!;
//       socket2.sendMessage(sendPort, input);
//     }
//   } catch (e) {
//     print(e);
//   }
// }

// Future<void> isolateListenMessage(List<dynamic> arguments) async {
//   final SendPort sendPort = arguments.first;
//   final String SenderID = arguments[1];
//   final String username = arguments[2];
//   final String password = arguments[3];
//   final String ReceiverID = arguments.last;
//   print(SenderID + " >>>> " + ReceiverID);

//   try {
//     var socket = await Socket.connect(
//         ARMOYU_Socket.serverHost, ARMOYU_Socket.serverPort);
//     ARMOYU_Socket socket2 =
//         ARMOYU_Socket(socket, SenderID, username, password, ReceiverID);
//     socket2.receiveMessages(sendPort);
//   } catch (e) {
//     print(e);
//   }
// }
