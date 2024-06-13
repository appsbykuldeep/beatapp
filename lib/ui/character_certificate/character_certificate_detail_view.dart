import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/assign_history.dart';
import 'package:beatapp/model/character_verification_attachments.dart';
import 'package:beatapp/model/character_verification_detail.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/ui/feedback/recommendation_by_sho_view.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class CharacterCertificateDetailActivity extends StatefulWidget {
  final data;

  const CharacterCertificateDetailActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<CharacterCertificateDetailActivity> createState() =>
      _CharacterCertificateDetailActivityState(data);
}

class _CharacterCertificateDetailActivityState
    extends BaseFullState<CharacterCertificateDetailActivity> {
  var con_Details = TextEditingController();
  CharacterVerificationDetail _details =
      CharacterVerificationDetail.emptyData();
  List<CharacterVerificationAttachments> _attachments = [];
  List<AssignHistory> _assignHistory = [];
  String role = "0";
  bool isImageLoaded = false;
  var selectedViewId = 0;
  String CHARACTER_SR_NUM = "";
  String? action = "";

  _CharacterCertificateDetailActivityState(data) {
    CHARACTER_SR_NUM = data["CHARACTER_SR_NUM"];
    selectedViewId = data["id"];
    action = data["action"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getCharCertDetails();
    super.initState();
  }

  void _getCharCertDetails() async {
    role = AppUser.ROLE_CD;
    var userData = await LoginResponseModel.fromPreference();
    var data = {"CHARACTER_SR_NUM": CHARACTER_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(context,
        EndPoints.END_POINT_GET_CHARACTER_VERIFICATION_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _details = (response.data["Table"].toList().length != 0
            ? CharacterVerificationDetail.fromJson(response.data["Table"][0])
            : null)!;
        _attachments = [];
        for (Map<String, dynamic> i in response.data["Table1"]) {
          var data = CharacterVerificationAttachments.fromJson(i);
          _attachments.add(data);
        }

        _assignHistory = [];
        for (Map<String, dynamic> i in response.data["Table2"]) {
          var data = AssignHistory.fromJson(i);
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

  var con_Remark = TextEditingController();

  bool IS_CRIMINAL_RECORD = false;

  radioOnchangeAccepted(value) {
    IS_CRIMINAL_RECORD = value;
    setState(() {});
  }

  final formKey = GlobalKey<FormState>();
  void _saveRemark() async {
    var data = {
      "ACTION_TAKEN": "Y",
      "CHARACTER_SR_NUM": CHARACTER_SR_NUM,
      "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD ? "Y" : "N",
      "SP_RECOMMEND_ACTION": "Y",
      "SP_RECOMMEND_REASON": con_Remark.text.toString().trim()
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_CHARACTER_VERIFICATION_SP, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data == 1) {
      getDashBoardCount();
      Navigator.pop(context, true);
    } else {
      if (response.statusCode == 404) {
        MessageUtility.showToast(context, "Page Not Found...");
      } else {
        MessageUtility.showToast(
            context, getTranlateString("record_already_submitted"));
      }
    }
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
        body: (_details.age != null && _details.complainantName != null)
            ? SingleChildScrollView(
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
                                          "SR_NUM": CHARACTER_SR_NUM,
                                          "SERVICE_TYPE": "1"
                                        },
                                      ),
                                    ))
                              },
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
                                width: MediaQuery.of(context).size.width * .98,
                                margin: const EdgeInsets.only(top: 20),
                                child: Text(
                                  getTranlateString("remark_mandatory"),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              4.height,
                              Form(
                                key: formKey,
                                child: EditTextBorder(
                                  controller: con_Remark,
                                  validator: Validations.emptyValidator,
                                ),
                              ),
                              12.height,
                              Button(
                                title: "submit",
                                width: double.maxFinite,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    DialogHelper.showLoaderDialog(context);
                                    _saveRemark();
                                  }
                                },
                              ),
                            ],
                          )
                        : const SizedBox(),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width * .96,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          getTranlateString("beat_constable_report"),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    _assignHistory.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _assignHistory.length,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            itemBuilder: (BuildContext context, int index) {
                              return getRowForAssignHis(index);
                            })
                        : const SizedBox(),
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
                              _details.complainantName ?? "",
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
                              _details.age ?? "",
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
                              _details.relation ?? "",
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
                              _details.purpose ?? "",
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
                              _details.email ?? "",
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
                              _details.mobile ?? "",
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
                              _details.presentAddress ?? "",
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
                              _details.permanentAddress ?? "",
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
                              _details.criminalRecord == "N" ? "No" : "Yes",
                            )),
                          ],
                        ),
                      ),
                    ),
                    selectedViewId == 3
                        ? Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              onTap: () => {},
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
                                  getTranlateString("sho_uploaded_docs"),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
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
                              return getRowForAttachment(index);
                            })
                        : const SizedBox()
                  ],
                ),
              )
            : CustomView.getNoRecordView(context));
  }

  Widget getRowForAttachment(int index) {
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

  Widget getRowForAssignHis(int index) {
    var data = _assignHistory[index];
    return InkWell(
      onTap: () {},
      child: Container(
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
                        AppTranslations.of(context)!.text("beat_name"),
                        style: getHeaderStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(data.beatName ?? ""),
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
                          AppTranslations.of(context)!.text("beat_person_name"),
                          style: getHeaderStyle()),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(data.assignedTo ?? ""),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        AppTranslations.of(context)!.text("assigned_date"),
                        style: getHeaderStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(data.assignedDate ?? ""),
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
                        AppTranslations.of(context)!
                            .text("criminal_record_label"),
                        style: getHeaderStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(getTranlateString(
                          data.isCriminalRecord == "y" ? "yes" : "no")),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*Widget getRowForAssignHis(int index) {
    var data = _assignHistory[index];
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 10),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width * .96,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            right: 5,
            left: 5,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: Colors.black, width: 1.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          AppTranslations.of(context)!
                              .text("completed"),
                          style: getHeaderStyle()),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(
                                  8)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: data!
                                            .isResolved ==
                                            "Y"
                                            ? true
                                            : false,
                                        onChanged:
                                        radioOnchange,
                                        activeColor:
                                        Colors.red),
                                    Text(
                                        getTranlateString(
                                            "yes"))
                                  ],
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: _assignHistory!
                                            .data ==
                                            "Y"
                                            ? false
                                            : true,
                                        onChanged:
                                        radioOnchange,
                                        activeColor:
                                        Colors.red),
                                    Text(
                                        getTranlateString(
                                            "no"))
                                  ],
                                ),
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTranslations.of(context)!
                            .text("beat_name"),
                        style: getHeaderStyle(),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                          data!.beatName ?? ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          AppTranslations.of(context)!
                              .text("beat_person_name"),
                          style: getHeaderStyle()),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                          data!.assignedTo ??
                              ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          AppTranslations.of(context)!
                              .text(
                              "constable_remark_date"),
                          style: getHeaderStyle()),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                          data!.assignedDate ?? ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTranslations.of(context)!.text(
                            "complainant_character_description"),
                        style: getHeaderStyle(),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(data!
                          .characterDescription ??
                          ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTranslations.of(context)!
                            .text("constable_remarks"),
                        style: getHeaderStyle(),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                          data!.remark ?? ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTranslations.of(context)!.text(
                            "criminal_record_label"),
                        style: getHeaderStyle(),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(data!
                          .isCriminalRecord ==
                          "N"
                          ? getTranlateString("No")
                          : getTranlateString("Yes")),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTranslations.of(context)!
                            .text("eo_name"),
                        style: getHeaderStyle(),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                          data!.eoName ?? ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(top: 5, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTranslations.of(context)!
                            .text("photo"),
                        style: getHeaderStyle(),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () =>
                          {
                            */ /*NavigatorUtils
                                                      .launchMapsUrlFromLatLong(
                                                      double.parse(
                                                          _assignHistory!
                                                              .lat ??
                                                              "0"),
                                                      double.parse(
                                                          _assignHistory!
                                                              .lng ??
                                                              "0"))*/ /*
                          },
                          splashColor: Colors.grey,
                          child: data!.photo != null
                              ? Image.memory(
                            Base64Helper
                                .decodeBase64Image(
                                data!.photo ??
                                    ""),
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
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(top: 5, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTranslations.of(context)!
                            .text("location"),
                        style: getHeaderStyle(),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () =>
                          {
                            NavigatorUtils
                                .launchMapsUrlFromLatLong(
                                double.parse(
                                    data!
                                        .lat ??
                                        "0"),
                                double.parse(
                                    data!
                                        .lng ??
                                        "0"))
                          },
                          splashColor: Colors.grey,
                          child: Image.asset(
                            'assets/images/ic_map.png',
                            height: 80,
                            width: 80,
                          ),
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }*/
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
