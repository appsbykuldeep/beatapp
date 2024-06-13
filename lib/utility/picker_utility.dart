//import 'package:flutter_tts/flutter_tts.dart';

import 'package:image_picker/image_picker.dart';

class PickerUtils {
  //static final FlutterTts flutterTts = FlutterTts();

  static Future speak(String text) async {
    /*await flutterTts.setLanguage("es-MX");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);*/
  }

  Future stop() async {
    //await flutterTts.stop();
  }

  var picture;
  /*final ImagePicker _picker = ImagePicker();
  // Pick an image
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  // Capture a photo
  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  // Pick a video
  final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);
  // Capture a video
  final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
  // Pick multiple images
  final List<XFile>? images = await _picker.pickMultiImage();*/

  void openCamera() async {
    picture = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    //print(picture);
    return picture;
  }

  openGallery() async {
    picture = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    //print(picture);
    return picture;
  }
}
