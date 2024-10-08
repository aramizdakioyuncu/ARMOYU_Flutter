// import 'dart:developer';

// import 'package:ARMOYU/app/core/ARMOYU.dart';
// import 'package:ARMOYU/app/core/widgets.dart';
// import 'package:ARMOYU/app/functions/API_Functions/loginregister.dart';
// import 'package:ARMOYU/app/functions/functions_service.dart';
// import 'package:ARMOYU/app/data/models/user.dart';
// import 'package:ARMOYU/app/data/models/useraccounts.dart';
// import 'package:ARMOYU/app/modules/apppage/views/eski_app_page.dart';
// import 'package:ARMOYU/app/widgets/text.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// import 'package:ARMOYU/app/widgets/buttons.dart';
// import 'package:ARMOYU/app/widgets/textfields.dart';
// import 'package:shimmer/shimmer.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _lastnameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _rpasswordController = TextEditingController();
//   final TextEditingController _inviteController = TextEditingController();

//   bool registerProccess = false;
//   bool inviteCodeProcces = false;

//   String? inviteduserID;
//   String? inviteduserdisplayName;
//   String? inviteduseravatar;

//   void setstatefunction() {
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> invitecodeTester(String code) async {
//     if (inviteCodeProcces) {
//       return;
//     }
//     setState(() {
//       inviteCodeProcces = true;
//     });

//     FunctionsLoginRegister f =
//         FunctionsLoginRegister(currentUser: User(userName: "", password: ""));
//     Map<String, dynamic> response = await f.inviteCodeTest(code);
//     if (response["durum"] == 0) {
//       log(response["aciklama"].toString());
//       if (mounted) {
//         ARMOYUWidget.stackbarNotification(context, response["aciklama"]);
//       }
//       setState(() {
//         inviteCodeProcces = false;
//       });
//       return;
//     }
//     log(inviteduserID = response["aciklamadetay"]["oyuncu_ID"].toString());
//     log(inviteduseravatar =
//         response["aciklamadetay"]["oyuncu_avatar"].toString());
//     log(inviteduserdisplayName =
//         response["aciklamadetay"]["oyuncu_displayName"].toString());
//     setState(() {
//       inviteCodeProcces = false;
//     });
//   }

//   Future<void> _register() async {
//     if (registerProccess) {
//       return;
//     }
//     setState(() {
//       registerProccess = true;
//     });
//     // Kayıt işlemini burada gerçekleştirin
//     final username = _usernameController.text;
//     final name = _nameController.text;
//     final lastname = _lastnameController.text;
//     final email = _emailController.text;
//     final password = _passwordController.text;
//     final rpassword = _rpasswordController.text;
//     final inviteCode = _inviteController.text;

//     if (name == "" ||
//         username == "" ||
//         lastname == "" ||
//         email == "" ||
//         password == "" ||
//         rpassword == "") {
//       String text = "Boş alan bırakmayınız!";
//       ARMOYUWidget.stackbarNotification(context, text);
//       log(text);

//       setState(() {
//         registerProccess = false;
//       });
//       return;
//     }
//     if (password != rpassword) {
//       String text = "Parolalarınız eşleşmedi!";
//       ARMOYUWidget.stackbarNotification(context, text);
//       log(text);

//       setState(() {
//         registerProccess = false;
//       });
//       return;
//     }

//     FunctionService f =
//         FunctionService(currentUser: User(userName: "", password: ""));
//     Map<String, dynamic> response = await f.register(
//         username, name, lastname, email, password, rpassword, inviteCode);

//     if (response["durum"] == 0) {
//       String text = response["aciklama"];
//       if (mounted) {
//         ARMOYUWidget.stackbarNotification(context, text);
//       }
//       setState(() {
//         registerProccess = false;
//       });
//       return;
//     }

//     if (response["durum"] == 1) {
//       Map<String, dynamic> loginresponse =
//           await f.login(username, password, true);

//       if (loginresponse["aciklama"] == "Başarılı.") {
//         // if (mounted) {
//         //   Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (context) => Pages(
//         //         currentUser: ARMOYU.appUsers[0],
//         //       ),
//         //     ),
//         //   );
//         // }

//         UserAccounts newUser = ARMOYU.appUsers.first;
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AppPage(
//                 userID: newUser.user.userID!,
//               ),
//             ),
//           );
//         }

//         return;
//       }

//       setState(() {
//         registerProccess = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ARMOYU.backgroundcolor,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 100),
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Image.asset(
//                 'assets/images/armoyu512.png',
//                 height: 150,
//                 width: 150,
//               ),
//             ),
//             CustomTextfields(setstate: setstatefunction).costum3(
//               title: "Adınız",
//               controller: _nameController,
//               isPassword: false,
//               preicon: const Icon(Icons.person),
//             ),
//             const SizedBox(height: 16),
//             CustomTextfields(setstate: setstatefunction).costum3(
//               title: "Soyadınız",
//               controller: _lastnameController,
//               isPassword: false,
//               preicon: const Icon(Icons.person),
//             ),
//             const SizedBox(height: 16),
//             CustomTextfields(setstate: setstatefunction).costum3(
//               title: "Kullanıcı Adınız",
//               controller: _usernameController,
//               isPassword: false,
//               preicon: const Icon(Icons.person),
//             ),
//             const SizedBox(height: 16),
//             CustomTextfields(setstate: setstatefunction).costum3(
//               title: "E-posta",
//               controller: _emailController,
//               isPassword: false,
//               preicon: const Icon(Icons.email),
//               type: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 16),
//             CustomTextfields(setstate: setstatefunction).costum3(
//               title: "Şifreniz",
//               controller: _passwordController,
//               isPassword: true,
//               preicon: const Icon(Icons.lock_outline),
//             ),
//             const SizedBox(height: 16),
//             CustomTextfields(setstate: setstatefunction).costum3(
//               title: "Şifreniz Tekrar",
//               controller: _rpasswordController,
//               isPassword: true,
//               preicon: const Icon(Icons.lock_outline),
//             ),
//             const SizedBox(height: 16),
//             inviteduseravatar == null
//                 ? Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextfields(setstate: setstatefunction)
//                             .costum3(
//                           title: "Davet Kodu",
//                           controller: _inviteController,
//                           isPassword: false,
//                           maxLength: 5,
//                           preicon: const Icon(Icons.people),
//                           suffixiconbutton: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   if (_inviteController.text.length == 5) {
//                                     log("5 karakter yazıldı: ${_inviteController.text}");
//                                     invitecodeTester(_inviteController.text);
//                                   }
//                                 });
//                               },
//                               icon: const Icon(Icons.refresh)),
//                           onChanged: (value) {
//                             if (value.length == 5) {
//                               invitecodeTester(value);
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   )
//                 : ListTile(
//                     contentPadding:
//                         const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
//                     tileColor: ARMOYU.textbackColor,
//                     leading: inviteduseravatar != null
//                         ? CircleAvatar(
//                             foregroundImage: CachedNetworkImageProvider(
//                               inviteduseravatar.toString(),
//                             ),
//                           )
//                         : Shimmer.fromColors(
//                             baseColor: ARMOYU.baseColor,
//                             highlightColor: ARMOYU.highlightColor,
//                             child: const CircleAvatar(
//                               radius: 30.0, // Adjust the radius as needed
//                               backgroundColor: Colors.white,
//                             ),
//                           ),
//                     //  const SkeletonAvatar(
//                     //     style: SkeletonAvatarStyle(
//                     //       borderRadius: BorderRadius.all(
//                     //         Radius.circular(30),
//                     //       ),
//                     //     ),
//                     //   ),
//                     title: inviteduserdisplayName != null
//                         ? Text(inviteduserdisplayName.toString())
//                         : Shimmer.fromColors(
//                             baseColor: ARMOYU.baseColor,
//                             highlightColor: ARMOYU.highlightColor,
//                             child: Container(width: 200),
//                           ),
//                     // const SkeletonLine(
//                     //     style: SkeletonLineStyle(width: 200),
//                     //   ),
//                     trailing: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           inviteduserID = null;
//                           inviteduseravatar = null;
//                           inviteduserdisplayName = null;
//                         });
//                       },
//                       icon: const Icon(Icons.close, color: Colors.red),
//                     ),
//                   ),
//             const SizedBox(height: 16),
//             CustomButtons.costum1(
//               text: "Kayıt Ol",
//               onPressed: _register,
//               loadingStatus: registerProccess,
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomText.costum1("Hesabınız varsa  "),
//                 InkWell(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: CustomText.costum1("Giriş Yap"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 60),
//           ],
//         ),
//       ),
//     );
//   }
// }
