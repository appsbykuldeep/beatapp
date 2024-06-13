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

class SubmitEoReportCitizenMessages extends StatefulWidget {
  final data;

  const SubmitEoReportCitizenMessages({Key? key, required this.data})
      : super(key: key);

  @override
  State<SubmitEoReportCitizenMessages> createState() =>
      _SubmitEoReportCitizenMessagesState(data);
}

class _SubmitEoReportCitizenMessagesState
    extends State<SubmitEoReportCitizenMessages> {
  var con_Remark = TextEditingController();
  bool IS_ACCEPTED = false;
  var PERSONID;

  _SubmitEoReportCitizenMessagesState(data) {
    PERSONID = data["PERSONID"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  void _saveRemark() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "IS_RESOLVED": IS_ACCEPTED ? "Y" : "N",
      "PERSONID": PERSONID,
      "PS_CD": userData.psCd,
      "REMARKS": con_Remark.text.toString().trim()
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_CS_SHARED_INFO_EO, data, true);
    if (response.statusCode == 200 && response.data == 1) {
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
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
        title: Text(getTranlateString("enquiry_officer_remarks")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranlateString("action"),
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
                              value: IS_ACCEPTED,
                              onChanged: (v) => radioOnchangeAccepted(true),
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
                              onChanged: (v) => radioOnchangeAccepted(false),
                              activeColor: Colors.red),
                          Text(getTranlateString("rejected"))
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
              25.height,
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
