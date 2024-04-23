import 'dart:developer';
import 'dart:io';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Models/Camera/camfilter.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final bool canPop;
  const CameraScreen({
    super.key,
    required this.canPop,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

int _camScreen = 0;
int _filterpage = 0;
Color? _filterColor;
bool _takePictureProcess = false;
String? _viewMedia;

double _currentZoom = 1;

FlashMode _flashMode = FlashMode.off;
IconData _flashIcon = Icons.flash_off_rounded;
List<XFile> _imagePath = [];
List<Media> _media = [];
List<FilterItem> _camfilter = [];

late PageController _camfiltercontroller;

late CameraController _cameraController;
late Future<void> _initializeControllerFuture;
late double _maxZoom;
late double _minZoom;

bool _savemediaProcess = false;

bool _isfirstProcess = true;

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();

    _camfiltercontroller = PageController(
      viewportFraction: 0.2,
      initialPage: _filterpage,
      keepPage: true,
    );

    if (_isfirstProcess) {
      _camfilter.add(
        FilterItem(
          onFilterSelected: () => _takePicture(),
        ),
      );
      _camfilter.add(
        FilterItem(
          color: Colors.white,
          onFilterSelected: () => _takePicture(color: Colors.white),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              normalURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              minURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
            ),
          ),
        ),
      );

      _camfilter.add(
        FilterItem(
          color: Colors.grey,
          onFilterSelected: () => _takePicture(color: Colors.grey),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              normalURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              minURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
            ),
          ),
        ),
      );
      _camfilter.add(
        FilterItem(
          color: Colors.red,
          onFilterSelected: () => _takePicture(color: Colors.red),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              normalURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              minURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
            ),
          ),
        ),
      );
      _camfilter.add(
        FilterItem(
          color: Colors.yellow,
          onFilterSelected: () => _takePicture(color: Colors.yellow),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              normalURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              minURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
            ),
          ),
        ),
      );
      _camfilter.add(
        FilterItem(
          color: Colors.green,
          onFilterSelected: () => _takePicture(color: Colors.green),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              normalURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
              minURL:
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp",
            ),
          ),
        ),
      );
      _isfirstProcess = false;
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[_camScreen],
          ResolutionPreset.medium,
        );
        await _cameraController.initialize();

        _maxZoom = await _cameraController.getMaxZoomLevel();
        _minZoom = await _cameraController.getMinZoomLevel();

        _cameraController.setZoomLevel(_currentZoom);
        setstatefunction();
      } else {
        // throw CameraException('No cameras available');
      }
    } on CameraException catch (e) {
      debugPrint('Error: $e');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _takePicture({Color? color}) async {
    _cameraController.setFlashMode(_flashMode);
    if (_takePictureProcess) {
      return;
    }
    _takePictureProcess = true;
    setstatefunction();
    try {
      final XFile picture = await _cameraController.takePicture();

      _imagePath.add(picture);

      _media.add(
        Media(
          mediaXFile: picture,
          mediaID: picture.hashCode,
          mediaURL: MediaURL(
            bigURL: picture.path,
            normalURL: picture.path,
            minURL: picture.path,
          ),
        ),
      );

      _camfilter.insert(
        0,
        FilterItem(
          media: Media(
            mediaXFile: picture,
            mediaID: picture.hashCode,
            mediaURL: MediaURL(
              bigURL: picture.path,
              normalURL: picture.path,
              minURL: picture.path,
            ),
          ),
          isImage: true,
        ),
      );

      _filterpage++;
      _camfiltercontroller.jumpToPage(_filterpage);
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }

    _takePictureProcess = false;
    setstatefunction();
  }

  void _changeflash() {
    if (_flashIcon == Icons.flash_auto_rounded) {
      _flashIcon = Icons.flash_on_rounded;
      _flashMode = FlashMode.always;
    } else if (_flashIcon == Icons.flash_on_rounded) {
      _flashIcon = Icons.flash_off_rounded;
      _flashMode = FlashMode.off;
    } else if (_flashIcon == Icons.flash_off_rounded) {
      _flashIcon = Icons.flash_auto_rounded;
      _flashMode = FlashMode.auto;
    }

    setstatefunction();
  }

  void _changeCamera() async {
    await _cameraController.dispose();

    if (_camScreen == 1) {
      _camScreen = 0;
    } else {
      _camScreen = 1;
    }

    _initializeCamera();
  }

  Future<void> _saveMedia() async {
    if (_savemediaProcess) {
      return;
    }

    _savemediaProcess = true;

    setstatefunction();
    FunctionsMedia f = FunctionsMedia();
    Map<String, dynamic> response =
        await f.upload(category: "-1", files: [_camfilter[_filterpage].media!]);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _savemediaProcess = false;
      _camfilter[_filterpage].loadingStatus = false;

      setstatefunction();

      return;
    }

    _camfilter[_filterpage].loadingStatus = true;
    _savemediaProcess = false;
    setstatefunction();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: ARMOYU.screenHeight,
                        width: ARMOYU.screenWidth,
                        child: _viewMedia == null
                            ? _filterColor != null
                                ? FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _cameraController
                                          .value.previewSize!.height,
                                      height: _cameraController
                                          .value.previewSize!.width,
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          _filterColor!.withOpacity(
                                            0.5,
                                          ),
                                          BlendMode.color,
                                        ),
                                        child: CameraPreview(_cameraController),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onScaleUpdate: (details) {
                                      double newScale;
                                      log(details.scale.toString());

                                      if (details.scale < 1) {
                                        newScale = _currentZoom - 0.04;
                                      } else {
                                        newScale = _currentZoom + 0.04;
                                      }

                                      log(newScale.toString());

                                      if (_maxZoom < newScale) {
                                        _currentZoom = _maxZoom;
                                        _cameraController
                                            .setZoomLevel(_currentZoom);
                                        return;
                                      }
                                      if (_minZoom > newScale) {
                                        _currentZoom = _minZoom;
                                        _cameraController
                                            .setZoomLevel(_currentZoom);
                                        return;
                                      }

                                      _currentZoom = newScale;
                                      _cameraController
                                          .setZoomLevel(_currentZoom);
                                    },
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width: _cameraController
                                            .value.previewSize!.height,
                                        height: _cameraController
                                            .value.previewSize!.width,
                                        child: CameraPreview(_cameraController),
                                      ),
                                    ),
                                  )
                            : Image.file(
                                File(
                                  _viewMedia!,
                                ),
                                fit: BoxFit.contain,
                              ),
                      ),
                      Visibility(
                        visible: widget.canPop,
                        child: Positioned(
                          top: 40,
                          left: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, _media);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _viewMedia == null,
                        child: Positioned(
                          top: 40,
                          right: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: ARMOYU.cameras!.length > 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: InkWell(
                                        onTap: _changeCamera,
                                        child: const Icon(
                                          Icons.change_circle,
                                          size: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        _changeflash();
                                      },
                                      child: Icon(
                                        _flashIcon,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      foregroundImage:
                                          CachedNetworkImageProvider(
                                        ARMOYU
                                            .appUser.avatar!.mediaURL.normalURL,
                                      ),
                                      radius: 12,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      foregroundImage:
                                          CachedNetworkImageProvider(
                                        ARMOYU
                                            .appUser.avatar!.mediaURL.normalURL,
                                      ),
                                      radius: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _viewMedia != null &&
                            !_camfilter[_filterpage].loadingStatus,
                        child: Positioned(
                          bottom: 10,
                          left: 10,
                          child: CustomButtons.costum2(
                            onPressed: () => _saveMedia(),
                            text: "Kaydet",
                            icon: const Icon(
                              Icons.save_alt_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                            loadingStatus: _savemediaProcess,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        width: ARMOYU.screenWidth,
                        child: SizedBox(
                          height: 70,
                          child: PageView.builder(
                            controller: _camfiltercontroller,
                            physics: _takePictureProcess
                                ? const NeverScrollableScrollPhysics()
                                : const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: _camfilter.length,
                            onPageChanged: (value) {
                              _filterpage = value;
                              _camfilter[value].isSelected = true;

                              try {
                                _camfilter[value - 1].isSelected = false;
                              } catch (e) {
                                log(e.toString());
                              }
                              try {
                                _camfilter[value + 1].isSelected = false;
                              } catch (e) {
                                log(e.toString());
                              }

                              if (_camfilter[value].color != null) {
                                _filterColor = _camfilter[value].color;
                              } else {
                                _filterColor = null;
                              }

                              if (_camfilter[value].isImage! &&
                                  _camfilter[value].media != null) {
                                _viewMedia =
                                    _camfilter[value].media!.mediaURL.normalURL;
                                setstatefunction();
                              } else {
                                _viewMedia = null;
                                setstatefunction();
                              }
                            },
                            itemBuilder: (context, index) {
                              if (index == _filterpage) {
                                _camfilter[index].isSelected = true;
                              }
                              return Center(
                                child: _camfilter[index].filterWidget(
                                    context, _camfiltercontroller, index),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
