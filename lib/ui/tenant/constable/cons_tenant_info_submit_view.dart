// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/tenant_beat_report_table.dart';
import 'package:beatapp/model/response/tenant_verification_attachment.dart';
import 'package:beatapp/model/response/tenant_verification_detail.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/loaction_utils.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ConsTenantInfoSubmitActivity extends StatefulWidget {
  final data;

  const ConsTenantInfoSubmitActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<ConsTenantInfoSubmitActivity> createState() =>
      _ConsTenantInfoSubmitActivityState(data);
}

class _ConsTenantInfoSubmitActivityState
    extends BaseFullState<ConsTenantInfoSubmitActivity> {
  TenantVerificationDetail? _details;
  List<TenantVerificationAttachment> _attachments = [];
  List<TenantBeatReport_Table> _assignHistory = [];
  String TENANT_SR_NUM = "";
  bool IS_RESOLVED = false;
  bool IS_CRIMINAL_RECORD = false;
  bool IS_ACCEPTED = false;
  String PHOTO = "";
  var con_Details = TextEditingController();

  _ConsTenantInfoSubmitActivityState(data) {
    TENANT_SR_NUM = data["TENANT_SR_NUM"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getTenantDetails();
    super.initState();
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
      "TENANT_SR_NUM": TENANT_SR_NUM,
      "IS_RESOLVED": IS_RESOLVED ? "Y" : "N",
      "LAT": position != null ? position.latitude.toString() : "0",
      "LONG": position != null ? position.longitude.toString() : "0",
      "PHOTO": PHOTO,
      "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD ? "Y" : "N",
      "IS_ACCEPTED": IS_ACCEPTED ? "Y" : "N",
      "REMARKS": con_Details.text.toString(),
      "PS_CD": userData.psCd
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_TENANT_VERIFICATION, data, true);
    if (response.statusCode == 200 && response.data == 1) {
      getDashBoardCount();
      MessageUtility.showToast(context, getTranlateString("success_msg"));
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(context, getTranlateString("error_msg"));
    }
  }

  void _getTenantDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"TENANT_SR_NUM": TENANT_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_TENANT_VERIFICATION_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _details = response.data["Table"].toList().length != 0
            ? TenantVerificationDetail.fromJson(response.data["Table"][0])
            : null;
        _attachments = [];
        for (Map<String, dynamic> i in response.data["Table1"]) {
          var data = TenantVerificationAttachment.fromJson(i);
          _attachments.add(data);
        }
        _assignHistory = [];
        for (Map<String, dynamic> i in response.data["Table2"]) {
          var data = TenantBeatReport_Table.fromJson(i);
          _assignHistory.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("tenant_verification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: _details != null
            ? SingleChildScrollView(
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
                                    width:
                                        MediaQuery.of(context).size.width * .96,
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
                                    width:
                                        MediaQuery.of(context).size.width * .96,
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
                                                        data: {"image": PHOTO},
                                                      ),
                                                    ));
                                              },
                                              child: Image.memory(
                                                Base64Helper.decodeBase64Image(
                                                    PHOTO),
                                                height: 80,
                                                width: 80,
                                              ),
                                            )),
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
                                width: MediaQuery.of(context).size.width * .96,
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.oWNERNAME ?? "",
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
                              _details!.oWNEREMAIL ?? "",
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
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.oWNERMOBILE ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.oCCUPATION ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.oWNERADDRESS ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.tENANTNAME ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.gender ?? "",
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
                              _details!.tENANTMOBILE ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.tENANTEMAIL ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.tENANCYPURPOSE ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.oCCUPATION1 ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.tENANTPRESENTADDRESS ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.tENANTPREVIOUSADDRESS ?? "",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _details!.tENANTPERMANENTADDRESS ?? "",
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
                    _attachments.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _attachments.length,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            itemBuilder: (BuildContext context, int index) {
                              return getRowForAttachments(index);
                            })
                        : const SizedBox()
                  ],
                ),
              )
            : const SizedBox());
  }

  Widget getRowForAttachments(int index) {
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
