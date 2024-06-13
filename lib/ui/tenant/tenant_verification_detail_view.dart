import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/tenant_beat_report_table.dart';
import 'package:beatapp/model/response/tenant_verification_attachment.dart';
import 'package:beatapp/model/response/tenant_verification_detail.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/ui/feedback/recommendation_by_sho_view.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class TenantVerificationDetailActivity extends StatefulWidget {
  final data;

  const TenantVerificationDetailActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<TenantVerificationDetailActivity> createState() =>
      _TenantVerificationDetailActivityState(data);
}

class _TenantVerificationDetailActivityState
    extends BaseFullState<TenantVerificationDetailActivity> {
  TenantVerificationDetail? _details;
  List<TenantVerificationAttachment> _attachments = [];
  List<TenantBeatReport_Table> _assignHistory = [];
  String TENANT_SR_NUM = "";
  String role = "";
  String? action = "";

  _TenantVerificationDetailActivityState(data) {
    TENANT_SR_NUM = data["TENANT_SR_NUM"];
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
    role = AppUser.ROLE_CD;
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
      MessageUtility.showToast(context, response.data.toString());
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
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "ACTION_TAKEN": IS_CRIMINAL_RECORD ? "Y" : "N",
      "DISTRICT_CD": userData.districtCD,
      "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD ? "Y" : "N",
      "OFFICE_CD": userData.officeCD,
      "REMARKS": con_Remark.text.toString().trim(),
      "SP_RECOMMEND_ACTION": "Y",
      "TENANT_SR_NUM": TENANT_SR_NUM
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_TENANT_VERIFICATION_SP, data, false);
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
          title: Text(getTranlateString("tenant_verification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: _details != null
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
                                          "SR_NUM": TENANT_SR_NUM,
                                          "SERVICE_TYPE": "2"
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
                    _assignHistory.isNotEmpty
                        ? Text(
                            getTranlateString("beat_constable_report"),
                            textAlign: TextAlign.left,
                          )
                        : const SizedBox(),
                    _assignHistory.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _assignHistory.length,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            itemBuilder: (BuildContext context, int index) {
                              return getRowForBeat(index);
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

  Widget getRowForBeat(int index) {
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
                          AppTranslations.of(context)!.text("beat_person_name"),
                          style: getHeaderStyle()),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(data.bEATCONSTABLENAME ?? ""),
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
                      child: Text(data.tARGETDT ?? ""),
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
                      child: Text(data.eNQFILLEDDT ?? ""),
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
                      child: Text(data.iSRESOLVED == "N" ? "No" : "Yes"),
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
                      child: Text(data.iSCRIMINALRECORD == "N"
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
                      child: Text(data.iSACCEPTED ?? ""),
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
                      child: Text(data.rEMARKS ?? ""),
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
                      child: Text(data.eONAME ?? ""),
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
                          child: data.pHOTO != null
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewer(
                                            data: {"image": data.pHOTO},
                                          ),
                                        ));
                                  },
                                  child: Image.memory(
                                    Base64Helper.decodeBase64Image(
                                        data.pHOTO ?? ""),
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
                                double.parse(data.lAT ?? "0"),
                                double.parse(data.lONG ?? "0"))
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
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
