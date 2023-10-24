// import 'package:flutter/material.dart';
// import 'package:theme_provider/theme_provider.dart';

// class Site extends StatefulWidget {
//   String verilink, veribaslik;
//   Site({
//     required this.verilink,
//     required this.veribaslik,
//   });
//   @override
//   _SiteState createState() => _SiteState();
// }

// class _SiteState extends State<Site> {
//   late WebViewController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return ThemeConsumer(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back,
//             ),
//           ),
//           title: Text(widget.veribaslik),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 _controller.reload();
//               },
//               icon: Icon(Icons.refresh),
//             ),
//           ],
//         ),
//         body: WebView(
//           onWebViewCreated: (_controller) {
//             this._controller = _controller;
//           },
//           javascriptMode: JavascriptMode.unrestricted,
//           zoomEnabled: false,
//           initialUrl: widget.verilink,
//         ),
//       ),
//     );
//   }
// }
