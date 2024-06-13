import 'package:flutter/material.dart';

extension StringExt on String{
  Widget text({double? fontSize,Color color= Colors.black,FontWeight? fontWeight})=>Text(this,style: TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight
  ),);
}