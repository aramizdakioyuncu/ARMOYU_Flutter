import 'dart:developer';
import 'dart:io';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

int camScreen = 0;

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<XFile> imagePath = [];
  List<Media> media = [];
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      log(cameras.length.toString());

      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras[camScreen],
          ResolutionPreset.medium,
        );
        await _controller.initialize();
      } else {
        // throw CameraException('No cameras available');
      }
    } on CameraException catch (e) {
      debugPrint('Error: $e');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _changeCamera() async {
    // Eğer kamera denetleyicisi varsa, onu kapat
    await _controller.dispose();

    // Kamera yönünü değiştir
    if (camScreen == 1) {
      camScreen = 0;
    } else {
      camScreen = 1;
    }

    // Yeni kamera tanımını al ve başlat
    setState(() {
      _initializeControllerFuture = _initializeCamera();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _takePicture() async {
    try {
      final XFile picture = await _controller.takePicture();
      // Alınan resmi kullanabilirsiniz
      setState(() {
        imagePath.add(picture);

        media.add(
          Media(
            mediaID: picture.hashCode,
            mediaURL: MediaURL(
                bigURL: picture.path,
                normalURL: picture.path,
                minURL: picture.path),
          ),
        );
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(child: CameraPreview(_controller)),
                SizedBox(
                  height: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _takePicture,
                          child: const Icon(
                            Icons.camera,
                            size: 45,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _takePicture,
                          child: const Icon(
                            Icons.camera,
                            size: 45,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _changeCamera,
                          child: const Icon(
                            Icons.change_circle,
                            size: 45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (media.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: media.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MediaViewer(
                                    media: media,
                                    initialIndex: index,
                                    isFile: true,
                                  ),
                                ));
                              },
                              child: Image.file(
                                File(media[index].mediaURL.bigURL),
                                width: 100,
                                height: 100,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
