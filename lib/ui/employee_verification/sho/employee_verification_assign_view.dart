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
import 'package:beatapp/model/response/employee_beat_report_table.dart';
import 'package:beatapp/model/response/employee_detail_attachment.dart';
import 'package:beatapp/model/response/employee_detail_table.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class EmployeeVerificationAssignActivity extends StatefulWidget {
  final data;

  const EmployeeVerificationAssignActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<EmployeeVerificationAssignActivity> createState() =>
      _EmployeeVerificationAssignActivityState(data);
}

class _EmployeeVerificationAssignActivityState
    extends BaseFullState<EmployeeVerificationAssignActivity> {
  EmployeeDetail_Table _details = EmployeeDetail_Table.emptyData();
  List<EmployeeDetailAttachment> _attachments = [];
  List<EmployeeBeatReport_Table> lst_assignHistory = [];
  String _rank = "";
  String _rankEO = "";
  final dateCtrl = TextEditingController();
  var con_Remark = TextEditingController();
  String EMPLOYEE_SR_NUM = "";

  _EmployeeVerificationAssignActivityState(data) {
    EMPLOYEE_SR_NUM = data["EMPLOYEE_SR_NUM"];
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
    var data = {"EMPLOYEE_SR_NUM": EMPLOYEE_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_EMPLOYEE_VERIFICATION_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _details = (response.data["Table"].toList().length != 0
            ? EmployeeDetail_Table.fromJson(response.data["Table"][0])
            : null)!;
        _attachments = [];
        for (Map<String, dynamic> i in response.data["Table1"]) {
          var data = EmployeeDetailAttachment.fromJson(i);
          _attachments.add(data);
        }
        for (Map<String, dynamic> i in response.data["Table2"]) {
          var data = EmployeeBeatReport_Table.fromJson(i);
          lst_assignHistory.add(data);
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
      "EMPLOYEE_SR_NUM": EMPLOYEE_SR_NUM,
      "PS_CD": userData.psCd,
      "TARGET_DT": dateCtrl.text
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.ASSIGN_EMPLOYEE_TO_BEAT_CONSTABLE, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data.toString() != "-1") {
      shouldRefresh = true;
      getDashBoardCount();
      MessageUtility.showToast(context, getTranlateString("success_msg"));
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(
          context, getTranlateString("record_already_assigned"));
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("employee_verification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    getTranlateString("beat_person_name"),
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
                        _rank,
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
                    getTranlateString("enquiry_officer_name"),
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
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width * .96,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    getTranlateString("disposal_last_date"),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: EditTextBorder(
                  controller: dateCtrl,
                  validator: Validations.emptyValidator,
                  readOny: true,
                  onTap: () async {
                    dateCtrl.text = await DialogHelper.openDatePickerDialog(
                        context,
                        isPast: false);
                  },
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
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width * .96,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    getTranlateString("basic_detail"),
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
                    getTranlateString("related_department_organization_name"),
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
                        _details.rEQUESTINGAGENCYNAME ?? "",
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
                    getTranlateString("date_of_application"),
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
                        _details.aPPLICATIONDT ?? "",
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
                        _details.rEQUESTINGAGENCYEMAIL ?? "",
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
                    getTranlateString("employee_details"),
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
                    getTranlateString("employee_name"),
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
                        _details.eMPLOYEENAME ?? "",
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
                    getTranlateString("relative_name"),
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
                    getTranlateString("employee_present_address"),
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
                        _details.eMPLOYEEPRESENTADDRESS ?? "",
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
                    getTranlateString("employee_previous_address"),
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
                        _details.eMPLOYEEPREVIOUSADDRESS ?? "",
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
                    getTranlateString("employee_permanent_address"),
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
                        _details.eMPLOYEEPERMANENTADDRESS ?? "",
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
                    getTranlateString("previous_employer_details"),
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
                    getTranlateString("employer_name"),
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
                        _details.pREVEMPLYRNAME ?? "",
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
                    getTranlateString("from_date"),
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
                        _details.pREVEMPLYRFRMDT ?? "",
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
                    getTranlateString("to_date"),
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
                        _details.pREVEMPLYRTODT ?? "",
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
                    getTranlateString("role_of_employee"),
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
                        _details.pREVEMPLYRROLE ?? "",
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
                        _details.pREVEMPLYRMOBILE ?? "",
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
                    getTranlateString("landline"),
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
                        _details.pREVEMPLYRLANDLINE ?? "",
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
                    getTranlateString("employer_address"),
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
                        _details.pREVIOUSEMPLOYERADDRESS ?? "",
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
                    getTranlateString("present_employer_detail"),
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
                    getTranlateString("employer_name"),
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
                        _details.cURREMPLYRNAME ?? "",
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
                    getTranlateString("role_of_employee"),
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
                        _details.cURREMPLYRROLE ?? "",
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
                        _details.cURREMPLYRMOBILE ?? "",
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
                    getTranlateString("landline"),
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
                        _details.cURREMPLYRLANDLINE ?? "",
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
                    getTranlateString("employer_address"),
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
                        _details.cURRENTEMPLOYERADDRESS ?? "",
                      )),
                    ],
                  ),
                ),
              ),
              _attachments.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _attachments.length,
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      itemBuilder: (BuildContext context, int index) {
                        return getRowForAttach(index);
                      })
                  : const SizedBox(),
            ],
          ),
        ));
  }

  Widget getRowForAttach(int index) {
    var data = _attachments[index];
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
            Container(
              margin: const EdgeInsets.only(top: 5, left: 5),
              child: Text(getTranlateString("open_doc")),
            )
          ],
        ),
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
