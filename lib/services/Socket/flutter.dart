// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ARMOYU/Services/Socket/socket.dart';

Future<void> isolateListenMessage(dynamic message) async {
  final socketInfo = message as Map<String, dynamic>;

  SendPort sendport = socketInfo['socket'];
  final clientID = socketInfo['clientID'].toString();
  final receiverID = socketInfo['receiverID'].toString();

  try {
    var socket = await Socket.connect(
        ARMOYU_Socket.serverHost, ARMOYU_Socket.serverPort);
    ARMOYU_Socket socket2 = ARMOYU_Socket(socket, clientID, receiverID);
    socket2.receiveMessages(sendport);
  } catch (e) {
    print(e);
  }
  // await Future.delayed(Duration(seconds: 1));
}

void main() {
  //Flutter
  String clientID = "1";
  String receiverID = "123";

  try {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;

    final socketInfo = {
      'socket': sendPort,
      'clientID': clientID,
      'receiverID': receiverID,
    };

    sendPort.send({
      'socket': sendPort,
      'clientID': clientID,
      'receiverID': receiverID,
    });
    // Isolate.spawn(isolateSendMessage, socketInfo);

    Isolate.spawn(isolateListenMessage, socketInfo);

    receivePort.listen((message) {
      print(message);
    });
  } catch (e) {
    print('Hata: $e');
  }
}
