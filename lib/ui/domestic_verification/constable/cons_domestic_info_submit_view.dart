import 'dart:async';
import 'dart:io';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/base_statefull.dart';
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
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/loaction_utils.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class ConsDomesticInfoSubmitActivity extends StatefulWidget {
  final data;

  const ConsDomesticInfoSubmitActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<ConsDomesticInfoSubmitActivity> createState() =>
      _ConsDomesticInfoSubmitActivityState(data);
}

class _ConsDomesticInfoSubmitActivityState
    extends BaseFullState<ConsDomesticInfoSubmitActivity> {
  DomesticVerificationDetail _details = DomesticVerificationDetail.emptyData();
  List<DomesticDetailAttachment> _attachments = [];
  List<EmployeeBeatReport_Table> lst_assignHistory = [];

  String DOMESTIC_SR_NUM = "";
  bool IS_RESOLVED = false;
  bool IS_CRIMINAL_RECORD = false;
  bool IS_ACCEPTED = false;
  String PHOTO = "";
  var con_Details = TextEditingController();
  var con_NeighReport = TextEditingController();
  var con_EmpReport = TextEditingController();

  _ConsDomesticInfoSubmitActivityState(data) {
    DOMESTIC_SR_NUM = data["DOMESTIC_SR_NUM"];
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

  void _getDVDetails() async {
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

  void saveData() async {
    var position = await LocationUtils().determinePosition();
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "DOMESTIC_SR_NUM": DOMESTIC_SR_NUM,
      "IS_RESOLVED": IS_RESOLVED ? "Y" : "N",
      "LAT": position.latitude.toString(),
      "LONG": position.longitude.toString(),
      "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD ? "Y" : "N",
      "IS_ACCEPTED": IS_ACCEPTED ? "Y" : "N",
      "PHOTO": PHOTO,
      "REMARKS": con_Details.text.toString(),
      "PS_CD": userData.psCd,
      "NEIGHBOUR_REPORT": con_NeighReport.text.toString(),
      "PREV_EMPLYR_REPORT": con_EmpReport.text.toString(),
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_DOMESTIC_VERIFICATION, data, false);
    Navigator.pop(context);
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
          padding: const EdgeInsets.all(8),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranlateString("completed"),
                      textAlign: TextAlign.left,
                    ),
                    5.height,
                    Container(
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
                    if (IS_RESOLVED)
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width * .96,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                getTranlateString("criminal_record_label"),
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
                            width: MediaQuery.of(context).size.width * .96,
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
                                            value: IS_ACCEPTED,
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
                                            value: !IS_ACCEPTED,
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
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width * .96,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                getTranlateString(
                                    "previous_employer_verification_result"),
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
                                      controller: con_EmpReport,
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
                                getTranlateString(
                                    "neighbour_verification_result"),
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
                                      controller: con_NeighReport,
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
                        ],
                      ),
                    5.height,
                    Text(
                      getTranlateString("details"),
                      textAlign: TextAlign.left,
                    ),
                    5.height,
                    Form(
                      key: formKey,
                      child: EditTextBorder(
                        controller: con_Details,
                        validator: Validations.emptyValidator,
                        suffixIcon: const Icon(
                          Icons.mic,
                          size: 18,
                        ),
                      ),
                    ),
                    5.height,
                    Text(
                      getTranlateString("upload_photo"),
                      textAlign: TextAlign.left,
                    ),
                    5.height,
                    Container(
                      height: 100,
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
                          InkWell(
                              onTap: () async {
                                File? image = await CameraAndFileProvider()
                                    .pickImageFromCamera();
                                if (image != null) {
                                  PHOTO = Base64Helper.encodeImage(image);
                                  setState(() {});
                                }
                              },
                              child: const Icon(Icons.camera_alt)),
                          if (PHOTO != "")
                            Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(left: 26),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ImageViewer(
                                                data: {"image": PHOTO},
                                              ),
                                            ));
                                      },
                                      child: Image.memory(
                                        Base64Helper.decodeBase64Image(PHOTO),
                                        height: 80,
                                        width: 80,
                                      ),
                                    )),
                                Container(
                                  margin: const EdgeInsets.only(left: 26),
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
                    12.height,
                    Button(
                      title: "submit",
                      width: double.maxFinite,
                      onPressed: PHOTO.isEmpty
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                DialogHelper.showLoaderDialog(context);
                                saveData();
                              }
                            },
                    ),
                  ],
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
          ),
        ));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
