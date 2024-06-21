import 'package:get/get.dart';

int getLangCode() =>
    switch (Get.locale?.languageCode) { 'hi' => 6, 'en' => 99, _ => 99 };
