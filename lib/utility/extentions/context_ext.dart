import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension AppContextExt on BuildContext {
  ThemeData get themeData => Theme.of(this);
  // TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => themeData.colorScheme;

  Future<T?> push<T extends Object?>(Widget page) async {
    final pType = page.runtimeType;
    final cRout = Get.currentRoute;
    print("$cRout : Goining to $pType");

    final result = await Navigator.push<T>(
        this,
        MaterialPageRoute(
          builder: (context) => page,
        ));

    print("$cRout : Closing  $pType");
    return result;
  }

  Future<dynamic> pushReplacement(Widget page) async {
    final pType = page.runtimeType;
    final cRout = Get.currentRoute;
    print("$cRout : Goining to $pType");

    final result = await Navigator.pushReplacement(
        this,
        MaterialPageRoute(
          builder: (context) => page,
        ));

    print("$cRout : Closing  $pType");
    return result;
  }

  void pop() {
    Navigator.pop(this);
  }
}
