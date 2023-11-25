// ignore_for_file: must_call_super, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously, unnecessary_overrides

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../API_Functions/posts.dart';

class PostSharePage extends StatefulWidget {
  final bool appbar;

  PostSharePage({required this.appbar});

  @override
  _PostSharePageState createState() => _PostSharePageState();
}

class _PostSharePageState extends State<PostSharePage>
    with AutomaticKeepAliveClientMixin<PostSharePage> {
  @override
  bool get wantKeepAlive => true;

  TextEditingController textController = TextEditingController();
  List<XFile> imagePath = []; // Birden fazla görseli tutmak için liste

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbar
          ? AppBar(
              backgroundColor: Colors.black,
            )
          : null,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Metin yazma alanı
                TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: "Bir şeyler yaz..."),
                  maxLines: null,
                ),

                // Görsel ekleme alanı
                ElevatedButton(
                  onPressed: () async {
                    List<XFile> selectedImages = await _pickImages();
                    if (selectedImages.isNotEmpty) {
                      setState(() {
                        imagePath.addAll(selectedImages);
                      });
                    }
                  },
                  child: Text("Görsel Ekle"),
                ),

                // Görsellerin önizlemesi
                if (imagePath.isNotEmpty)
                  Column(
                    children: imagePath.map((image) {
                      return Image.file(
                        File(image.path),
                        width: 100,
                        height: 100,
                      );
                    }).toList(),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    FunctionsPosts funct = FunctionsPosts();
                    Map<String, dynamic> response =
                        await funct.share(textController.text, imagePath);
                    if (response["durum"] == 0) {
                      log(response["aciklama"]);
                      return;
                    }

                    if (response["durum"] == 1) {
                      log(response["aciklama"]);

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Paylaş"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<XFile>> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> images = await _picker.pickMultiImage();
    return images;
  }
}
