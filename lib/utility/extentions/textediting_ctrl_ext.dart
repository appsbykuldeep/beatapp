import 'package:flutter/material.dart';

extension AppTextEditingController on TextEditingController {
  String get trimText => text.trim();
  bool get isEmpty => trimText.isEmpty;
  bool get isNotEmpty => trimText.isNotEmpty;
}
