import 'package:flutter/foundation.dart';

class ButtonClickState extends ChangeNotifier{
  bool isClicked= false;

  changeState(bool state){
    isClicked=state;
  }
}