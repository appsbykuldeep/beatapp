// ignore_for_file: unused_field

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/assign_history.dart';
import 'package:beatapp/model/character_verification_attachments.dart';
import 'package:beatapp/model/character_verification_detail.dart';
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
import 'package:geolocator/geolocator.dart';

class VerifyCharacterActivity extends StatefulWidget {
  final data;

  const VerifyCharacterActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<VerifyCharacterActivity> createState() =>
      _VerifyCharacterActivityState(data);
}

class _VerifyCharacterActivityState
    extends BaseFullState<VerifyCharacterActivity> {
  var con_Details = TextEditingController();
  var con_Desc = TextEditingController();
  CharacterVerificationDetail? _details;
  CharacterVerificationAttachments? _attachments;
  AssignHistory? _assignHistory;
  String role = "0";
  bool isImageLoaded = false;
  String CHARACTER_SR_NUM = "";
  bool IS_RESOLVED = false;
  bool IS_CRIMINAL_RECORD = false;
  bool IS_INVOLVE_IN_CRIME = false;
  String PHOTO = "";

  _VerifyCharacterActivityState(data) {
    CHARACTER_SR_NUM = data["CHARACTER_SR_NUM"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  final formKey = GlobalKey<FormState>();

  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      Navigator.pop(context);
      if (Platform.isAndroid) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Can't get gurrent location"),
              content:
                  const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                Button(
                  title: "Enable",
                  onPressed: () {
                    const AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      saveData();
    }
  }

  @override
  void initState() {
    _getCharCertDetails();
    super.initState();
  }

  void _getCharCertDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"CHARACTER_SR_NUM": CHARACTER_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(context,
        EndPoints.END_POINT_GET_CHARACTER_VERIFICATION_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _details = response.data["Table"].toList().length != 0
            ? CharacterVerificationDetail.fromJson(response.data["Table"][0])
            : null;
        _attachments = response.data["Table1"].toList().length != 0
            ? CharacterVerificationAttachments.fromJson(
                response.data["Table1"][0])
            : null;
        _assignHistory = response.data["Table2"].toList().length != 0
            ? AssignHistory.fromJson(response.data["Table2"][0])
            : null;
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
      "CHARACTER_SR_NUM": CHARACTER_SR_NUM,
      "IS_RESOLVED": IS_RESOLVED ? "Y" : "N",
      "LAT": position.latitude.toString(),
      "LONG": position.longitude.toString(),
      "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD ? "Y" : "N",
      "IS_INVOLVE_IN_CRIME": IS_INVOLVE_IN_CRIME ? "Y" : "N",
      "REMARKS": con_Details.text.toString(),
      "PHOTO": PHOTO,
      "CHAR_DESCRIPTION": con_Desc.text.toString(),
      "PS_CD": userData.psCd
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(context,
        EndPoints.END_POINT_SUBMIT_CHARACTER_VERIFICATION, data, false);
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

  radioOnchangeInvolvevCriminal(value) {
    IS_INVOLVE_IN_CRIME = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(getTranlateString("character_certificate")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: _details != null
            ? SingleChildScrollView(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                8.height,
                                Text(
                                  getTranlateString("criminal_record_label"),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Container(
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
                                8.height,
                                Text(
                                  getTranlateString(
                                      "criminal_record_detail_label"),
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
                                                value: IS_INVOLVE_IN_CRIME,
                                                onChanged: (v) =>
                                                    radioOnchangeInvolvevCriminal(
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
                                                value: !IS_INVOLVE_IN_CRIME,
                                                onChanged: (v) =>
                                                    radioOnchangeInvolvevCriminal(
                                                        false),
                                                activeColor: Colors.red),
                                            Text(getTranlateString("no"))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                5.height,
                                Text(
                                  getTranlateString(
                                      "complainant_character_description"),
                                  textAlign: TextAlign.left,
                                ),
                                5.height,
                                Container(
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
                                          controller: con_Desc,
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
                              ],
                            ),
                          8.height,
                          Text(
                            getTranlateString("details"),
                            textAlign: TextAlign.left,
                          ),
                          5.height,
                          Form(
                            key: formKey,
                            child: EditTextBorder(
                              controller: con_Details,
                              suffixIcon: const Icon(
                                Icons.mic,
                                size: 18,
                              ),
                              validator: Validations.emptyValidator,
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
                                        PHOTO = Base64Helper.encodeImage(image);
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
                                      _checkGps();
                                    }
                                  },
                          ),
                          //getTranlateString(""),
                        ],
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
                            getTranlateString("applicant_name"),
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
                                _details!.complainantName ?? "",
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
                                _details!.age ?? "",
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
                            getTranlateString("relation_type"),
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
                                _details!.relation ?? "",
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
                            getTranlateString("service_purpose"),
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
                                _details!.purpose ?? "",
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
                                _details!.email ?? "",
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
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.mobile ?? "",
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
                                _details!.presentAddress ?? "",
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
                                _details!.permanentAddress ?? "",
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
                            getTranlateString("has_criminal_record"),
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
                                _details!.criminalRecord == "N" ? "No" : "Yes",
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
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
