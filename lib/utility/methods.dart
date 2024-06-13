
import 'package:beatapp/utility/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toast({String msg=''}){
  Fluttertoast.showToast(msg: msg);
}

showLoader(){
  showDialog(context: NavigationService.navigatorKey.currentContext!, builder: (context){
    return const Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor:Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  });
}

hideLoader(){
  Navigator.pop(NavigationService.navigatorKey.currentContext!);
}
