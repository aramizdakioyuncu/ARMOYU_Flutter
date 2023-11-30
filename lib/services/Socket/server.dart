// import 'package:socket_io/socket_io.dart';

// main() {
//   // Dart server
//   var io = new Server();
//   var nsp = io.of('/some');
//   nsp.on('connection', (client) {
//     print('connection /some');
//     client.on('msg', (data) {
//       print('data from /some => $data');
//       client.emit('fromServer', "ok 2");
//     });
//   });
//   io.on('connection', (client) {
//     print('connection default namespace');
//     client.on('msg', (data) {
//       print('data from default => $data');
//       client.emit('fromServer', "ok");
//     });
//   });
//   io.listen(3000);
// }
