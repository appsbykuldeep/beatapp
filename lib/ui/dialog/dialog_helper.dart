import 'package:beatapp/localization/app_translations.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,

      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: AlertDialog(
            content:  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.red,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Text(AppTranslations.of(context)!.text("please_wait"))),
              ],
            ),
          ),
        );
      },
    );
  }

  static showMessageDialog(BuildContext context, String msg) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(AppTranslations.of(context)!.text("ok")),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppTranslations.of(context)!.text("info")),
      content: Text(msg),
      actions: [
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showCallDialog(
      BuildContext context, String title, String msg, dynamic actionYes) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text(AppTranslations.of(context)!.text("yes")),
      onPressed: (){
        Navigator.pop(context);
        actionYes();
      },
    );

    Widget cancelButton = TextButton(
      child: Text(AppTranslations.of(context)!.text("No")),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [cancelButton, okButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<String> openDatePickerDialog(
      BuildContext context,{bool isFuture=true,bool isPast=true}) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: isPast?DateTime(2015, 8):DateTime.now(),
        lastDate: isFuture?DateTime(2101):DateTime.now());
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      return "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
    }
    return "";
  }

  static closeAppDialog(context) async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('Do you want to exit an App'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
    )) ?? false;
  }
}
