import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class EoFeedbackActivity extends StatefulWidget {
  final data;

  const EoFeedbackActivity({Key? key, required this.data}) : super(key: key);

  @override
  State<EoFeedbackActivity> createState() => _EoFeedbackActivityState(data);
}

class _EoFeedbackActivityState extends BaseFullState<EoFeedbackActivity> {
  var con_Remark = TextEditingController();
  late String APPLICATION_SR_NUM;
  late String SERVICE_TYPE;

  _EoFeedbackActivityState(data) {
    APPLICATION_SR_NUM = data["APPLICATION_SR_NUM"];
    SERVICE_TYPE = data["SERVICE_TYPE"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  void _saveRemark() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "APPLICATION_SR_NUM": APPLICATION_SR_NUM,
      "PS_CD": userData.psCd,
      "REMARKS": con_Remark.text.toString().trim(),
      "SERVICE_TYPE": SERVICE_TYPE
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_EO_REPORT, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data == 1) {
      getDashBoardCount();
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
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
          margin:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranlateString("remark_mandatory"),
              ),
              Form(
                key: formKey,
                child: TextFormField(
                  validator: Validations.emptyValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: con_Remark,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                ),
              ),
              25.height,
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
              ),
            ],
          )),
    );
  }
}
