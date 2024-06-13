import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/beat.dart';
import 'package:beatapp/model/enquiry_officer.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/tenant_verification_attachment.dart';
import 'package:beatapp/model/response/tenant_verification_detail.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class TenantVerificationAssignActivity extends StatefulWidget {
  final data;

  const TenantVerificationAssignActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<TenantVerificationAssignActivity> createState() =>
      _TenantVerificationAssignActivityState(data);
}

class _TenantVerificationAssignActivityState
    extends BaseFullState<TenantVerificationAssignActivity> {
  List<TenantVerificationAttachment> lstFile = [];
  TenantVerificationDetail _details = TenantVerificationDetail.emptyData();
  String _rank = "";
  String _rankEO = "";

  var con_Remark = TextEditingController();
  String TENANT_SR_NUM = "";

  _TenantVerificationAssignActivityState(data) {
    TENANT_SR_NUM = data["TENANT_SR_NUM"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getTenantDetails();
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

  void _getTenantDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"TENANT_SR_NUM": TENANT_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_TENANT_VERIFICATION_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _details = (response.data["Table"].toList().length != 0
            ? TenantVerificationDetail.fromJson(response.data["Table"][0])
            : null)!;
        lstFile = [];
        for (Map<String, dynamic> i in response.data["Table1"]) {
          var data = TenantVerificationAttachment.fromJson(i);
          lstFile.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  void _saveData() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "ASSIGN_TO": getSelectedBeatConsPNO(),
      "BEAT_CD": getSelectedBeatId(),
      "DESCRIPTION": con_Remark.text,
      "DISTRICT_CD": userData.districtCD,
      "EO_PS_STAFF_CD": getSelectedEOID(),
      "TENANT_SR_NUM": TENANT_SR_NUM,
      "PS_CD": userData.psCd,
      "TARGET_DT": dateCtrl.text
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.ASSIGN_TENANT_TO_BEAT_CONSTABLE, data, false);
    if (response.statusCode == 200 && response.data.toString() != "-1") {
      shouldRefresh = true;
      getDashBoardCount();
      Navigator.pop(context);
      MessageUtility.showToast(context, getTranlateString("success_msg"));
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(
          context, getTranlateString("record_already_assigned"));
    }
  }

  final formKey = GlobalKey<FormState>();
  final dateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("tenant_verification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranlateString("beat_name"),
              ),
              2.height,
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: dropdownValueBeat,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.only(left: 8, right: 8),
                    border: OutlineInputBorder()),
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
              ),
              8.height,
              Text(
                getTranlateString("beat_person_name"),
              ),
              2.height,
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: dropdownValueBeatCons,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.only(left: 8, right: 8),
                    border: OutlineInputBorder()),
                onChanged: (String? data) {
                  dropdownValueBeatCons = data!;
                  if (data != "Select") {
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
              ),
              8.height,
              Text(
                getTranlateString("rank"),
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
              ),
              8.height,
              Text(
                getTranlateString("enquiry_officer_name"),
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
                              if (data != "Select") {
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
                    getTranlateString("rank"),
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
              ),
              8.height,
              Text(
                getTranlateString("disposal_last_date"),
              ),
              Form(
                key: formKey,
                child: EditTextBorder(
                  controller: dateCtrl,
                  validator: Validations.emptyValidator,
                  onTap: () async {
                    dateCtrl.text = await DialogHelper.openDatePickerDialog(
                        context,
                        isPast: false);
                  },
                  readOny: true,
                  suffixIcon: const Icon(Icons.date_range),
                ),
              ),
              8.height,
              Text(
                getTranlateString("remark"),
              ),
              4.height,
              EditTextBorder(
                controller: con_Remark,
                suffixIcon: const Icon(Icons.mic),
              ),
              8.height,
              Button(
                title: "assign",
                width: double.maxFinite,
                onPressed: (dropdownValueBeat == getTranlateString("select") ||
                        dropdownValueBeatCons == getTranlateString("select") ||
                        dropdownValueEO == getTranlateString("select"))
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          DialogHelper.showLoaderDialog(context);
                          _saveData();
                        }
                      },
              ),
              CustomView.getHorizontalDevider(context),
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
                    getTranlateString("landlord_details"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.oWNERNAME ?? "",
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
                    getTranlateString("email_id"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.oWNEREMAIL ?? "",
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
                    getTranlateString("mobile_number"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.oWNERMOBILE ?? "",
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
                    getTranlateString("occupation"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.oCCUPATION ?? "",
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
                    getTranlateString("address"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.oWNERADDRESS ?? "",
                      )),
                    ],
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
                    getTranlateString("name_of_tenant"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.tENANTNAME ?? "",
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
                    getTranlateString("gender"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.gender ?? "",
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
                    getTranlateString("age"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.aGE ?? "",
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
                    getTranlateString("mobile_number"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.tENANTMOBILE ?? "",
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
                    getTranlateString("email_id"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.tENANTEMAIL ?? "",
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
                    getTranlateString("relative_name"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.rELATIVENAME ?? "",
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
                    getTranlateString("relation"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.rELATIONTYPE ?? "",
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
                    getTranlateString("reason_tenantship"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.tENANCYPURPOSE ?? "",
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
                    getTranlateString("occupation"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.oCCUPATION1 ?? "",
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
                    getTranlateString("present_address"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.tENANTPRESENTADDRESS ?? "",
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
                    getTranlateString("last_address"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.tENANTPREVIOUSADDRESS ?? "",
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
                    getTranlateString("permanent_address"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _details.tENANTPERMANENTADDRESS ?? "",
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
                    getTranlateString("document"),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              lstFile.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: lstFile.length,
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      itemBuilder: (BuildContext context, int index) {
                        return getRowForConst(index);
                      })
                  : const SizedBox(),
            ],
          ),
        ));
  }

  Widget getRowForConst(int index) {
    var data = lstFile[index];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewer(
                data: {"image": data.uploadedFile},
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5, right: 1),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * .98,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Color(0x10000000),
                offset: Offset(
                  2.0,
                  2.0,
                ),
                blurRadius: 2.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              //BoxShadow
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(getTranlateString("file_name"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.fileName ?? ""),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(getTranlateString("type"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.fileType ?? ""),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      getTranlateString("details"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.fileDesc ?? ""),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
