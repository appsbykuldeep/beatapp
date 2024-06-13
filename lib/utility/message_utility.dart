
import 'package:flutter/material.dart';

class MessageUtility {

  static void showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  static void showToastOnTop(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(msg),
      ),
    );
  }

  static void showDownloadCompleteMsg(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        content: Text("Report Downloaded into Download Folder"),
      ),
    );
  }

  static void showNoDataMsg(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text("No Data Available..."),
      ),
    );
  }

}