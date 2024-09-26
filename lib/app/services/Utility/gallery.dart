import 'package:image_picker/image_picker.dart';

class GalleryService {
  Future<List<XFile>> pickImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> images = await picker.pickMultiImage();
    return images;
  }
}
