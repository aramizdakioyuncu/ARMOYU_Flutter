// ignore_for_file: unused_field

import 'package:image_picker/image_picker.dart';

class GalleryService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<List<XFile>> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> images = await _picker.pickMultiImage();
    return images;
  }
}
