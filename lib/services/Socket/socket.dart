// ignore_for_file: avoid_print, camel_case_types

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

class ARMOYU_Socket {
  static String serverHost = 'mc.armoyu.com';
  static int serverPort = 12345;
  Socket socket;
  String clientID;
  String receiverID;

  ARMOYU_Socket(this.socket, this.clientID, this.receiverID);

  void sendMessage(SendPort sendport) {
    var input = stdin.readLineSync()!;
    var message = {
      "KEY": "1234",
      "sender_id": clientID,
      "receiver_id": receiverID,
      "message": input
    };

    // print('$clientID: $input');
    sendport.send('$clientID: $input');

    socket.write(jsonEncode(message));
  }

  void receiveMessages(SendPort sendport) {
    print("Dinlenme başlatılıyor.");
    socket.listen((event) {
      var jsonString = String.fromCharCodes(event);
      var jsonData = jsonDecode(jsonString);

      Map<String, dynamic> responseData = jsonData;

      if (responseData["receiver_id"].toString() == clientID) {
        // print('${responseData["sender_id"]}: ${responseData["message"]}');
        sendport
            .send('${responseData["sender_id"]}: ${responseData["message"]}');
      }
    });
  }
}
