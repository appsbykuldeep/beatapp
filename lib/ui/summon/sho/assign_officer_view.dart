import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/beat.dart';
import 'package:beatapp/model/request/summon_assign_to_officer_request.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/summon_detail_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AssignOfficerActivity extends StatefulWidget {
  final Map<String, String?> data;

  const AssignOfficerActivity({Key? key, required this.data}) : super(key: key);

  @override
  State<AssignOfficerActivity> createState() => _AssignOfficerActivityState();
}

class _AssignOfficerActivityState extends BaseFullState<AssignOfficerActivity> {
  SummonDetailResponse? _summon;
  String _rank = "";
  String selectedDate = "";
  String SUMM_WARR_NUM = "";

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    SUMM_WARR_NUM = widget.data["SUMM_WARR_NUM"] ?? "";
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _getBeatList();
      await _getSummonDetails();
    });
  }

  late String dropdownValueBeat = getTranlateString("select");
  List<String> spinnerItemsBeat = [];

  late String dropdownValueBeatCons = getTranlateString("select");
  List<String> spinnerItemsBeatCons = [];

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
  }

  String getSelectedBeatConsPNO() {
    return dropdownValueBeatCons.split("#")[2];
  }

  Future<void> _getBeatList() async {
    print("_getBeatList");

    var data = {
      "PS_CD": AppUser.PS_CD,
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_MASTER, data, true);
    print(response.data);
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

  Future<void> _getSummonDetails() async {
    print("_getSummonDetails");
    var data = {"SUMM_WARR_NUM": SUMM_WARR_NUM, "TYPE": EndPoints.TYPE};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_SUMMON_DETAIL_BY_ID, data, true);
    if (response.statusCode == 200) {
      try {
        _summon = SummonDetailResponse.fromJson(response.data);
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
      SummonAssignToOfficerRequest summon = SummonAssignToOfficerRequest();
      summon.SUMM_WARR_NUM = SUMM_WARR_NUM;
      summon.BEAT_CD = getSelectedBeatId();
      summon.SUMM_ASSIGN_TO = getSelectedBeatConsPNO();
      summon.DISTRICT_CD = userData.districtCD;
      summon.PS_CD = userData.psCd;
      summon.TARGET_DT = selectedDate;
      var data = summon.toJson();
      var response = await HttpRequst.postRequestWithTokenAndBody(
        context,
        EndPoints.SUMMON_ASSIGN_TO_OFFICER,
        data,
        true,
      );
      if (response.statusCode == 200) {
        await getDashBoardCount();
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
          title: Text(getTranlateString("summon_warrant")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("beat_name"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 40,
                  child: InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .96,
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: spinnerItemsBeat.isNotEmpty
                          ? DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueBeat,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? data) {
                                dropdownValueBeat = data!;
                                if (dropdownValueBeat ==
                                    getTranlateString("select")) {
                                  spinnerItemsBeatCons = [];
                                  _rank = "";
                                } else {
                                  _getBeatConstableList();
                                }
                                setState(() {});
                              },
                              items: spinnerItemsBeat
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.split("#")[0],
                                      style:
                                          const TextStyle(color: Colors.black)),
                                );
                              }).toList(),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("beat_person_name"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 40,
                  child: InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .96,
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: spinnerItemsBeatCons.isNotEmpty
                          ? DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueBeatCons,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
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
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.split("#")[0],
                                      style:
                                          const TextStyle(color: Colors.black)),
                                );
                              }).toList(),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("rank"),
                      textAlign: TextAlign.left,
                    ),
                  ),
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
                          _rank,
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
                      getTranlateString("target_date"),
                      textAlign: TextAlign.left,
                    ),
                  ),
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
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: () => {_saveData()},
                    child: Container(
                      width: MediaQuery.of(context).size.width * .96,
                      height: 40,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: Color(ColorProvider.colorPrimary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(
                        AppTranslations.of(context)!.text("assign"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                _summon != null
                    ? Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * .96,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                getTranlateString("other_detail"),
                                textAlign: TextAlign.left,
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
                                getTranlateString("summon_warrant_notice_type"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _summon!.table3[0].sUMMONWARRANT ?? "",
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
                                getTranlateString("type_of_warrant"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _summon!.table3[0].wARRANTTYPE ?? "",
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
                                right: 5,
                                top: 8,
                                bottom: 8,
                                left: 5,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _summon!.table3[0].aCTSECTION ?? "",
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
                                getTranlateString("person_issued_against"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _summon!.table2[0].nAME ?? "",
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
                                getTranlateString("court_issue_date"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _summon!.table![0].fRDISPATCHDT ?? "",
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
                                getTranlateString(
                                    "date_of_recieving_at_police_station"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _summon!.table3[0].rECEIVPSDT ?? "",
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
                                getTranlateString("next_proceeding_date"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _summon!.table3[0].nEXTHEARINGDT ?? "",
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
                                getTranlateString("summon_warrant_notice_sent"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    getTranlateString(
                                        _summon!.table3[0].tOBEFWDNOT == "Y"
                                            ? "yes"
                                            : "No"),
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
                                getTranlateString("relative_name_relation"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        "${_summon!.table2[0].rELATIVENAME ?? ""} ${_summon!.table2[0].rELATIONTYPE != null && _summon!.table2[0].rELATIONTYPE != "" ? "( ${_summon!.table2[0].rELATIONTYPE} )" : ""}"),
                                  )
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "${_summon!.table1[0].aDDRESS} ${_summon!.table1[0].pOLICESTATION} ${_summon!.table1[0].dISTRICT} ${_summon!.table1[0].sTATE}",
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
                                getTranlateString("type_of_information"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _summon!.table3[0].nOTICETYPE ?? "",
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ));
  }
}
