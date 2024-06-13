import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ArmsWeaponDeleteActivity extends StatefulWidget {
  final data;

  const ArmsWeaponDeleteActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<ArmsWeaponDeleteActivity> createState() =>
      _ArmsWeaponDeleteActivityState(data);
}

class _ArmsWeaponDeleteActivityState extends State<ArmsWeaponDeleteActivity> {
  var con_feedback = TextEditingController();
  String WEAPON_SR_NUM = "";

  _ArmsWeaponDeleteActivityState(data) {
    WEAPON_SR_NUM = data["WEAPON_SR_NUM"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  deleteData() async {
    if (con_feedback.text.trim().isEmpty) {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text("description_empty"));
      setState(() {});
      return;
    }
    var request = {
      "WEAPON_SR_NUM": WEAPON_SR_NUM,
      "DELETE_REMARKS": con_feedback.text
    };
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.DELETE_ARMS_WEAPON_BY_SHO, request, true);
    if (response.statusCode == 200) {
      MessageUtility.showToast(
          context, getTranlateString("record_successfully_deleted"));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title:
              Text(AppTranslations.of(context)!.text("delete_arms_weapon")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  getTranlateString("feedback"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width * .90,
                  height: 70,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: TextField(
                    controller: con_feedback,
                    style: const TextStyle(),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        counterText: ""),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: InkWell(
                  onTap: () => {deleteData()},
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    height: 40,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Color(ColorProvider.colorPrimary),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      AppTranslations.of(context)!.text("submit"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
