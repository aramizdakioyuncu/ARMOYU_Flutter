import 'package:flutter/material.dart';

class TextPage extends StatefulWidget {
  final String texttitle;
  final String textcontent;

  const TextPage({
    super.key,
    required this.texttitle,
    required this.textcontent,
  });

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.texttitle),
        // backgroundColor: ARMOYU.appbarColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              widget.textcontent,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
