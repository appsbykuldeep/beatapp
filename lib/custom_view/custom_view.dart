import 'package:beatapp/localization/app_translations.dart';
import 'package:flutter/material.dart';

class CustomView {
  static dynamic getNoRecordView(BuildContext context) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      child: Text(AppTranslations.of(context)!.text("no_record_found")),
    ));
  }

  static dynamic getNoRecordViewWrap(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(AppTranslations.of(context)!.text("no_record_found")),
    );
  }

  static dynamic getHorizontalDevider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 2,
      width: MediaQuery.of(context).size.width * .96,
      color: Colors.grey,
    );
  }

  static dynamic getHorizontalDeviderActive(
      BuildContext context, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 2,
      width: MediaQuery.of(context).size.width * .96,
      color: isActive ? Colors.green : Colors.red,
    );
  }

  static dynamic getCountView(context, int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              offset: Offset(
                2.0,
                2.0,
              ),
              blurRadius: 3.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            //BoxShadow
          ]),
      child: Text("${AppTranslations.of(context)!.text("total")} : $count"),
    );
  }

  static dynamic getTextView(context, String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              offset: Offset(
                2.0,
                2.0,
              ),
              blurRadius: 3.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            //BoxShadow
          ]),
      child: Text(text),
    );
  }

  static dynamic getCountViewWithOutShadow(context, int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
      margin: const EdgeInsets.only(left: 12, top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.black, width: .5)),
      child: Text("${AppTranslations.of(context)!.text("total")} : $count"),
    );
  }

  static dynamic getPendingView(context, int count) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              offset: Offset(
                1.0,
                1.0,
              ),
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            //BoxShadow
          ]),
      child: Text(
        "${AppTranslations.of(context)!.text("Pending")} : $count",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  static dynamic getCompletedView(context, int count) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              offset: Offset(
                1.0,
                1.0,
              ),
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            //BoxShadow
          ]),
      child: Text(
        "${AppTranslations.of(context)!.text("Completed")} : $count",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  static dynamic getTotalView(context, int count) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              offset: Offset(
                1.0,
                1.0,
              ),
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            //BoxShadow
          ]),
      child: Text(
          "${AppTranslations.of(context)!.text("total")} : $count",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11)),
    );
  }

  static dynamic getOptionTotalView(context, int count) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              offset: Offset(
                1.0,
                1.0,
              ),
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            //BoxShadow
          ]),
      child: Text(
          "${AppTranslations.of(context)!.text("total")} : $count",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11)),
    );
  }
}