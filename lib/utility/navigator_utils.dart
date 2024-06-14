import 'dart:io';

import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/ui/login/login_view.dart';
import 'package:beatapp/utility/extentions/string_ext.dart';
import 'package:flutter/material.dart';

class NavigatorUtils {
  static expireAuthentication(context) {
    PreferenceHelper().clearAll();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
        (route) => false);
  }

  static openView(context, page) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ));
  }

  static closeView(context) {
    Navigator.pop(context);
  }

  static closeDialog(context) {
    Navigator.pop(context);
  }

  static Future<void> launchMapUrlFromAddress(String address) async {
    String encodedAddress = Uri.encodeComponent(address);
    String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
    String appleMapUrl = "http://maps.apple.com/?q=$encodedAddress";
    if (Platform.isAndroid) {
      googleMapUrl.launchURL();
    }
    if (Platform.isIOS) {
      appleMapUrl.launchURL();
    }
  }

  static void launchMapsUrlFromLatLong(double lat, double lon) async {
    'https://www.google.com/maps/search/?api=1&query=$lat,$lon'.launchURL();
  }
}
