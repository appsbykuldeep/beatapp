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

class VillageAddActivity extends StatefulWidget {
  const VillageAddActivity({Key? key}) : super(key: key);

  @override
  State<VillageAddActivity> createState() => _VillageAddActivityState();
}

class _VillageAddActivityState extends State<VillageAddActivity> {
  var con_Vill_StrEng = TextEditingController();
  var con_Vill_StrHin = TextEditingController();
  int selectedVillStr = 1;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  radioOnchange(value) {
    selectedVillStr = value;
    setState(() {});
  }

  saveVillageData() async {
    LoginResponseModel user = await LoginResponseModel.fromPreference();
    VillageStreetAndBeatRequest request = VillageStreetAndBeatRequest();
    request.DISTRICT_CD = user.districtCD;
    request.PS_CD = user.psCd;
    request.IS_VILLAGE = selectedVillStr == 1 ? "Y" : "N";
    request.ENGLISH_NAME = con_Vill_StrEng.text;
    request.REGIONAL_NAME = con_Vill_StrHin.text;
    var response = await HttpRequst.postRequestTokenWithBody(
        context,
        EndPoints.END_POINT_POST_VILLAGE_ADD_DATA,
        request.toSaveVillJson(),
        false);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text('success_msg'));
      Navigator.pop(context);
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(AppTranslations.of(context)!.text("village_street_add")),
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
                  getTranlateString("village_street"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                              value: 1,
                              groupValue: selectedVillStr,
                              onChanged: radioOnchange,
                              activeColor: Colors.red),
                          Text(getTranlateString("village"))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                              value: 2,
                              groupValue: selectedVillStr,
                              onChanged: radioOnchange,
                              activeColor: Colors.red),
                          Text(getTranlateString("street"))
                        ],
                      ),
                    )
                  ],
                ),
                12.height,
                Text(
                  getTranlateString("village_street_english"),
                ),
                4.height,
                EditTextBorder(
                  controller: con_Vill_StrEng,
                  validator: Validations.emptyValidator,
                ),
                12.height,
                Text(
                  getTranlateString("village_street_hindi"),
                ),
                4.height,
                EditTextBorder(
                  controller: con_Vill_StrHin,
                  validator: Validations.emptyValidator,
                ),
                24.height,
                Button(
                  title: "submit",
                  width: double.maxFinite,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      DialogHelper.showLoaderDialog(context);
                      saveVillageData();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
