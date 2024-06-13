import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/beat.dart';
import 'package:beatapp/model/enquiry_officer.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/model/response/information_detail_table.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/citizen_messages/sho/citizen_messages_Sho_feedback_view.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class CitizenMessagesAssignActivity extends StatefulWidget {
  final data;

  const CitizenMessagesAssignActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<CitizenMessagesAssignActivity> createState() =>
      _CitizenMessagesAssignActivityState(data);
}

class _CitizenMessagesAssignActivityState
    extends State<CitizenMessagesAssignActivity> {
  InformationDetail_Table infoDetails = InformationDetail_Table.emptyData();
  String _rank = "";
  String _rankEO = "";

  var con_Remark = TextEditingController();
  var PERSONID;

  _CitizenMessagesAssignActivityState(data) {
    PERSONID = data["PERSONID"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getShareInfoDetails();
      _getBeatList();
      _getEnquiryOfficerList();
    });
  }

  String dropdownValueBeat = "Select";
  List<String> spinnerItemsBeat = ["Select"];

  String dropdownValueBeatCons = "Select";
  List<String> spinnerItemsBeatCons = ["Select"];

  String dropdownValueEO = "Select";
  List<String> spinnerItemsEO = ["Select"];

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
  }

  String getSelectedBeatConsPNO() {
    return dropdownValueBeatCons.split("#")[2];
  }

  String getSelectedEOID() {
    return dropdownValueEO.split("#")[2];
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

  void _getBeatConstableList() async {
    var data = {"BEAT_CD": getSelectedBeatId()};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_CONSTABLE_BY_BEAT_CD, data, true);

    _rank = "";
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = ConstableResponse.fromJson(i);
          spinnerItemsBeatCons.add(
              "${data.BEAT_CONSTABLE_NAME!}#${data.OFFICER_RANK!}#${data.PNO!}#");
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

  void _getEnquiryOfficerList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_TENANT_ENQUIRY_OFFICER_LIST, data, true);

    _rank = "";
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = EnquiryOfficer.fromJson(i);
          spinnerItemsEO.add(
              "${data.nameRank!}#${data.eoOfficerRank!}#${data.psStaffCd!}");
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

  void _getShareInfoDetails() async {
    var data = {"PERSONID": PERSONID};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_CITIZEN_MESSAGE_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        infoDetails =
            InformationDetail_Table.fromJson(response.data["Table"][0]);
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  final formKey = GlobalKey<FormState>();

  void _saveData() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "ASSIGN_TO": getSelectedBeatConsPNO(),
      "BEAT_CD": getSelectedBeatId(),
      "DESCRIPTION": con_Remark.text,
      "DISTRICT_CD": userData.districtCD,
      "EO_PS_STAFF_CD": getSelectedEOID(),
      "PERSONID": PERSONID,
      "PS_CD": userData.psCd,
      "TARGET_DT": dateCtrl.text
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.ASSIGN_CS_TO_BEAT_CONSTABLE, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      MessageUtility.showToast(context, getTranlateString("success_msg"));
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(
          context, getTranlateString("beat_constable_already_assigned"));
    }
  }

  final dateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("citizens_messages")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranlateString("beat_name"),
                ),
                2.height,
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                            if (dropdownValueBeat == "Select") {
                              spinnerItemsBeatCons = ["Select"];
                              _rank = "";
                            } else {
                              _getBeatConstableList();
                            }
                            setState(() {});
                          },
                          items: spinnerItemsBeat
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.split("#")[0],
                                  style: const TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                        )
                      : const SizedBox(),
                ),
                15.height,
                Text(
                  getTranlateString("beat_person_name"),
                ),
                2.height,
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: spinnerItemsBeatCons.isNotEmpty
                      ? DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValueBeatCons,
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
                            dropdownValueBeatCons = data!;
                            if (data != getTranlateString("select")) {
                              _rank = data.split("#")[1];
                            } else {
                              _rank = "";
                            }
                            setState(() {});
                          },
                          items: spinnerItemsBeatCons
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.split("#")[0],
                                  style: const TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                        )
                      : const SizedBox(),
                ),
                15.height,
                Text(
                  getTranlateString("rank"),
                ),
                5.height,
                Container(
                  width: double.maxFinite,
                  height: 35,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _rank,
                      )),
                    ],
                  ),
                ),
                15.height,
                Text(
                  getTranlateString("enquiry_officer_name"),
                ),
                2.height,
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: spinnerItemsEO.isNotEmpty
                      ? DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValueEO,
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
                            dropdownValueEO = data!;
                            if (data != getTranlateString("select")) {
                              _rankEO = data.split("#")[1];
                            } else {
                              _rankEO = "";
                            }
                            setState(() {});
                          },
                          items: spinnerItemsEO
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.split("#")[0],
                                  style: const TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                        )
                      : const SizedBox(),
                ),
                15.height,
                Text(
                  getTranlateString("rank"),
                ),
                5.height,
                Container(
                  width: double.maxFinite,
                  height: 35,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _rankEO,
                      )),
                    ],
                  ),
                ),
                15.height,
                Text(
                  getTranlateString("disposal_last_date"),
                ),
                5.height,
                EditTextBorder(
                  controller: dateCtrl,
                  readOny: true,
                  validator: Validations.emptyValidator,
                  suffixIcon: InkWell(
                    onTap: () async {
                      dateCtrl.text =
                          await DialogHelper.openDatePickerDialog(context);
                    },
                    child: const Icon(Icons.date_range),
                  ),
                ),
                15.height,
                Text(
                  getTranlateString("remark"),
                ),
                5.height,
                Container(
                  width: double.maxFinite,
                  height: 35,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                      InkWell(onTap: () {}, child: const Icon(Icons.mic))
                    ],
                  ),
                ),
                8.height,
                Button(
                  title: "assign",
                  width: double.maxFinite,
                  onPressed:
                      (dropdownValueBeat == getTranlateString("select") ||
                              dropdownValueBeatCons ==
                                  getTranlateString("select") ||
                              dropdownValueEO == getTranlateString("select"))
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                DialogHelper.showLoaderDialog(context);
                                _saveData();
                              }
                            },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 2,
                  width: MediaQuery.of(context).size.width * .96,
                  color: Colors.grey,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("information_type"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      top: 8,
                      bottom: 8,
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
                          infoDetails.sHAREINFOTYPE ?? "",
                        )),
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
                      getTranlateString("date_time_information_sharing"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      top: 8,
                      bottom: 8,
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
                          infoDetails.rECORDDATETIME ?? "",
                        )),
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
                      getTranlateString("name_of_informer"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      top: 8,
                      bottom: 8,
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
                          infoDetails.nAME ?? "",
                        )),
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
                      getTranlateString("district"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
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
                          infoDetails.dISTRICT ?? "",
                        )),
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
                      getTranlateString("police_station"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
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
                          infoDetails.pS ?? "",
                        )),
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
                      getTranlateString("village_town_city"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
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
                          infoDetails.address ?? "",
                        )),
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
                      getTranlateString("mobile_num"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
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
                          infoDetails.mOBILENO ?? "",
                        )),
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
                      getTranlateString("suspect_name_object"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
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
                          infoDetails.sUSpectNAme ?? "",
                        )),
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
                      getTranlateString("place_of_occurrence"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
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
                          infoDetails.occPLace ?? "",
                        )),
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
                      getTranlateString("information_detail"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
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
                          infoDetails.dESCRIPTION ?? "",
                        )),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .96,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                                width: MediaQuery.of(context).size.width * .96,
                                height: 100,
                                margin: const EdgeInsets.only(right: 5),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  right: 5,
                                  left: 5,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: Colors.black, width: 1.0)),
                                child: infoDetails.iMAGE != null
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                  data: {
                                                    "image": infoDetails.iMAGE!
                                                  },
                                                ),
                                              ));
                                        },
                                        child: Image.memory(
                                          Base64Helper.decodeBase64Image(
                                              infoDetails.iMAGE!),
                                          height: 80,
                                          width: 80,
                                          alignment: Alignment.center,
                                          fit: BoxFit.fill,
                                        ))
                                    : Image.asset(
                                        'assets/images/ic_image_placeholder.png',
                                        height: 80,
                                        width: 80,
                                      )),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                width: MediaQuery.of(context).size.width * .96,
                                height: 100,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(left: 5),
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  right: 5,
                                  left: 5,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: Colors.black, width: 1.0)),
                                child: InkWell(
                                  onTap: () => {
                                    NavigatorUtils.launchMapsUrlFromLatLong(
                                        double.parse(infoDetails.lAT ?? "0"),
                                        double.parse(infoDetails.lONG ?? "0"))
                                  },
                                  splashColor: Colors.grey,
                                  child: Image.asset(
                                    'assets/images/ic_map.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CitizenMessagesShoFeedbackActivity(
                              data: {"SR_NUM": PERSONID},
                            ),
                          ))
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .96,
                      height: 40,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: Color(ColorProvider.colorPrimary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(
                        AppTranslations.of(context)!.text("progress_report"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
