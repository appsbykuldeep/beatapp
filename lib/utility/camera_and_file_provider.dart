import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:beatapp/utility/permission_helper.dart';
import 'package:external_path/external_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';

class CameraAndFileProvider {
  final ImagePicker _picker = ImagePicker();

  // Pick an image
  pickImageFromGallary() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image!;
  }

  // Capture a photo
  Future<File?> pickImageFromCamera() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 20);
    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }

  // Pick a video
  pickVideoFromGallary() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    return video!;
  }

  // Capture a video
  pickVideoFromCamera() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    return video!;
  }

  // Pick multiple images
  pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    return images;
  }

  static Future saveInStorage(
      String fileName, File file, String extension) async {
    if (await PermissionHelper().checkCameraPermission()) {
      String localPath = await getPathDownload();
      String filePath =
          "$localPath/${fileName.trim()}_${DateTime.now().millisecondsSinceEpoch}$extension";

      File fileDef = File(filePath);
      await fileDef.create(recursive: true);
      Uint8List bytes = await file.readAsBytes();
      await fileDef.writeAsBytes(bytes);
    }
  }

  static Future saveBytesInStorage(
      String fileName, List<int> bytes, String extension) async {
    if (await PermissionHelper().checkCameraPermission()) {
      String localPath = await getPathDownload();
      String filePath =
          "$localPath/${fileName.trim()}_${DateTime.now().millisecondsSinceEpoch}$extension";
      print("filePath : $filePath");
      File fileDef = File(filePath);
      await fileDef.create(recursive: true);
      await fileDef.writeAsBytes(bytes);

      Timer(const Duration(milliseconds: 500), () {
        OpenFilex.open(filePath);
      });
    }
  }

  static Future saveFile(
      String fileName, List<int> bytes, String extension) async {
    if (await PermissionHelper().checkCameraPermission()) {
      String localPath = await getPathDownload();
      String filePath =
          "$localPath/${fileName.trim()}_${DateTime.now().millisecondsSinceEpoch}$extension";

      File fileDef = File(filePath);
      await fileDef.create(recursive: true);
      await fileDef.writeAsBytes(bytes);
      OpenFilex.open(filePath);
    }
  }

  static Future<List<String>> getPathExternalStorage() async {
    var path = await ExternalPath.getExternalStorageDirectories();
    //print(path); // [/storage/emulated/0, /storage/B3AE-4D28]
    return path;
    // please note: B3AE-4D28 is external storage (SD card) folder name it can be any.
  }

  // To get public storage directory path
  static Future<String> getPathDownload() async {
    var path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    //print(path); // /storage/emulated/0/Download
    return path;
  }

  static saveJsonInCSV(JsonResponseString) {
    var decode = base64.decode(JsonResponseString);
    var csvStr = utf8.decode(decode);
    //print(csvStr.toString());

    //print("creating file...");
    File file = File(
        '/storage/emulated/0/Download/${DateTime.now().microsecondsSinceEpoch}.csv');
    file.writeAsString(csvStr);
  }
}
