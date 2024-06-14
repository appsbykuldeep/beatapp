import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/beat.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/village_beat_details_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class HistorySheeterAddActivity extends StatefulWidget {
  const HistorySheeterAddActivity({Key? key}) : super(key: key);

  @override
  State<HistorySheeterAddActivity> createState() =>
      _HistorySheeterAddActivityState();
}

class _HistorySheeterAddActivityState extends State<HistorySheeterAddActivity> {
  String dropdownValueBeat = "Select";
  List<String> spinnerItemsBeat = ["Select"];

  String dropdownValueVillStr = "Select";
  List<String> spinnerItemsdropdownValueVillStr = ["Select"];
  String Is_Active = "N";

  final con_fName = TextEditingController();
  final con_Mobile = TextEditingController();
  final con_Age = TextEditingController();
  final con_Add = TextEditingController();
  final con_Hs_Name = TextEditingController();
  final con_HsNo = TextEditingController();
  final con_Remark = TextEditingController();

  String selectedOpeningDate = "", selectedNBDate = "";

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
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
          spinnerItemsBeat
              .add("${data.beatName!.trim()}#${data.beatCD!.trim()}");
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

  String getSelectedVillId() {
    return dropdownValueVillStr.split("#")[1];
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
          spinnerItemsdropdownValueVillStr.add(
              "${data.REGIONAL_NAME!.trim()}#${data.VILL_STR_SR_NUM!.trim()}");
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

  final formKey = GlobalKey<FormState>();
  void _saveData() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "ADDRESS": con_Add.text,
      "AGE": con_Age.text,
      "BEAT_CD": getSelectedBeatId(),
      "DATE_OF_OPENING": selectedOpeningDate,
      "DISTRICT_CD": userData.districtCD,
      "FATHER_NAME": con_fName.text,
      "FILLED_BY_NAME": userData.personName, //"MAHULI  ",
      "HISTORY_SHEET_NO": con_HsNo.text,
      "IS_ACTIVE": Is_Active, //"Y",
      "MOBILE": con_Mobile.text,
      "NAME": con_Hs_Name.text,
      "NIGRANI_BAND_DATE": selectedNBDate,
      "PS_CD": userData.psCd,
      "REMARKS": con_Remark.text,
      "VILL_STR_SR_NUM": getSelectedVillId()
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_HST_ADD_DATA, data, false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title:
              Text(AppTranslations.of(context)!.text("add_history_sheeters")),
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
                      getTranlateString("history_sheeter_name"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                4.height,
                EditTextBorder(
                  controller: con_Hs_Name,
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
                      getTranlateString("is_active"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 60,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Checkbox(
                                  value: Is_Active == "Y" ? true : false,
                                  onChanged: (value) {
                                    Is_Active = "Y";
                                    setState(() {});
                                  },
                                  activeColor: Colors.red),
                              Text(getTranlateString("yes"))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Checkbox(
                                  value: Is_Active == "Y" ? false : true,
                                  onChanged: (value) {
                                    Is_Active = "N";
                                    setState(() {});
                                  },
                                  activeColor: Colors.red),
                              Text(getTranlateString("no"))
                            ],
                          ),
                        )
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
                            maxLength: 2,
                            keyboardType: TextInputType.number,
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
                      getTranlateString("hs_approval"),
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
                      getTranlateString("history_sheeter_num"),
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
                            controller: con_HsNo,
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
                      getTranlateString("dt_of_opening"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    selectedOpeningDate =
                        await DialogHelper.openDatePickerDialog(context,
                            isFuture: false, isPast: true);
                    setState(() {});
                  },
                  child: Container(
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
                            selectedOpeningDate,
                          )),
                          const Icon(Icons.date_range)
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("nigrani_band_dt"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    selectedNBDate = await DialogHelper.openDatePickerDialog(
                        context,
                        isFuture: true,
                        isPast: false);
                    setState(() {});
                  },
                  child: Container(
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
                            selectedNBDate,
                          )),
                          const Icon(Icons.date_range)
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("other_information"),
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
                      getTranlateString("remark"),
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
                            controller: con_Remark,
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
                8.height,
                Button(
                  title: "submit",
                  width: double.maxFinite,
                  onPressed: (dropdownValueBeat ==
                              getTranlateString("select") ||
                          dropdownValueVillStr == getTranlateString("select"))
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
