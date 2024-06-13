import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    this.onPressed,
    this.title = '',
    this.width,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String title;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(ColorProvider.colorPrimary)),
          child: Text(
            AppTranslations.of(context)!.text(title),
            style: const TextStyle(
              color: Colors.white,
            ),
          )),
    );
  }
}
