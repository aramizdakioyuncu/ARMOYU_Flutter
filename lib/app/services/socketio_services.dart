import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Chat/chat_message.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketioController extends GetxController {
  late IO.Socket socket;
  var socketChatStatus = false.obs;

  Timer? userListTimer;
  Timer? pingTimer;
  var pingID = "".obs;

  var pingValue = 0.obs; // Ping değerini reaktif hale getirdik
  DateTime? lastPingTime; // Son ping zamanı
  String socketPREFIX = "||SOCKET|| -> ";

  var isCallingMe = false.obs;
  var whichuserisCallingMe = "".obs;

  var isSoundStreaming = false.obs;

  @override
  void onInit() {
    super.onInit();
    socketInit();
    socket.connect();
  }

  @override
  void onClose() {
    stopPing();
    socket.disconnect();
    super.onClose();
  }

  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));

  void updateuseraccount() {
    pingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //* *//
      final findCurrentAccountController = Get.find<AccountUserController>();
      //* *//

      currentUserAccounts.value =
          findCurrentAccountController.currentUserAccounts.value;

      currentUserAccounts.value =
          findCurrentAccountController.currentUserAccounts.value;
    });
  }

  socketInit() {
    updateuseraccount();

    // Socket.IO'ya bağlanma
    socket = IO.io('http://mc.armoyu.com:2020', <String, dynamic>{
      // socket = IO.io('http://10.0.2.2:2020', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    startPing(const Duration(seconds: 2));
    // Ping değerini güncelle

    socket.on('ping', (data) {
      // Burada data yerine ping zamanı verilmez.
      pingValue.value = data; // Bu satırda hata var
      log('${socketPREFIX}Ping: ${pingValue.value} ms'); // Log ile göster
    });

    // Pong mesajını dinle
    socket.on('pong', (data) {
      // data içinde ping ID'sini al

      String pingId = data['id'];
      if (pingId != pingID.value) {
        log("PING ID eşleşmedi: Beklenen ${pingID.value}, gelen $pingId");
        return;
      }

      DateTime pongReceivedTime = DateTime.now(); // Pong zamanı
      if (lastPingTime != null) {
        // Ping süresini hesapla
        pingValue.value =
            pongReceivedTime.difference(lastPingTime!).inMilliseconds;
        // log('Pong yanıtı alındı: $pingId');
        log('Ping süresi: ${pingValue.value} ms');
      }
    });

    socket.on('signaling', (data) {
      // Signaling verilerini dinleme
      log('Signaling verisi alındı: $data');
    });

    socket.on('INCOMING_CALL', (data) {
      // Signaling verilerini dinleme

      log('Kullanıcı Seni Arıyor: ${data['callerId']}');

      isCallingMe.value = true;
      whichuserisCallingMe.value = data['callerId'];
    });

    socket.on('CALL_ACCEPTED', (data) {
      // Signaling verilerini dinleme
      log('Çağrı kabul edildi: $data');
    });

    socket.on('CALL_CLOSED', (data) {
      // Signaling verilerini dinleme
      log('Çağrı reddedildi: $data');
    });

    // Başka biri bağlandığında bildiri al
    socket.on('userConnected', (data) {
      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      log(socketPREFIX + data.toString());
    });
    // Bağlantı başarılı olduğunda
    socket.on('connect', (data) {
      log('${socketPREFIX}Bağlandı');

      if (data != null) {
        log(socketPREFIX + data.toString());
      }
      socketChatStatus.value = true;

      // Kullanıcıyı kaydet
      registerUser(currentUserAccounts.value.user.value);
    });

    // Bağlantı kesildiğinde
    socket.on('disconnect', (data) {
      try {
        log('$socketPREFIX$data');
      } catch (e) {
        log('${socketPREFIX}Hata (disconnect): $e');
      }
      log('${socketPREFIX}Bağlantı kesildi');
      socketChatStatus.value = false;
    });

    // Sunucudan gelen mesajları dinleme
    socket.on('chat', (data) {
      ChatMessage chatData = ChatMessage.fromJson(data);

      log("$socketPREFIX${chatData.user.displayName} - ${chatData.messageContext}");

      currentUserAccounts.value.user.value.chatlist ??= <Chat>[].obs;

      bool chatisthere = currentUserAccounts.value.user.value.chatlist!.any(
        (chat) => chat.user.userID == chatData.user.userID,
      );

      ChatMessage chat = ChatMessage(
        messageID: 0,
        messageContext: chatData.messageContext,
        user: chatData.user,
        isMe: false,
      );
      if (!chatisthere) {
        currentUserAccounts.value.user.value.chatlist!.add(
          Chat(
            user: chatData.user,
            chatNotification: false,
            lastmessage: chat.obs,
            messages: <ChatMessage>[].obs,
          ),
        );
      }

      Chat a = currentUserAccounts.value.user.value.chatlist!.firstWhere(
        (chat) => chat.user.userID == chatData.user.userID,
      );

      a.messages ??= <ChatMessage>[].obs;
      a.messages!.add(chat);
      //Son mesajı görünümü güncelle
      a.lastmessage!.value = chat;

      currentUserAccounts.value.user.value.chatlist!.refresh();
    });

    // Otomatik olarak bağlanma
    socket.connect();

    return this;
  }

  // Socket.io ile mesaj gönderme
  void sendMessage(ChatMessage data, userID) {
    socket.emit("chat", {data.toJson(), userID});
  }

  // Socket.io birisini arama
  Future<void> callUser(User user) async {
    socket.emit("CALL_USER", {user.userName});
  }

  // Socket.io  arama reddetme
  void closecall(String username) {
    socket.emit("CLOSE_CALL", username);

    whichuserisCallingMe.value = "";
    isCallingMe.value = false;
  }

  // Socket.io  arama açma
  void acceptcall(String username) {
    socket.emit("ACCEPT_CALL", username);

    whichuserisCallingMe.value = "";
    isCallingMe.value = false;
  }

  // Kullanıcıyı sunucuya kaydetme
  void registerUser(User user) {
    log("Kullanıcı Register Kaydı");
    socket.emit('REGISTER', {
      'name': user.userName,
      'clientId': user.toJson(),
    });
  }

  void fetchUserList({int? groupID}) {
    // Sunucudan kullanıcı listesi isteme
    socket.emit('USER_LIST', {
      "groupID": groupID,
    });
  }

  void startPing(Duration interval) {
    pingTimer = Timer.periodic(interval, (timer) {
      pingID.value =
          "${DateTime.now().millisecondsSinceEpoch}-${currentUserAccounts.value.user.value.userID}";
      // log('Ping gönderiliyor... ID: ${pingID.value}');

      lastPingTime = DateTime.now();
      socket.emit('ping', {'id': pingID.value}); // ID ile ping gönder
    });
  }

  void stopPing() {
    // Timer durdurma (iptal etme)
    if (pingTimer != null) {
      pingTimer!.cancel();
      pingTimer = null;
    }
  }

  // void micOnOff(User user) {
  //   var speaker = user.speaker;
  //   var mic = user.microphone;
  //   mic.value = !mic.value;

  //   if (mic.value == true && speaker.value == false) {
  //     speaker.value = true;
  //   }

  //   userUpdate(user);
  // }

  // void speakerOnOff(User user) {
  //   var speaker = user.speaker;
  //   var mic = user.microphone;

  //   speaker.value = !speaker.value;

  //   mic.value = speaker.value;

  //   userUpdate(user);
  // }

  void userUpdate(User user) {
    try {
      log("Bilgiler Güncellendi");

      socket.emit('profileUpdate', user.toJson());
    } catch (e) {
      log("${socketPREFIX}Hata(changeRoom) $e");
    }
  }
}
