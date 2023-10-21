import 'package:image_picker/image_picker.dart';

class GalleryService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<List<XFile>> pickImages() async {
    final pickedImages = await _imagePicker.pickMultiImage();
    return pickedImages ?? [];
  }
}
