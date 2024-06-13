import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/arrest.dart';
import 'package:beatapp/model/beat.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;

class AssignArrestToBeatActivity extends StatefulWidget {
  final Arrest arrest;

  const AssignArrestToBeatActivity({Key? key, required this.arrest})
      : super(key: key);

  @override
  State<AssignArrestToBeatActivity> createState() =>
      _AssignArrestToBeatActivityState(arrest);
}

class _AssignArrestToBeatActivityState
    extends BaseFullState<AssignArrestToBeatActivity> {
  Arrest _arrest;
  String _rank = "";
  String selectedDate = "";

  _AssignArrestToBeatActivityState(this._arrest);

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getArrestDetails();
    _getBeatList();
    super.initState();
  }

  String dropdownValueBeat = "Select";
  List<String> spinnerItemsBeat = ["Select"];

  String dropdownValueBeatCons = "Select";
  List<String> spinnerItemsBeatCons = ["Select"];

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
  }

  String getSelectedBeatConsPNO() {
    return dropdownValueBeatCons.split("#")[2];
  }

  void _getBeatList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_MASTER, data, true);
    if (response.statusCode == 200) {
      dropdownValueBeat = getTranlateString("select");
      spinnerItemsBeat = [dropdownValueBeat];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = Beat.fromJson(i);
          spinnerItemsBeat.add("${data.beatName!}#${data.beatCD!}");
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  void _getBeatConstableList() async {
    var data = {"BEAT_CD": getSelectedBeatId()};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_CONSTABLE_BY_BEAT_CD, data, true);
    dropdownValueBeatCons = getTranlateString("select");
    spinnerItemsBeatCons = [dropdownValueBeatCons];
    _rank = "";
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = ConstableResponse.fromJson(i);
          spinnerItemsBeatCons.add(
              "${data.BEAT_CONSTABLE_NAME!}#${data.OFFICER_RANK!}#${data.PNO!}#");
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  void _getArrestDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"ACCUSED_SRNO": _arrest.accusedSrNo, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_ACCUSED_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _arrest = Arrest.fromJson(response.data[0]);
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  bool _checkDataError() {
    if (dropdownValueBeat == getTranlateString("select")) {
      MessageUtility.showToast(context, getTranlateString("select_beat"));
    } else if (dropdownValueBeatCons == getTranlateString("select")) {
      MessageUtility.showToast(
          context, getTranlateString("select_beat_constable"));
    } else if (dropdownValueBeatCons == "") {
      MessageUtility.showToast(
          context, getTranlateString("error_select_target_date"));
    } else {
      return true;
    }
    return false;
  }

  void _saveData() async {
    bool isValid = _checkDataError();
    if (isValid) {
      var userData = await LoginResponseModel.fromPreference();
      var data = {
        "ACCUSED_SRNO": _arrest.accusedSrNo,
        "ASSIGN_TO": getSelectedBeatConsPNO(),
        "BEAT_CD": getSelectedBeatId(),
        "DISTRICT_CD": userData.districtCD,
        "FIR_REG_NUM": _arrest.firRegNum,
        "PS_CD": userData.psCd,
        "TARGET_DT": selectedDate
      };
      var response = await HttpRequst.postRequestWithTokenAndBody(
          context, EndPoints.END_POINT_ASSIGN_ARREST_TO_BEAT, data, false);
      Navigator.pop(context);
      if (response.statusCode == 200) {
        shouldRefresh = true;
        getDashBoardCount();
        MessageUtility.showToast(context, getTranlateString("success_msg"));
        Navigator.pop(context, ["success"]);
      } else {
        MessageUtility.showToast(
            context, getTranlateString("beat_constable_already_assigned"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(getTranlateString("assign_arrest")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranlateString("beat_name"),
                ),
                4.height,
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: dropdownValueBeat,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onChanged: (String? data) {
                    dropdownValueBeat = data!;
                    if (dropdownValueBeat == getTranlateString("select")) {
                      spinnerItemsBeatCons = [];
                      _rank = "";
                    } else {
                      _getBeatConstableList();
                    }
                    setState(() {});
                  },
                  items: spinnerItemsBeat
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.split("#")[0],
                          style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
                12.height,
                Text(
                  getTranlateString("beat_person_name"),
                ),
                4.height,
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: dropdownValueBeatCons,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onChanged: (String? data) {
                    dropdownValueBeatCons = data!;
                    if (data != getTranlateString("select")) {
                      _rank = data.split("#")[1];
                    } else {
                      _rank = "";
                    }
                    setState(() {});
                  },
                  items: spinnerItemsBeatCons
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.split("#")[0],
                          style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
                4.height,
                Text(
                  getTranlateString("rank"),
                ),
                4.height,
                Container(
                  width: double.maxFinite,
                  height: 35,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        _rank,
                      )),
                    ],
                  ),
                ),
                4.height,
                Text(
                  getTranlateString("target_date"),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          selectedDate,
                        )),
                        InkWell(
                            onTap: () async {
                              selectedDate =
                                  await DialogHelper.openDatePickerDialog(
                                      context);
                              setState(() {});
                            },
                            child: const Icon(Icons.date_range))
                      ],
                    ),
                  ),
                ),
                4.height,
                Button(
                  title: "submit",
                  width: double.maxFinite,
                  onPressed: [dropdownValueBeat, dropdownValueBeatCons]
                          .contains("Select")
                      ? null
                      : () {
                          DialogHelper.showLoaderDialog(context);
                          _saveData();
                        },
                ),
                const Divider(),
                12.height,
                Text(
                  getTranlateString("accused_name"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.accusedName ?? "",
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
                      getTranlateString("fir_no"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.firNum ?? "",
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
                      getTranlateString("fir_date"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.firDate ?? "",
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
                      getTranlateString("act_section"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.actSection ?? "",
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
                      getTranlateString("accused_present_address"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.accusedPresentAddress ?? "",
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
                      getTranlateString("accused_permanent_address"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.accusedPermanentAddress ?? "",
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.mobile ?? "",
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
