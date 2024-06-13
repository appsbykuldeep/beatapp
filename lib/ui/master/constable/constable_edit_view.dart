import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/request/constable_request.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/input_formatters.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class ConstableEditActivity extends StatefulWidget {
  final data;

  const ConstableEditActivity({Key? key, required this.data}) : super(key: key);

  @override
  State<ConstableEditActivity> createState() =>
      _ConstableEditActivityState(data);
}

class _ConstableEditActivityState extends State<ConstableEditActivity> {
  var con_Name = TextEditingController();
  var con_Mobile = TextEditingController();

  List<ConstableResponse> _rankList = [];
  List<String> spinnerItems = [];
  late String dropdownValue;
  bool isLoading = true;

  final ConstableResponse data;

  _ConstableEditActivityState(this.data);

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  saveBeatConstableData() async {
    LoginResponseModel user = await LoginResponseModel.fromPreference();
    ConstableRequest request = ConstableRequest();
    request.BEAT_PERSON_SR_NUM = data.BEAT_PERSON_SR_NUM;
    request.DISTRICT_CD = user.districtCD;
    request.PS_CD = user.ps;
    request.NAME = con_Name.text;
    request.MOBILE = con_Mobile.text;
    request.PNO = data.PNO;
    request.BEAT_RANK = getSelectedRank();
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.POST_CONSTABLE_DATA_DELETE, request.toJson(), false);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      shouldRefresh = true;
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text('success_msg'));
      Navigator.pop(context, true);
    }
  }

  String getSelectedRank() {
    for (int i = 0; i < _rankList.length; i++) {
      if (_rankList[i].OFFICER_RANK == dropdownValue) {
        return _rankList[i].OFFICER_RANK_CD.toString();
      }
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    con_Name.text = data.BEAT_CONSTABLE_NAME!;
    con_Mobile.text = data.MOBILE!;
    Timer(const Duration(milliseconds: 300), () {
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
          spinnerItems.add(rank.OFFICER_RANK!);
        }
      } catch (e) {
        e.toString();
      }
      setState(() {});
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
    _rankList = ConstableResponse.getAllRanks(context);
    dropdownValue = getTranlateString("select");
    spinnerItems = [dropdownValue];
    for (ConstableResponse rank in _rankList) {
      if (data.OFFICER_RANK!.trim() == rank.OFFICER_RANK!.trim) {
        dropdownValue = rank.OFFICER_RANK!;
      }
      spinnerItems.add("${rank.OFFICER_RANK!}#${rank.OFFICER_RANK_CD!}");
    }
    isLoading = false;
    setState(() {});
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(AppTranslations.of(context)!.text("beat_constable")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranlateString("beat_constable_detail")),
                      const Divider(),
                      Text(
                        getTranlateString("pno"),
                      ),
                      4.height,
                      Container(
                        width: double.maxFinite,
                        height: 38,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          right: 5,
                          left: 5,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.grey, width: 1.0)),
                        child: Text(
                          data.PNO!,
                          textAlign: TextAlign.left,
                          style: const TextStyle(),
                          maxLines: 1,
                        ),
                      ),
                      12.height,
                      Text(
                        getTranlateString("beat_constable_name"),
                      ),
                      4.height,
                      EditTextBorder(
                        controller: con_Name,
                        validator: Validations.emptyValidator,
                      ),
                      12.height,
                      Text(
                        getTranlateString("mobile_number"),
                      ),
                      4.height,
                      EditTextBorder(
                        controller: con_Mobile,
                        validator: Validations.mobileValidator,
                        maxLength: 10,
                        textInputType: TextInputType.number,
                        inputFormatters: digitOnly,
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
                            contentPadding:
                                const EdgeInsets.only(left: 8, right: 4),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4))),
                      ),
                      24.height,
                      Button(
                        title: "submit",
                        width: double.maxFinite,
                        onPressed:
                            dropdownValue.toLowerCase().contains("select")
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      DialogHelper.showLoaderDialog(context);
                                      saveBeatConstableData();
                                    }
                                  },
                      ),
                    ],
                  ),
                ),
              ));
  }
}
