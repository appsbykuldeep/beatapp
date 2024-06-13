import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class RecommendationBySHo extends StatefulWidget {
  final data;

  const RecommendationBySHo({Key? key, required this.data}) : super(key: key);

  @override
  State<RecommendationBySHo> createState() => _RecommendationBySHoState(data);
}

class _RecommendationBySHoState extends State<RecommendationBySHo> {
  var con_Remark = TextEditingController();
  late String SR_NUM;
  late String SERVICE_TYPE;

  _RecommendationBySHoState(data) {
    SR_NUM = data["SR_NUM"];
    SERVICE_TYPE = data["SERVICE_TYPE"];
    con_Remark.text = "Case Accepted";
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  final formKey = GlobalKey<FormState>();

  void _saveRemark() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {};
    String actionApi = "";
    if (SERVICE_TYPE == "1") {
      actionApi = EndPoints.END_POINT_CHARACTER_SUBMIT_ACTION;
      data = {
        "CHARACTER_SR_NUM": SR_NUM,
        "DESCRIPTION": con_Remark.text.toString().trim(),
        "PS_CD": userData.psCd
      };
    } else if (SERVICE_TYPE == "2") {
      actionApi = EndPoints.END_POINT_TENANT_SUBMIT_ACTION;
      data = {
        "DESCRIPTION": con_Remark.text.toString().trim(),
        "IS_ACCEPTED": IS_ACCEPTED ? "Y" : "N",
        "IS_CRIMINAL_RECORD": IS_CriminalRecord ? "Y" : "N",
        "PS_CD": userData.psCd,
        "TENANT_SR_NUM": SR_NUM
      };
    } else if (SERVICE_TYPE == "3") {
      actionApi = EndPoints.END_POINT_EMPLOYEE_SUBMIT_ACTION;
      data = {
        "DESCRIPTION": con_Remark.text.toString().trim(),
        "IS_ACCEPTED": IS_ACCEPTED ? "Y" : "N",
        "IS_CRIMINAL_RECORD": IS_CriminalRecord ? "Y" : "N",
        "PS_CD": userData.psCd,
        "TENANT_SR_NUM": SR_NUM
      };
    } else if (SERVICE_TYPE == "4") {
      actionApi = EndPoints.END_POINT_EMPLOYEE_SUBMIT_ACTION;
      data = {
        "DESCRIPTION": con_Remark.text.toString().trim(),
        "EMPLOYEE_SR_NUM": SR_NUM,
        "IS_ACCEPTED": IS_ACCEPTED ? "Y" : "N",
        "PS_CD": userData.psCd
      };
    }

    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, actionApi, data, true);
    if (response.statusCode == 200 && response.data == 1) {
      print(response.data.toString());
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  bool IS_ACCEPTED = false;

  radioOnchangeAccepted(value) {
    IS_ACCEPTED = value;
    setState(() {});
  }

  bool IS_CriminalRecord = false;

  radioOnchangeCriminalRecord(value) {
    IS_CriminalRecord = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("enquiry_officer_remarks")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
          margin:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (SERVICE_TYPE == "3" ||
                      SERVICE_TYPE == "4" ||
                      SERVICE_TYPE == "2")
                  ? Column(
                      children: [
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
                                      Text(getTranlateString("accepted"))
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
                                      Text(getTranlateString("rejected"))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              (SERVICE_TYPE == "2" || SERVICE_TYPE == "3")
                  ? Column(
                      children: [
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
                                          value: IS_CriminalRecord,
                                          onChanged: (v) =>
                                              radioOnchangeCriminalRecord(true),
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
                                          value: !IS_CriminalRecord,
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
                      ],
                    )
                  : const SizedBox(),
              20.height,
              Text(
                getTranlateString("remark_mandatory"),
              ),
              5.height,
              Form(
                key: formKey,
                child: EditTextBorder(
                  controller: con_Remark,
                  validator: Validations.emptyValidator,
                ),
              ),
              24.height,
              Align(
                alignment: Alignment.topCenter,
                child: Button(
                  title: "submit",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _saveRemark();
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
