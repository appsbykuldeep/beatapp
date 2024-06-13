import 'dart:io';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/arrest.dart';
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

class ArrestAccuseActivity extends StatefulWidget {
  final Arrest arrest;

  const ArrestAccuseActivity({Key? key, required this.arrest})
      : super(key: key);

  @override
  State<ArrestAccuseActivity> createState() =>
      _ArrestAccuseActivityState(arrest);
}

class _ArrestAccuseActivityState extends BaseFullState<ArrestAccuseActivity> {
  var con_Details = TextEditingController();
  Arrest _arrest;
  String role = "0";
  bool isImageLoaded = false;
  bool IS_ARRESTED = false;
  bool IS_RESOLVED = false;
  String PHOTO = "";
  String REMARKS = "";

  _ArrestAccuseActivityState(this._arrest);

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getArrestDetails();
    super.initState();
  }

  getUserRole() async {
    role = AppUser.ROLE_CD;
    setState(() {});
  }

  void _getArrestDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"ACCUSED_SRNO": _arrest.accusedSrNo, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_ACCUSED_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _arrest = Arrest.fromJson(response.data[0]);
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
    var data = {
      "ACCUSED_SRNO": _arrest.accusedSrNo,
      "FIR_REG_NUM": _arrest.firRegNum,
      "IS_ARRESTED": IS_ARRESTED ? "Y" : "N",
      "IS_RESOLVED": IS_RESOLVED ? "Y" : "N",
      "REMARKS": con_Details.text.toString(),
      "LAT": position.latitude.toString(),
      "LONG": position.longitude.toString(),
      "PHOTO": PHOTO
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_SUBMIT_ARREST_DETAIL_BEAT, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data == 1) {
      getDashBoardCount();
      MessageUtility.showToast(context, getTranlateString("success_msg"));

      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(context, getTranlateString("error_msg"));
    }
  }

  radioOnchangeIsResolve(value) {
    IS_RESOLVED = value;
    setState(() {});
  }

  radioOnchangeIsArrested(value) {
    IS_ARRESTED = value;
    setState(() {});
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: const Text("Allot arrest"),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
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
                                          (radioOnchangeIsResolve(true)),
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
                                          (radioOnchangeIsResolve(false)),
                                      activeColor: Colors.red),
                                  Text(getTranlateString("no"))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      8.height,
                      Text(
                        getTranlateString("arrest_done"),
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
                                      value: IS_ARRESTED,
                                      onChanged: (v) =>
                                          (radioOnchangeIsArrested(true)),
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
                                      value: !IS_ARRESTED,
                                      onChanged: (v) =>
                                          (radioOnchangeIsArrested(false)),
                                      activeColor: Colors.red),
                                  Text(getTranlateString("no"))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      8.height,
                      Text(
                        getTranlateString("details"),
                        textAlign: TextAlign.left,
                      ),
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
                      12.height,
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
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
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
                                                builder: (context) =>
                                                    ImageViewer(
                                                  data: {"image": PHOTO},
                                                ),
                                              ));
                                        },
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
                                      )),
                                ],
                              )
                          ],
                        ),
                      ),
                      12.height,
                      Button(
                        title: "submit",
                        width: double.maxFinite,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            DialogHelper.showLoaderDialog(context);
                            saveData();
                          }
                        },
                      ),
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
                      getTranlateString("accused_name"),
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
                          _arrest.accusedName ?? "",
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
                      getTranlateString("fir_no"),
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
                          _arrest.firNum ?? "",
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
                      getTranlateString("fir_date"),
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
                          _arrest.firDate ?? "",
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
                      getTranlateString("act_section"),
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
                          _arrest.actSection ?? "",
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
                      getTranlateString("accused_present_address"),
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
                          _arrest.accusedPresentAddress ?? "",
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
                      getTranlateString("accused_permanent_address"),
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
                          _arrest.accusedPermanentAddress ?? "",
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
                          _arrest.mobile ?? "",
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
