// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

class ARMOYU_Socket {
  String serverHost = 'mc.armoyu.com';
  int serverPort = 12345;
  String clientID;
  String receiverID;
  String client_username;
  String client_security;

  late Socket socketconnection;

  ARMOYU_Socket(this.clientID, this.client_username, this.client_security,
      this.receiverID) {
    connectionSocet();
  }
  Future<void> connectionSocet() async {
    try {
      socketconnection = await Socket.connect(serverHost, serverPort);
      print("Sokete Bağlanıldı.");
    } catch (e) {
      print("Sokete bağlanılamadı :" + e.toString());
    }
  }

  Future<void> sendMessage(SendPort sendport, String input) async {
    var message = {
      "KEY": "1234",
      "sender_id": clientID,
      "sender_username": client_username,
      "sender_security": client_security,
      "receiver_id": receiverID,
      "message_type": "ozel",
      "message": input
    };
    // socket.write(jsonEncode(message));
    try {
      socketconnection.write(jsonEncode(message));
    } catch (e) {
      await connectionSocet();
      sendMessage(sendport, input);
    }
  }

  Future<void> receiveMessages(SendPort sendport) async {
    print("Dinlenme başlatılıyor.");
    await connectionSocet();
    try {
      socketconnection.listen((event) {
        var jsonString = String.fromCharCodes(event);
        var jsonData = jsonDecode(utf8.decode(jsonString.codeUnits));

        Map<String, dynamic> responseData = jsonData;

        if (responseData["receiver_id"].toString() == clientID) {
          sendport.send(jsonString);
        }
      });
    } catch (e) {
      print("Bağlantı hatası: $e");
      await Future.delayed(Duration(seconds: 5));

      await connectionSocet(); // Tekrar bağlan
      receiveMessages(sendport);
    }
  }
}
