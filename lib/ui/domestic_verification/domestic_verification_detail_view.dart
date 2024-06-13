import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/domestic_detail_attachment.dart';
import 'package:beatapp/model/response/domestic_verification_detail.dart';
import 'package:beatapp/model/response/employee_beat_report_table.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/ui/feedback/recommendation_by_sho_view.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class DomesticVerificationDetailActivity extends StatefulWidget {
  final data;

  const DomesticVerificationDetailActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<DomesticVerificationDetailActivity> createState() =>
      _DomesticVerificationDetailActivityState(data);
}

class _DomesticVerificationDetailActivityState
    extends BaseFullState<DomesticVerificationDetailActivity> {
  DomesticVerificationDetail _details = DomesticVerificationDetail.emptyData();
  List<DomesticDetailAttachment> _attachments = [];
  List<EmployeeBeatReport_Table> lst_assignHistory = [];
  String role = "";
  String? action = "";
  String DOMESTIC_SR_NUM = "";

  _DomesticVerificationDetailActivityState(data) {
    DOMESTIC_SR_NUM = data["DOMESTIC_SR_NUM"];
    action = data["action"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getDVDetails();
    });
  }

  late String dropdownValueBeat;
  List<String> spinnerItemsBeat = [];

  late String dropdownValueBeatCons;
  List<String> spinnerItemsBeatCons = [];

  late String dropdownValueEO;
  List<String> spinnerItemsEO = [];

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
  }

  String getSelectedBeatConsPNO() {
    return dropdownValueBeatCons.split("#")[2];
  }

  String getSelectedEOID() {
    return dropdownValueEO.split("#")[2];
  }

  void _getDVDetails() async {
    role = AppUser.ROLE_CD;
    var userData = await LoginResponseModel.fromPreference();
    var data = {"DOMESTIC_SR_NUM": DOMESTIC_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_DOMESTIC_VERIFICATION_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _details = (response.data["Table"].toList().length != 0
            ? DomesticVerificationDetail.fromJson(response.data["Table"][0])
            : null)!;
        _attachments = [];
        for (Map<String, dynamic> i in response.data["Table1"]) {
          var data = DomesticDetailAttachment.fromJson(i);
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

  var con_Remark = TextEditingController();

  bool IS_CRIMINAL_RECORD = false;

  radioOnchangeAccepted(value) {
    IS_CRIMINAL_RECORD = value;
    setState(() {});
  }

  void _saveRemark() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "DESCRIPTION": con_Remark.text.toString().trim(),
      "DISTRICT_CD": userData.districtCD,
      "DOMESTIC_SR_NUM": DOMESTIC_SR_NUM,
      "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD ? "Y" : "N"
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_DOMESTIC_VERIFICATION_DCRB, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data == 1) {
      getDashBoardCount();
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(
          context, getTranlateString("record_already_submitted"));
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("domestic_help_verification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (action != null && action == "1")
                  ? Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 10),
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationBySHo(
                                  data: {
                                    "SR_NUM": DOMESTIC_SR_NUM,
                                    "SERVICE_TYPE": "4"
                                  },
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
                            AppTranslations.of(context)!
                                .text("sho_recommendation"),
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
                          width: MediaQuery.of(context).size.width * .97,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              getTranlateString("has_employee_criminal_record"),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .97,
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
                                              radioOnchangeAccepted(true),
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
                                              radioOnchangeAccepted(false),
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
                          width: MediaQuery.of(context).size.width * .98,
                          margin: const EdgeInsets.only(top: 20),
                          child: Text(
                            getTranlateString("remark_mandatory"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: EditTextBorder(
                            controller: con_Remark,
                          ),
                        ),
                        15.height,
                        Align(
                          alignment: Alignment.topCenter,
                          child: Button(
                            title: "submit",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                DialogHelper.showLoaderDialog(context);
                                _saveRemark();
                              }
                            },
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
                    getTranlateString("personal_information"),
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
                    getTranlateString("name"),
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
                        _details.rEQUESTERNAME ?? "",
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
                    getTranlateString("nickname"),
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
                        _details.aLIASES ?? "",
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
                        _details.aPPLICANTMOBILE ?? "",
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
              CustomView.getHorizontalDevider(context),
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
                        _details.sERVANTPERMANENTADDRESS ?? "",
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
                        _details.sERVANTPRESENTADDRESS ?? "",
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
                    getTranlateString("relatives_information"),
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
                        _details.rELATIVENAME1 ?? "",
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
                        _details.rELATIVEMOBILE ?? "",
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
                        _details.rELATIVEADDRESS ?? "",
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
                    getTranlateString("last_employer"),
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
                    getTranlateString("have_it_also_worked_before"),
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
                        _details.hASPREVWORKED ?? getTranlateString("no"),
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
                        _details.pREVEMPLOYRNAME ?? "",
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
                    getTranlateString("date_from_which_started_working"),
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
                        _details.pREVIOUSEMPLOYERMOBILE ?? "",
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
                    getTranlateString("introducers_information"),
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
                    getTranlateString("introducer_name"),
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
                        _details.iNTRODUCERNAME ?? "",
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
                        _details.iNTRODUCERMOBILE ?? "",
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
                        _details.iNTRODUCERADDRESS ?? "",
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
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
