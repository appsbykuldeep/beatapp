import 'package:flutter/material.dart';
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
}
