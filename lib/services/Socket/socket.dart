// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

class ARMOYU_Socket {
  static String serverHost = 'mc.armoyu.com';
  static int serverPort = 12345;
  Socket socket;
  String clientID;
  String receiverID;
  String client_username;
  String client_security;

  ARMOYU_Socket(this.socket, this.clientID, this.client_username,
      this.client_security, this.receiverID);

  void sendMessage(SendPort sendport, String input) {
    var message = {
      "KEY": "1234",
      "sender_id": clientID,
      "sender_username": client_username,
      "sender_security": client_security,
      "receiver_id": receiverID,
      "message_type": "ozel",
      "message": input
    };
    // print('[Listen]>$clientID: $input');
    sendport.send(jsonEncode(message));

    socket.write(jsonEncode(message));
  }

  void receiveMessages(SendPort sendport) {
    print("Dinlenme başlatılıyor.");
    socket.listen((event) {
      var jsonString = String.fromCharCodes(event);
      var jsonData = jsonDecode(utf8.decode(jsonString.codeUnits));

      Map<String, dynamic> responseData = jsonData;

      if (responseData["receiver_id"].toString() == clientID) {
        // print(
        //     '[SEND]>${responseData["sender_id"]}: ${responseData["message"]}');
        sendport.send(jsonString);
      }
    });
  }
}
