import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class Base64Helper {
  static Uint8List decodeBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }

  static String encodeImage(File pickedImage) {
    List<int> imageBytes = pickedImage.readAsBytesSync();
    String imageB64 = base64Encode(imageBytes);
    return imageB64;
    //Uint8List decoded = base64Decode(imageB64);
  }
}
