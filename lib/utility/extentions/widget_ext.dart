import 'package:flutter/cupertino.dart';

extension WidgetExt on Widget{
  Widget expand({int flex=1}) => Expanded(flex: flex,child: this,);
}