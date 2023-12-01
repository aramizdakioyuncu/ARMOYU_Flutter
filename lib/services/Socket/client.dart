// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:isolate';

import 'package:ARMOYU/Services/Socket/socket.dart';

Future<void> main() async {
  //Flutter
  String clientID = "1";
  String receiverID = "123";

  if (1 == 1) {
    print('Kimliğinizi girin: ');
    clientID = stdin.readLineSync()!;

    print('Alıcı kimliği girin: ');
    receiverID = stdin.readLineSync()!;
  }

  try {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;

    final socketInfo = {
      'socket': sendPort,
      'clientID': clientID,
      'receiverID': receiverID,
    };

    sendPort.send(
      {
        'socket': sendPort,
        'clientID': clientID,
        'receiverID': receiverID,
      },
    );
    Isolate.spawn(isolateSendMessage, socketInfo);

    Isolate.spawn(isolateListenMessage, socketInfo);

    receivePort.listen(
      (message) {
        print(message);
      },
    );
  } catch (e) {
    print('Hata: $e');
  }
}

Future<void> isolateSendMessage(dynamic message) async {
  final socketInfo = message as Map<String, dynamic>;

  SendPort sendport = socketInfo['socket'];
  final clientID = socketInfo['clientID'].toString();
  final receiverID = socketInfo['receiverID'].toString();

  try {
    var socket = await Socket.connect(
        ARMOYU_Socket.serverHost, ARMOYU_Socket.serverPort);

    while (true) {
      ARMOYU_Socket socket2 = ARMOYU_Socket(socket, clientID, receiverID);
      socket2.sendMessage(sendport);
      // await Future.delayed(Duration(seconds: 1));
    }
  } catch (e) {
    print(e);
  }
}

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
