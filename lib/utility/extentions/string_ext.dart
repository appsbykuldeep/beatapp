import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/constants/app_constants.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

extension StringExt on String {
  Widget text(
          {double? fontSize,
          Color color = Colors.black,
          FontWeight? fontWeight}) =>
      Text(
        this,
        style:
            TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
      );

  Future<bool> launchURL() async {
    print("launchURL : $this");
    try {
      final uri = Uri.parse(this);

      if (await launcher.canLaunchUrl(uri)) {
        return await launcher.launchUrl(
          uri,
          mode: launcher.LaunchMode.externalApplication,
        );
      } else {
        print("can't open");
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  String attachHost() {
    if (startsWith(regExpHTTP)) {
      return this;
    }
    return "${EndPoints.BASE_URL}$this";
  }

  bool isLoginEndPoint() {
    return [
      EndPoints.END_POINT_LOGIN,
      EndPoints.END_POINT_VALIDATE_MOBILE,
      EndPoints.END_POINT_LOGOUT,
      EndPoints.END_POINT_GET_USER_OFFICE,
    ].contains(this);
  }

  String get translation =>
      AppTranslations.of(Get.context!)!.text(toLowerCase());

  void showTost() async {
    final msj = trim();
    if (msj.isEmpty) return;
    await Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msj,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
