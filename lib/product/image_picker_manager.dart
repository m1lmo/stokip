import 'package:image_picker/image_picker.dart';

class ImageUploadManager {
  Future<XFile?> fetchFromLibrary() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    return image;
  }
}
