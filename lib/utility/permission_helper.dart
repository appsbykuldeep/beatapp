import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {

  ///permission_handler: ^10.2.0
  
  Future<bool> checkCameraPermission() async {
    var cameraPermissionStatus = await Permission.camera.request();
    //print(">>>>>>>>>>>>>>>>>>>>>>>>>>\ncamera permission >> " +
        //cameraPermissionStatus.name);
    if (cameraPermissionStatus.name == "granted") {
      return true;
    } else if (cameraPermissionStatus.name == "denied") {
      return false;
    } else {
      return false;
    }
  }

  Future<bool> checkStoragePermission() async {
    var permissionStatus = await Permission.storage.request();
    //print(">>>>>>>>>>>>>>>>>>>>>>>>>>\ncamera permission >> " +
        //permissionStatus.name);
    if (permissionStatus.name == "granted") {
      return true;
    } else if (permissionStatus.name == "denied") {
      return false;
    } else {
      return false;
    }
  }

  void permission() async {
    // You can request multiple permissions at once.

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.speech,
      Permission.storage,/*
      Permission.manageExternalStorage,*/
      //add more permission to request here.
    ].request();

    if (statuses[Permission.location]!.isDenied) {
      //check each permission status after.
      print("Location permission is denied.");
    }

    if (statuses[Permission.camera]!.isDenied) {
      //check each permission status after.
      print("Camera permission is denied.");
    }
  }
}