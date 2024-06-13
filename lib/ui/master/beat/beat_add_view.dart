import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/request/village_street_and_beat_request.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class BeatAddActivity extends StatefulWidget {
  const BeatAddActivity({Key? key}) : super(key: key);

  @override
  State<BeatAddActivity> createState() => _BeatAddActivityState();
}

class _BeatAddActivityState extends State<BeatAddActivity> {
  var con_BeatNameEng = TextEditingController();
  var con_BeatNameHin = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  saveBeatData() async {
    LoginResponseModel user = await LoginResponseModel.fromPreference();
    VillageStreetAndBeatRequest request = VillageStreetAndBeatRequest();
    request.DISTRICT_CD = user.districtCD;
    request.PS_CD = user.psCd;
    request.BEAT_NAME_ENGLISH = con_BeatNameEng.text;
    request.BEAT_NAME_HINDI = con_BeatNameHin.text;
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.BEAT_DATA_SUBMIT, request.toJson(), false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data == 1) {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text('success_msg'));
      Navigator.pop(context);
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text("beat_already_added"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(AppTranslations.of(context)!.text("add_beat")),
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
                  getTranlateString("beat_name_english"),
                ),
                4.height,
                //173
                EditTextBorder(
                  controller: con_BeatNameEng,
                  validator: Validations.emptyValidator,
                ),
                12.height,
                Text(
                  getTranlateString("beat_name_hindi"),
                ),
                4.height,
                EditTextBorder(
                  controller: con_BeatNameHin,
                  validator: Validations.emptyValidator,
                ),
                24.height,
                Button(
                  title: "submit",
                  width: double.maxFinite,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      DialogHelper.showLoaderDialog(context);
                      saveBeatData();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
