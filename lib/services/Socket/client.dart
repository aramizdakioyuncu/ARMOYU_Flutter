// import 'package:socket_io_client/socket_io_client.dart' as IO;

// main() {
//   print("Socket işlemi başlıyor");
//   // Dart client
//   IO.Socket socket = IO.io('http://localhost:12345');
//   socket.onConnect((_) {
//     print('connect');
//     socket.emit('msg', 'test');
//   });
//   socket.on('event', (data) => print(data));
//   socket.onDisconnect((_) => print('disconnect'));
//   socket.on('fromServer', (_) => print(_));
//   socket.connect();
// }
