import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
    fontFamily: 'lato',
    appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
        ),
        color: Color(ColorProvider.colorPrimary),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        )));
