import 'package:beatapp/localization/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditText extends StatelessWidget {
  const EditText(
      {Key? key,
      this.controller,
      this.maxLength,
      this.textInputType,
      this.inputFormatters,
      this.prefixText = '',
      this.hintText = '',
      this.labelText = '',
      this.suffixIcon,
      this.validator})
      : super(key: key);

  final TextEditingController? controller;
  final int? maxLength;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final String hintText;
  final String labelText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLength: maxLength,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          prefixText: prefixText,
          hintText: AppTranslations.of(context)!.text(
            hintText,
          ),
          labelText: AppTranslations.of(context)!.text(
            labelText,
          ),
          suffixIcon: suffixIcon),
    );
  }
}

class EditTextBorder extends StatelessWidget {
  const EditTextBorder(
      {Key? key,
      this.controller,
      this.maxLength,
      this.textInputType,
      this.inputFormatters,
      this.prefixText = '',
      this.hintText = '',
      this.labelText = '',
      this.suffixIcon,
      this.validator,
      this.readOny = false,
      this.onTap})
      : super(key: key);

  final TextEditingController? controller;
  final int? maxLength;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final String hintText;
  final String labelText;
  final Widget? suffixIcon;
  final bool readOny;
  final FormFieldValidator<String>? validator;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      validator: validator,
      readOnly: readOny,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLength: maxLength,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          counterText: "",
          isDense: true,
          prefixText: prefixText,
          hintText: AppTranslations.of(context)!.text(
            hintText,
          ),
          labelText: AppTranslations.of(context)!.text(
            labelText,
          ),
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          suffix: suffixIcon),
    );
  }
}
