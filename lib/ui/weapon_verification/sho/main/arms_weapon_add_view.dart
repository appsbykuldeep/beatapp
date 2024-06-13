import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/beat.dart';

import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/village_beat_details_response.dart';
import 'package:beatapp/model/response/weapon_type_model.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class ArmsWeaponAddActivity extends StatefulWidget {
  const ArmsWeaponAddActivity({Key? key}) : super(key: key);

  @override
  State<ArmsWeaponAddActivity> createState() => _ArmsWeaponAddActivityState();
}

class _ArmsWeaponAddActivityState extends State<ArmsWeaponAddActivity> {
  String dropdownValueBeat = "Select";
  List<String> spinnerItemsBeat = ["Select"];

  String dropdownValueVillStr = "Select";
  List<String> spinnerItemsdropdownValueVillStr = ["Select"];

  String dropdownValueWeaponType = "Select";
  List<String> spinnerItemsdropdownValueWeaponType = ["Select"];

  final con_LicHol_Name = TextEditingController();
  final con_fName = TextEditingController();
  final con_Mobile = TextEditingController();
  final con_Age = TextEditingController();
  final con_Add = TextEditingController();
  final con_WeaponModel = TextEditingController();
  final con_Weapon_Lic_No = TextEditingController();

  String selectedDate = "";

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
  }

  String getSelectedVillId() {
    return dropdownValueVillStr.split("#")[1];
  }

  String getSelectedWeaponId() {
    return dropdownValueWeaponType.split("#")[1];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getBeatList();
      _getVillageList();
      _getWeaponTypeList();
    });
  }

  void _getBeatList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_MASTER, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = Beat.fromJson(i);
          spinnerItemsBeat.add("${data.beatName!}#${data.beatCD!}");
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  void _getVillageList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_Village_DETAILS, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = VillageBeatDetailsResponse.fromJson(i);
          spinnerItemsdropdownValueVillStr
              .add("${data.REGIONAL_NAME!}#${data.VILL_STR_SR_NUM!}");
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  void _getWeaponTypeList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_WEAPON_TYPE, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = WeaponTypeModel.fromJson(i);
          spinnerItemsdropdownValueWeaponType
              .add("${data.WEAPON_SUBTYPE!}#${data.WEAPON_SUBTYPE_CD!}");
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  void _saveData() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "ADDRESS": con_Add.text,
      "AGE": con_Age.text,
      "ARMS_LISCENSE_NO": con_Weapon_Lic_No.text,
      "ARMS_MODEL": con_WeaponModel.text,
      "BEAT_CD": getSelectedBeatId(),
      "DISTRICT_CD": userData.districtCD,
      "FATHER_NAME": con_fName.text,
      "FIRE_ARMS_CD": getSelectedWeaponId(),
      "LISCENSE_HOLDER_NAME": con_LicHol_Name.text,
      "MOBILE": con_Mobile.text,
      "PS_CD": userData.psCd,
      "VILL_STR_SR_NUM": getSelectedVillId(),
      "FIRE_ARMS_VALIDITY_DATE": selectedDate
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_ARMS_WEAPON_ADD, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data.toString() == "1") {
      MessageUtility.showToast(
          context, getTranlateString("record_successfully_submitted"));
      Navigator.pop(context);
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text("error_msg"));
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(AppTranslations.of(context)!.text("add_arms_weapon")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("information_detail"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                CustomView.getHorizontalDevider(context),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("beat_name"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 40,
                  child: InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .96,
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: spinnerItemsBeat.isNotEmpty
                          ? DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueBeat,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? data) {
                                dropdownValueBeat = data!;
                                setState(() {});
                              },
                              items: spinnerItemsBeat
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.split("#")[0],
                                      style:
                                          const TextStyle(color: Colors.black)),
                                );
                              }).toList(),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("village_street"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 40,
                  child: InkWell(
                      child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: spinnerItemsdropdownValueVillStr.isNotEmpty
                        ? DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValueVillStr,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? data) {
                              dropdownValueVillStr = data!;
                              setState(() {});
                            },
                            items: spinnerItemsdropdownValueVillStr
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.split("#")[0],
                                    style:
                                        const TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                          )
                        : const SizedBox(),
                  )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("license_holder_name"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                4.height,
                EditTextBorder(
                  controller: con_LicHol_Name,
                  validator: Validations.emptyValidator,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("father_name"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                4.height,
                EditTextBorder(
                  controller: con_fName,
                  validator: Validations.emptyValidator,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("mobile_number"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: con_Mobile,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                                contentPadding: EdgeInsets.only(bottom: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("age"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: con_Age,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                                contentPadding: EdgeInsets.only(bottom: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("address"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: con_Add,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                                contentPadding: EdgeInsets.only(bottom: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("weapon_details"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                CustomView.getHorizontalDevider(context),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("weapon_type"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 40,
                  child: InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .96,
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: spinnerItemsdropdownValueWeaponType.isNotEmpty
                          ? DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueWeaponType,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? data) {
                                dropdownValueWeaponType = data!;
                                setState(() {});
                              },
                              items: spinnerItemsdropdownValueWeaponType
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.split("#")[0],
                                      style:
                                          const TextStyle(color: Colors.black)),
                                );
                              }).toList(),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("weapon_model"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: con_WeaponModel,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                                contentPadding: EdgeInsets.only(bottom: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("weapon_license_number"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: con_Weapon_Lic_No,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                                contentPadding: EdgeInsets.only(bottom: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("weapon_validity"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          selectedDate,
                        )),
                        InkWell(
                            onTap: () async {
                              selectedDate =
                                  await DialogHelper.openDatePickerDialog(
                                      context);
                              setState(() {});
                            },
                            child: const Icon(Icons.date_range))
                      ],
                    ),
                  ),
                ),
                8.height,
                Button(
                  title: "submit",
                  width: double.maxFinite,
                  onPressed: (dropdownValueBeat ==
                              getTranlateString("select") ||
                          dropdownValueVillStr == getTranlateString("select") ||
                          dropdownValueWeaponType ==
                              getTranlateString("select"))
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            DialogHelper.showLoaderDialog(context);
                            _saveData();
                          }
                        },
                ),
              ],
            ),
          ),
        ));
  }
}
