import 'dart:io';
import 'package:image/image.dart';

class FileUtil {
  static Map getImageSize(File file) {
    var image = decodeImage(file.readAsBytesSync())!;
    return {"width": image.width, "height": image.height};
  }
}
