// import 'dart:convert';
// import 'dart:developer';

// import 'package:ARMOYU/app/core/ARMOYU.dart';
// import 'package:ARMOYU/app/Core/AppCore.dart';
// import 'package:ARMOYU/app/data/models/user.dart';
// import 'package:ARMOYU/app/data/models/useraccounts.dart';
// import 'package:ARMOYU/app/functions/functions_service.dart';

// import 'package:ARMOYU/app/widgets/buttons.dart';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NoConnectionPage extends StatefulWidget {
//   const NoConnectionPage({super.key});

//   @override
//   State<NoConnectionPage> createState() => _InternetCheckPageState();
// }

// class _InternetCheckPageState extends State<NoConnectionPage> {
//   bool _isConnected = false;
//   bool connectionProcess = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> checkInternetConnection2() async {
//     connectionProcess = true;

//     log("message");

//     if (await AppCore.checkInternetConnection()) {
//       setState(() {
//         _isConnected = true;
//       });

//       final prefs = await SharedPreferences.getInstance();

//       // Kullanıcı listesini SharedPreferences'den yükleme
//       List<String>? usersJson = prefs.getStringList('users');

//       String? username;
//       String? password;

//       if (usersJson != null) {
//         //Listeye Yükle
//         ARMOYU.appUsers = usersJson
//             .map((userJson) => UserAccounts.fromJson(jsonDecode(userJson)))
//             .toList();
//         for (var element in usersJson) {
//           username = ARMOYU.appUsers[0].user.userName;
//           password = ARMOYU.appUsers[0].user.password;
//           log(element.toString());
//         }
//       }
//       log(ARMOYU.appUsers.length.toString());

//       //Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
//       if (username == null || password == null) {
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => LoginPage(
//                 currentUser: User(userName: "", password: ""),
//               ),
//             ),
//           );
//         }

//         setState(() {
//           _isConnected = false;
//           connectionProcess = false;
//         });
//         return;
//       }
//       FunctionService f =
//           FunctionService(currentUser: User(userName: "", password: ""));

//       Map<String, dynamic> response =
//           await f.login(username.toString(), password.toString(), true);
//       log("Durum ${response["durum"]}");
//       log("aciklama ${response["aciklama"]}");

//       if (response["durum"] == 0) {
//         if (response["aciklama"] == "Hatalı giriş!") {
//           log("Oturum kapatılıyor");
//           if (mounted) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => LoginPage(
//                   currentUser: User(userName: "", password: ""),
//                 ),
//               ),
//             );
//           }

//           setState(() {
//             _isConnected = false;
//             connectionProcess = false;
//           });

//           return;
//         }
//         //Hesap hatalı değil ama bağlantı yoksa
//         setState(() {
//           _isConnected = false;
//           connectionProcess = false;
//         });
//         return;
//       }

//       log("Oturum açılıyor");

//       // if (mounted) {
//       //   Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //       builder: (context) => Pages(
//       //         currentUser: ARMOYU.appUsers[0],
//       //       ),
//       //     ),
//       //   );
//       // }

//       UserAccounts newUser = ARMOYU.appUsers.first;
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AppPage(
//               userID: newUser.user.userID!,
//             ),
//           ),
//         );
//       }

//       setState(() {
//         _isConnected = true;
//         connectionProcess = false;
//       });
//       return;
//     } else {
//       setState(() {
//         _isConnected = false;
//         connectionProcess = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ARMOYU.appbarColor,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _isConnected
//                 ? const Icon(Icons.signal_wifi_4_bar,
//                     size: 80, color: Colors.red)
//                 : const Icon(Icons.signal_wifi_off,
//                     size: 80, color: Colors.red),
//             const SizedBox(height: 20),
//             _isConnected
//                 ? const Text(
//                     "İnternet Sınanıyor...",
//                     style: TextStyle(fontSize: 18),
//                   )
//                 : const Text(
//                     "İnternet Bağlantısı Yok!",
//                     style: TextStyle(fontSize: 18),
//                   ),
//             const SizedBox(height: 20),
//             CustomButtons.costum1(
//                 text: "Tekrar dene",
//                 onPressed: checkInternetConnection2,
//                 loadingStatus: connectionProcess),
//           ],
//         ),
//       ),
//     );
//   }
// }
