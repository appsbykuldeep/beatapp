// ignore_for_file: unused_field, non_constant_identifier_names, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/employee_beat_report_table.dart';
import 'package:beatapp/model/response/employee_detail_attachment.dart';
import 'package:beatapp/model/response/employee_detail_table.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/loaction_utils.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ConsEmployeeInfoSubmitActivity extends StatefulWidget {
  final data;

  const ConsEmployeeInfoSubmitActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<ConsEmployeeInfoSubmitActivity> createState() =>
      _ConsEmployeeInfoSubmitActivityState(data);
}

class _ConsEmployeeInfoSubmitActivityState
    extends BaseFullState<ConsEmployeeInfoSubmitActivity> {
  var con_Details = TextEditingController();
  EmployeeDetail_Table? _details;
  List<EmployeeDetailAttachment> _attachments = [];
  List<EmployeeBeatReport_Table> lst_assignHistory = [];
  String role = "0";
  String EMPLOYEE_SR_NUM = "";
  bool IS_RESOLVED = false;
  bool IS_CRIMINAL_RECORD = false;
  bool IS_ACCEPTED = false;
  String PHOTO = "";

  _ConsEmployeeInfoSubmitActivityState(data) {
    EMPLOYEE_SR_NUM = data["EMPLOYEE_SR_NUM"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getTenantDetails();
    super.initState();
  }

  void _getTenantDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"EMPLOYEE_SR_NUM": EMPLOYEE_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_EMPLOYEE_VERIFICATION_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _details = response.data["Table"].toList().length != 0
            ? EmployeeDetail_Table.fromJson(response.data["Table"][0])
            : null;
        _attachments = [];
        for (Map<String, dynamic> i in response.data["Table1"]) {
          var data = EmployeeBeatReport_Table.fromJson(i);
          lst_assignHistory.add(data);
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

  void saveData() async {
    var position = await LocationUtils().determinePosition();
    if (con_Details.text.isEmpty) {
      MessageUtility.showToast(context, getTranlateString("remark_empty"));
      return;
    } else if (position == null) {
      MessageUtility.showToast(context, getTranlateString("location_error"));
      return;
    }
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "EMPLOYEE_SR_NUM": EMPLOYEE_SR_NUM,
      "IS_RESOLVED": IS_RESOLVED ? "Y" : "N",
      "LAT": position.latitude.toString(),
      "LONG": position.longitude.toString(),
      "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD ? "Y" : "N",
      "IS_ACCEPTED": IS_ACCEPTED ? "Y" : "N",
      "PHOTO": PHOTO,
      "REMARKS": con_Details.text.toString(),
      "PS_CD": userData.psCd,
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_EMPLOYEE_VERIFICATION, data, true);
    if (response.statusCode == 200 && response.data == 1) {
      getDashBoardCount();
      MessageUtility.showToast(context, getTranlateString("success_msg"));
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(context, getTranlateString("error_msg"));
    }
  }

  radioOnchangeResolve(value) {
    IS_RESOLVED = value;
    setState(() {});
  }

  radioOnchangeCriminalRecord(value) {
    IS_CRIMINAL_RECORD = value;
    setState(() {});
  }

  radioOnchangeAccepted(value) {
    IS_ACCEPTED = value;
    setState(() {});
  }

  radioOnchange(value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("employee_verification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: _details != null
            ? SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width * .96,
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  getTranlateString("completed"),
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
                                              value: IS_RESOLVED,
                                              onChanged: (v) =>
                                                  radioOnchangeResolve(true),
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
                                              value: !IS_RESOLVED,
                                              onChanged: (v) =>
                                                  radioOnchangeResolve(false),
                                              activeColor: Colors.red),
                                          Text(getTranlateString("no"))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (IS_RESOLVED)
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    width:
                                        MediaQuery.of(context).size.width * .96,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        getTranlateString(
                                            "criminal_record_label"),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .96,
                                      height: 60,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        right: 5,
                                        left: 5,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: IS_CRIMINAL_RECORD,
                                                    onChanged: (v) =>
                                                        radioOnchangeCriminalRecord(
                                                            true),
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
                                                    value: !IS_CRIMINAL_RECORD,
                                                    onChanged: (v) =>
                                                        radioOnchangeCriminalRecord(
                                                            false),
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
                                    width:
                                        MediaQuery.of(context).size.width * .96,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        getTranlateString("action"),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .96,
                                      height: 60,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        right: 5,
                                        left: 5,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: IS_ACCEPTED,
                                                    onChanged: (v) =>
                                                        radioOnchangeAccepted(
                                                            true),
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
                                                    value: !IS_ACCEPTED,
                                                    onChanged: (v) =>
                                                        radioOnchangeAccepted(
                                                            false),
                                                    activeColor: Colors.red),
                                                Text(getTranlateString("no"))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width * .96,
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  getTranlateString("details"),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: Colors.black, width: 1.0)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: con_Details,
                                        style: const TextStyle(),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            counterText: "",
                                            contentPadding:
                                                EdgeInsets.only(bottom: 15)),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {},
                                        child: const Icon(Icons.mic))
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
                                  getTranlateString("upload_photo"),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .96,
                                height: 100,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  right: 5,
                                  left: 5,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: Colors.black, width: 1.0)),
                                child: Row(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          File? image =
                                              await CameraAndFileProvider()
                                                  .pickImageFromCamera();
                                          if (image != null) {
                                            PHOTO =
                                                Base64Helper.encodeImage(image);
                                            setState(() {});
                                          }
                                        },
                                        child: const Icon(Icons.camera_alt)),
                                    if (PHOTO != "")
                                      Row(
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 26),
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageViewer(
                                                          data: {
                                                            "image": PHOTO
                                                          },
                                                        ),
                                                      ));
                                                },
                                                child: Image.memory(
                                                  Base64Helper
                                                      .decodeBase64Image(PHOTO),
                                                  height: 80,
                                                  width: 80,
                                                )),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 26),
                                            child: InkWell(
                                              onTap: () {
                                                PHOTO = "";
                                                setState(() {});
                                              },
                                              child: const Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: InkWell(
                                onTap: () => {saveData()},
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * .96,
                                  height: 40,
                                  margin: const EdgeInsets.only(top: 10),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    color: Color(ColorProvider.colorPrimary),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Text(
                                    getTranlateString("submit"),
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
                            getTranlateString(
                                "related_department_organization_name"),
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
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.rEQUESTINGAGENCYNAME ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.aPPLICATIONDT ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.rEQUESTINGAGENCYEMAIL ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.eMPLOYEENAME ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.aGE ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.rELATIVENAME ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.rELATIONTYPE ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.eMPLOYEEPRESENTADDRESS ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.eMPLOYEEPREVIOUSADDRESS ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.eMPLOYEEPERMANENTADDRESS ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.pREVEMPLYRNAME ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.pREVEMPLYRFRMDT ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.pREVEMPLYRTODT ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.pREVEMPLYRROLE ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.pREVEMPLYRMOBILE ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.pREVEMPLYRLANDLINE ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.pREVIOUSEMPLOYERADDRESS ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.cURREMPLYRNAME ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.cURREMPLYRROLE ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.cURREMPLYRMOBILE ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.cURREMPLYRLANDLINE ?? "",
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.cURRENTEMPLOYERADDRESS ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox());
  }

  getBeatView(int index) {
    var beatData = lst_assignHistory[index];
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * .96,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(
          right: 5,
          left: 5,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.black, width: 1.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                        AppTranslations.of(context)!.text("beat_person_name"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.bEATCONSTABLENAME ?? ""),
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
                        AppTranslations.of(context)!.text("target_date"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.tARGETDT ?? ""),
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
                        AppTranslations.of(context)!
                            .text("constable_remark_date"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.rEMARKS ?? ""),
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
                      AppTranslations.of(context)!.text("completed"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.iSRESOLVED == "N" ? "No" : "Yes"),
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
                      AppTranslations.of(context)!
                          .text("criminal_record_label"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.iSCRIMINALRECORD == "N"
                        ? getTranlateString("No")
                        : getTranlateString("Yes")),
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
                      AppTranslations.of(context)!.text("action"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.iSACCEPTED ?? ""),
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
                      AppTranslations.of(context)!.text("constable_remarks"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.rEMARKS ?? ""),
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
                      AppTranslations.of(context)!.text("eo_name"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.eONAME ?? ""),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppTranslations.of(context)!.text("photo"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => {
                          /*NavigatorUtils
                                                      .launchMapsUrlFromLatLong(
                                                      double.parse(
                                                          _assignHistory!
                                                              .lat ??
                                                              "0"),
                                                      double.parse(
                                                          _assignHistory!
                                                              .lng ??
                                                              "0"))*/
                        },
                        splashColor: Colors.grey,
                        child: beatData.pHOTO != null
                            ? Image.memory(
                                Base64Helper.decodeBase64Image(
                                    beatData.pHOTO ?? ""),
                                height: 80,
                                width: 80,
                              )
                            : Image.asset(
                                'assets/images/ic_image_placeholder.png',
                                height: 80,
                                width: 80,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppTranslations.of(context)!.text("location"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => {
                          NavigatorUtils.launchMapsUrlFromLatLong(
                              double.parse(beatData.lAT ?? "0"),
                              double.parse(beatData.lONG ?? "0"))
                        },
                        splashColor: Colors.grey,
                        child: Image.asset(
                          'assets/images/ic_map.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
