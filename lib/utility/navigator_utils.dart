import 'dart:io';

import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/ui/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      try {
        if (await canLaunch(googleMapUrl)) {
          await launch(googleMapUrl);
        }
      } catch (error) {
        throw ("Cannot launch Google map");
      }
    }
    if (Platform.isIOS) {
      try {
        if (await canLaunch(appleMapUrl)) {
          await launch(appleMapUrl);
        }
      } catch (error) {
        throw ("Cannot launch Apple map");
      }
    }
  }

  static void launchMapsUrlFromLatLong(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}