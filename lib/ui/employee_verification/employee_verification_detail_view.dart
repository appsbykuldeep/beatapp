// ignore_for_file: unused_field, non_constant_identifier_names, no_logic_in_create_state

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/employee_beat_report_table.dart';
import 'package:beatapp/model/response/employee_detail_attachment.dart';
import 'package:beatapp/model/response/employee_detail_table.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/feedback/recommendation_by_sho_view.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class EmployeeVerificationDetailActivity extends StatefulWidget {
  final dynamic data;

  const EmployeeVerificationDetailActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<EmployeeVerificationDetailActivity> createState() =>
      _EmployeeVerificationDetailActivityState(data);
}

class _EmployeeVerificationDetailActivityState
    extends State<EmployeeVerificationDetailActivity> {
  var con_Details = TextEditingController();
  EmployeeDetail_Table? _details;
  List<EmployeeDetailAttachment> _attachments = [];
  List<EmployeeBeatReport_Table> lst_assignHistory = [];
  String role = "0";
  bool isImageLoaded = false;
  String EMPLOYEE_SR_NUM = "";
  String? action;

  _EmployeeVerificationDetailActivityState(data) {
    EMPLOYEE_SR_NUM = data["EMPLOYEE_SR_NUM"];
    action = data["action"];
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

  var con_Remark = TextEditingController();

  bool IS_CRIMINAL_RECORD = false;

  radioOnchangeAccepted(value) {
    IS_CRIMINAL_RECORD = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(getTranlateString("employee_verification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: _details != null
            ? SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      (action != null && action == "1")
                          ? Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 10),
                              child: InkWell(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecommendationBySHo(
                                          data: {
                                            "SR_NUM": EMPLOYEE_SR_NUM,
                                            "SERVICE_TYPE": "4"
                                          },
                                        ),
                                      ))
                                },
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
                                    AppTranslations.of(context)!
                                        .text("sho_action"),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      (role == "16" || role == "17")
                          ? Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  width:
                                      MediaQuery.of(context).size.width * .97,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      getTranlateString(
                                          "has_employee_criminal_record"),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .97,
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
                                                  value: IS_CRIMINAL_RECORD,
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
                                                  value: !IS_CRIMINAL_RECORD,
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
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width:
                                      MediaQuery.of(context).size.width * .98,
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    getTranlateString("remark_mandatory"),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: InkWell(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .97,
                                      padding: const EdgeInsets.only(
                                          right: 5, top: 8, left: 5, bottom: 8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: Colors.black, width: 1.0)),
                                      child: TextField(
                                        controller: con_Remark,
                                        style: const TextStyle(),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 15),
                                  child: InkWell(
                                    onTap: () => {
                                      //_saveRemark()
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .97,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 12),
                                      decoration: BoxDecoration(
                                        color:
                                            Color(ColorProvider.colorPrimary),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Text(
                                        getTranlateString("submit"),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .96,
                        child: lst_assignHistory.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: lst_assignHistory.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return getBeatView(index);
                                })
                            : const SizedBox(),
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
                    child: Text(beatData.eNQFILLEDDT ?? ""),
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
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageViewer(
                                          data: {"image": beatData.pHOTO},
                                        ),
                                      ));
                                },
                                child: Image.memory(
                                  Base64Helper.decodeBase64Image(
                                      beatData.pHOTO ?? ""),
                                  height: 80,
                                  width: 80,
                                ))
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
