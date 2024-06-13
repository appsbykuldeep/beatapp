import 'dart:async';
import 'dart:convert';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/request/constable_request.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/preferences/constraints.dart';
import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/input_formatters.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;

class ConstableAddActivity extends StatefulWidget {
  const ConstableAddActivity({Key? key}) : super(key: key);

  @override
  State<ConstableAddActivity> createState() => _ConstableAddActivityState();
}

class _ConstableAddActivityState extends State<ConstableAddActivity> {
  var con_Name = TextEditingController();
  var con_Mobile = TextEditingController();
  var con_Pno = TextEditingController();

  final List<ConstableResponse> _rankList = [];
  List<String> spinnerItems = ["Select"];
  String dropdownValue = "Select";

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  checkValidPNO() async {
    var request = {"MOBILE": con_Mobile.text, "PNO": con_Pno.text};
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.VALIDATE_CONSTABLE_PNO, request, false);
    if (response.statusCode == 200) {
      if (response.data.toString().trim() == "") {
        saveBeatConstableData();
      } else {
        Navigator.pop(context);
        DialogHelper.showMessageDialog(context, response.data);
      }
    } else {
      Navigator.pop(context);
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  saveBeatConstableData() async {
    var userJson = await PreferenceHelper().getString(Constraints.USER_DATA);
    LoginResponseModel user =
        LoginResponseModel.fromJson(jsonDecode(userJson!));
    ConstableRequest request = ConstableRequest();
    request.DISTRICT_CD = user.districtCD;
    request.PS_CD = user.psCd;
    request.NAME = con_Name.text;
    request.MOBILE = con_Mobile.text;
    request.PNO = con_Pno.text;
    request.BEAT_RANK = getSelectedRank();
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.POST_CONSTABLE_DATA, request.toJson(), false);

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

  String getSelectedRank() {
    if (dropdownValue.contains("#")) {
      return dropdownValue.split("#")[1];
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      getRankList();
    });
  }

  void getRankList() async {
    var response = await HttpRequst.postRequestWithToken(
        context, EndPoints.GET_RANK_MASTER, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var rank = ConstableResponse.fromRankJson(i);
          _rankList.add(rank);
          spinnerItems.add("${rank.OFFICER_RANK!}#${rank.OFFICER_RANK_CD!}");
        }
      } catch (e) {
        e.toString();
      }
      setState(() {});
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
      Navigator.pop(context);
    }
    /*_rankList = ConstableResponse.getAllRanks(context);
    dropdownValue = getTranlateString("select");
    spinnerItems = [dropdownValue];
    for (ConstableResponse rank in _rankList) {
      spinnerItems.add(rank.OFFICER_RANK! + "#" + rank.OFFICER_RANK_CD!);
    }*/
    setState(() {});
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(AppTranslations.of(context)!.text("beat_constable_add")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranlateString("beat_constable_name"),
                ),
                4.height,
                EditTextBorder(
                  controller: con_Name,
                  validator: Validations.emptyValidator,
                ),
                8.height,
                Text(
                  getTranlateString("mobile_number"),
                ),
                4.height,
                EditTextBorder(
                  controller: con_Mobile,
                  validator: Validations.mobileValidator,
                  textInputType: TextInputType.phone,
                  inputFormatters: digitOnly,
                  maxLength: 10,
                ),
                8.height,
                Text(
                  getTranlateString("pno"),
                ),
                4.height,
                EditTextBorder(
                  controller: con_Pno,
                  validator: Validations.emptyValidator,
                ),
                12.height,
                Text(
                  getTranlateString("rank"),
                ),
                4.height,
                DropdownButtonFormField(
                  isExpanded: true,
                  value: dropdownValue,
                  items: spinnerItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.split("#")[0],
                      ),
                    );
                  }).toList(),
                  onChanged: (v) {
                    dropdownValue = v!;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 8, right: 4),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4))),
                ),
                24.height,
                Button(
                  title: "submit",
                  width: double.maxFinite,
                  onPressed: dropdownValue == "Select"
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            DialogHelper.showLoaderDialog(context);
                            checkValidPNO();
                          }
                        },
                )
              ],
            ),
          ),
        ));
  }
}
