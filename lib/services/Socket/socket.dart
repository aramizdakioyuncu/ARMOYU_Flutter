// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

class Socket2 {
  static String serverHost = 'localhost';
  static int serverPort = 12345;
  Socket socket;
  String clientID;
  String receiverID;

  Socket2(this.socket, this.clientID, this.receiverID);

  void sendMessage() {
    var input = stdin.readLineSync()!;
    var message = {
      "KEY": "1234",
      "sender_id": clientID,
      "receiver_id": receiverID,
      "message": input
    };

    print('$clientID: $input');

    socket.write(jsonEncode(message));
  }

  void receiveMessages() {
    print("Dinlenme başlatılıyor.");
    socket.listen((event) {
      var jsonString = String.fromCharCodes(event);
      var jsonData = jsonDecode(jsonString);

      Map<String, dynamic> responseData = jsonData;

      if (responseData["receiver_id"].toString() == clientID) {
        print('${responseData["sender_id"]}: ${responseData["message"]}');
      }
    });
  }
}

Future<void> main() async {
  stdout.write('Kimliğinizi girin: ');
  var clientID = stdin.readLineSync()!;

  stdout.write('Alıcı kimliği girin: ');
  var receiverID = stdin.readLineSync()!;

  try {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;

    sendPort.send({
      'clientID': clientID,
      'receiverID': receiverID,
    });

    final socketInfo = {
      'clientID': clientID,
      'receiverID': receiverID,
    };
    Isolate.spawn(isolateFunction, socketInfo);

    Isolate.spawn(isolateFunction2, socketInfo);

    receivePort.listen((message) {
      print(message);
    });
    // Yeni bir izolat oluştur ve istemciyi işle
  } catch (e) {
    print('Hata: $e');
  }
}

Future<void> isolateFunction(dynamic message) async {
  final socketInfo = message as Map<String, dynamic>;

  final clientID = socketInfo['clientID'].toString();
  final receiverID = socketInfo['receiverID'].toString();

  var socket = await Socket.connect(Socket2.serverHost, Socket2.serverPort);
  while (true) {
    Socket2 socket2 = Socket2(socket, clientID, receiverID);
    socket2.sendMessage();
    await Future.delayed(Duration(seconds: 1));
  }
}

Future<void> isolateFunction2(dynamic message) async {
  final socketInfo = message as Map<String, dynamic>;

  final clientID = socketInfo['clientID'].toString();
  final receiverID = socketInfo['receiverID'].toString();

  var socket = await Socket.connect(Socket2.serverHost, Socket2.serverPort);
  Socket2 socket2 = Socket2(socket, clientID, receiverID);
  socket2.receiveMessages();
  await Future.delayed(Duration(seconds: 1));
}
