// ignore_for_file: must_call_super, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously, unnecessary_overrides, prefer_const_literals_to_create_immutables

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

  TextEditingController postsharetext = TextEditingController();
  bool postshareStatus = false;
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              // height: 30,
              child: Column(children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: "Bir şeyler yaz..."),
                  maxLines: null,
                ),
                ElevatedButton(
                  // Görsel ekleme alanı

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
                  Row(
                    children: imagePath.map((image) {
                      return Image.file(
                        File(image.path),
                        width: 100,
                        height: 100,
                      );
                    }).toList(),
                  ),
              ]),
            ),
            SizedBox(
              height: 400,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (postshareStatus) {
                        return;
                      }

                      postshareStatus = true;
                      FunctionsPosts funct = FunctionsPosts();
                      Map<String, dynamic> response =
                          await funct.share(textController.text, imagePath);
                      if (response["durum"] == 0) {
                        postsharetext.text = response["aciklama"].toString();
                        postshareStatus = false;
                        return;
                      }

                      if (response["durum"] == 1) {
                        postsharetext.text = response["aciklama"].toString();
                        postshareStatus = false;

                        Navigator.of(context).pop();
                      }
                    },
                    child: Column(
                      children: [
                        Visibility(
                          visible: !postshareStatus,
                          child: Text("Paylaş"),
                        ),
                        Visibility(
                          visible: postshareStatus,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: CircularProgressIndicator(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(postsharetext.text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<XFile>> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> images = await _picker.pickMultiImage();
    return images;
  }
}
