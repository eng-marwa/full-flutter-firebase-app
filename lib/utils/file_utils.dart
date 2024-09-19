import 'package:image_picker/image_picker.dart';

class FileUtils {
  static Future<String?> getFileName() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      return xFile.path;
    }
    return null;
  }
}
