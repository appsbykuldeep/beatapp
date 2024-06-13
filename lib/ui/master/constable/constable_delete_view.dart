import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class ConstableDeleteActivity extends StatefulWidget {
  final ConstableResponse data;

  const ConstableDeleteActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<ConstableDeleteActivity> createState() =>
      _ConstableDeleteActivityState(data);
}

class _ConstableDeleteActivityState extends State<ConstableDeleteActivity> {
  var con_feedback = TextEditingController();
  final ConstableResponse data;

  _ConstableDeleteActivityState(this.data);

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  deleteData() async {
    var request = {
      "BEAT_PERSON_SR_NUM": data.BEAT_PERSON_SR_NUM,
      "DELETE_REMARKS": con_feedback.text
    };
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.POST_CONSTABLE_DATA_DELETE, request, false);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      MessageUtility.showToast(
          context, getTranlateString("record_successfully_deleted"));
      Navigator.pop(context, true);
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: const Text("Delete Beat Constable"),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranlateString("feedback"),
                ),
                4.height,
                EditTextBorder(
                  controller: con_feedback,
                  validator: Validations.emptyValidator,
                ),
                24.height,
                Button(
                  title: "submit",
                  width: double.maxFinite,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      DialogHelper.showLoaderDialog(context);
                      deleteData();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
