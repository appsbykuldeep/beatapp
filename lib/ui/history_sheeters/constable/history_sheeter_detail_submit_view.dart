import 'dart:io';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/history_sheeter_detail_table.dart';
import 'package:beatapp/model/response/history_sheeters_beat_report_table.dart';
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

class HistorySheeterDetailSubmitActivity extends StatefulWidget {
  final data;

  const HistorySheeterDetailSubmitActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<HistorySheeterDetailSubmitActivity> createState() =>
      _HistorySheeterDetailSubmitActivityState(data);
}

class _HistorySheeterDetailSubmitActivityState
    extends BaseFullState<HistorySheeterDetailSubmitActivity> {
  var con_Details = TextEditingController();
  HistorySheeterDetail_Table? details;
  List<HistorySheetersBeatReport_Table> lstBeat = [];
  String role = "0";
  String HST_SR_NUM = "";
  bool IS_RESOLVED = false;
  bool IS_VERIFIED = false;
  bool ROUTINE_VERIFICATION = false;
  String PHOTO = "";
  final formKey = GlobalKey<FormState>();

  _HistorySheeterDetailSubmitActivityState(data) {
    HST_SR_NUM = data["HST_SR_NUM"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getArrestDetails();
    super.initState();
  }

  void _getArrestDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"HST_SR_NUM": HST_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_HST_DETAILS, data, true);
    if (response.statusCode == 200) {
      try {
        details = response.data["Table"].toList().length != 0
            ? HistorySheeterDetail_Table.fromJson(response.data["Table"][0])
            : null;
        for (Map<String, dynamic> i in response.data["Table1"]) {
          var data = HistorySheetersBeatReport_Table.fromJson(i);
          lstBeat.add(data);
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
      "HST_SR_NUM": HST_SR_NUM,
      "IS_RESOLVED": IS_RESOLVED ? "Y" : "N",
      "ROUTINE_VERIFICATION_STATUS":
          ROUTINE_VERIFICATION ? "VERIFIED" : "NOT VERIFIED",
      "LAT": position.latitude.toString(),
      "LONG": position.longitude.toString(),
      "PHOTO": PHOTO,
      "REMARKS": con_Details.text.toString(),
      "PS_CD": userData.psCd,
      "VERIFICATION_STATUS": IS_VERIFIED ? "VERIFIED" : "NOT VERIFIED",
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_HST_VERIFICATION, data, false);
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

  radioOnchangeIsVerified(value) {
    IS_VERIFIED = value;
    setState(() {});
  }

  radioOnchangeRoutineVerified(value) {
    ROUTINE_VERIFICATION = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("history_sheeters")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: details != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranlateString("completed"),
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
                    5.height,
                    Text(
                      getTranlateString("verification"),
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
                                    value: IS_VERIFIED,
                                    onChanged: (v) =>
                                        radioOnchangeIsVerified(true),
                                    activeColor: Colors.red),
                                Text(getTranlateString("verified"))
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Checkbox(
                                    value: !IS_VERIFIED,
                                    onChanged: (v) =>
                                        radioOnchangeIsVerified(false),
                                    activeColor: Colors.red),
                                Text(getTranlateString("not_verified"))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    5.height,
                    Text(
                      getTranlateString("routine_status"),
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
                                    value: ROUTINE_VERIFICATION,
                                    onChanged: (v) =>
                                        radioOnchangeRoutineVerified(true),
                                    activeColor: Colors.red),
                                Text(getTranlateString("verified"))
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Checkbox(
                                    value: !ROUTINE_VERIFICATION,
                                    onChanged: (v) =>
                                        radioOnchangeRoutineVerified(false),
                                    activeColor: Colors.red),
                                Text(getTranlateString("not_verified"))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    5.height,
                    Text(
                      getTranlateString("remarks"),
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
                                      )),
                                ),
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
                    5.height,
                    Text(
                      getTranlateString("information_detail"),
                    ),
                    CustomView.getHorizontalDevider(context),
                    5.height,
                    Text(
                      getTranlateString("district"),
                    ),
                    5.height,
                    Container(
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
                            details!.dISTRICT ?? "",
                          )),
                        ],
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
                              details!.pS ?? "",
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
                          getTranlateString("beat_name"),
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
                              details!.bEATNAME ?? "",
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
                          getTranlateString("village_street"),
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
                              details!.vILLSTREETNAME ?? "",
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
                          getTranlateString("history_sheeter_name"),
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
                              details!.nAME ?? "",
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
                          getTranlateString("father_name"),
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
                              details!.fATHERNAME ?? "",
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
                              details!.mOBILE ?? "",
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
                          getTranlateString("remark"),
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
                              details!.rEMARKS ?? "",
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
                          getTranlateString("hs_approval"),
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
                          getTranlateString("history_sheeter_num"),
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
                              details!.HISTORY_SHEET_NO ?? "",
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
                          getTranlateString("dt_of_opening"),
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
                              details!.DATE_OF_OPENING ?? "",
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
                          getTranlateString("nigrani_band_dt"),
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
                              details!.NIGRANI_BAND_DATE ?? "",
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
                          getTranlateString("sp_approval_hs_num"),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .96,
                        height: 60,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          right: 5,
                          left: 5,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: details!.SP_APPROVED_STATUS == "Y"
                                          ? true
                                          : false,
                                      onChanged: null,
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
                                      value: details!.SP_APPROVED_STATUS == "Y"
                                          ? false
                                          : true,
                                      onChanged: null,
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
              )
            : const SizedBox());
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
