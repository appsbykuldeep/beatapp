// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/beat.dart';
import 'package:beatapp/model/beat_person_detail.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/model/response/get_constable_details.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/material.dart';

class BeatAllotmentFragment extends StatefulWidget {
  const BeatAllotmentFragment({Key? key}) : super(key: key);

  @override
  State<BeatAllotmentFragment> createState() => _BeatAllotmentFragmentState();
}

class _BeatAllotmentFragmentState extends BaseFullState<BeatAllotmentFragment> {
  var _rank = "";
  List<BeatPersonDetail> lstBetaAllcation = [];

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  String dropdownValueBeat = "Select";
  List<String> spinnerItemsBeat = ["Select"];

  String dropdownValueBeatCons = "Select";
  List<String> spinnerItemsBeatCons = ["Select"];

  String dropdownValueRank = "Select";
  List<String> spinnerItemsRank = ["Select"];

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
  }

  String getSelectedRankId() {
    if (dropdownValueRank != getTranlateString("select")) {
      return dropdownValueRank.split("#")[1];
    } else {
      return "0";
    }
  }

  String getSelectedBeatConsCUG() {
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

  //jsonEncode(opAttrList, toEncodable: (e) => e.toJsonAttr());

  _checkBeatStatus() async {
    var userData = await LoginResponseModel.fromPreference();
    var request = {
      "BEAT_CD": getSelectedBeatId(),
      "BEAT_CUG": getSelectedBeatConsCUG(),
      "PS_CD": userData.psCd
    };
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.CHECK_BEAT_STATUS, request, false);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      if (response.data.toString() == "0") {
        checkAndAddDataInList();
      } else {
        MessageUtility.showToast(
            context, getTranlateString("beat_constable_already_assigned"));
      }
    }
  }

  checkAndAddDataInList() {
    lstBetaAllcation.add(BeatPersonDetail(
        (lstBetaAllcation.length + 1).toString(),
        getSelectedBeatConsCUG(),
        _rank,
        dropdownValueBeatCons.split("#")[0]));
    setState(() {});
  }

  _addData() async {
    List<Map<String, dynamic>> dataBeat = [];
    for (int i = 0; i < lstBetaAllcation.length; i++) {
      dataBeat.add(lstBetaAllcation[i].toJson());
    }
    var userData = await LoginResponseModel.fromPreference();
    var request = {
      "BEAT_CD": getSelectedBeatId(),
      "BEAT_PERSON_DETAIL": dataBeat,
      "PS_CD": userData.psCd
    };
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.BEAT_ASSIGNMENT, request, false);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      if (response.data.toString() == "1") {
        lstBetaAllcation = [];
        dropdownValueBeat = getTranlateString("select");
        dropdownValueBeatCons = getTranlateString("select");
        _rank = "";
        getDashBoardCount();
        MessageUtility.showToast(context, getTranlateString("success_msg"));
        setState(() {});
      } else {
        MessageUtility.showToast(
            context, getTranlateString("beat_constable_already_assigned"));
      }
    }
  }

  List<GetConstableDetails> lstCons = [];

  void _getBeatConstableList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_CONSTABLE_LIST, data, true);
    if (response.statusCode == 200) {
      dropdownValueBeatCons = getTranlateString("select");
      spinnerItemsBeatCons = [dropdownValueBeatCons];
      lstCons = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = GetConstableDetails.fromJson(i);
          lstCons.add(data);
          spinnerItemsBeatCons
              .add("${data.NAME!}#${data.OFFICER_RANK!}#${data.CUG!}#");
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

  filterDataAccrodingToSelectedRank() {
    dropdownValueBeatCons = getTranlateString("select");
    spinnerItemsBeatCons = [dropdownValueBeatCons];
    if (_rank != "") {
      for (int i = 0; i < lstCons.length; i++) {
        if (ConstableResponse.checkHardCodedRank(
            _rank, lstCons[i].OFFICER_RANK!)) {
          spinnerItemsBeatCons.add(
              "${lstCons[i].NAME!}#${lstCons[i].OFFICER_RANK!}#${lstCons[i].CUG!}#");
        }
      }
    } else {
      for (int i = 0; i < lstCons.length; i++) {
        spinnerItemsBeatCons.add(
            "${lstCons[i].NAME!}#${lstCons[i].OFFICER_RANK!}#${lstCons[i].CUG!}#");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getBeatList();
      _getBeatConstableList();
      _getRankList();
    });
  }

  void _getRankList() async {
    var response = await HttpRequst.postRequestWithToken(
        context, EndPoints.GET_RANK_MASTER, true);
    if (response.statusCode == 200) {
      try {
        dropdownValueRank = getTranlateString("select");
        spinnerItemsRank = [dropdownValueRank];
        for (Map<String, dynamic> i in response.data) {
          var rank = ConstableResponse.fromRankJson(i);
          spinnerItemsRank
              .add("${rank.OFFICER_RANK!}#${rank.OFFICER_RANK_CD!}");
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
    /*var _rankList = ConstableResponse.getAllRanks(context);
    dropdownValueRank = getTranlateString("select");
    spinnerItemsRank = [dropdownValueRank];
    for (ConstableResponse rank in _rankList) {
      spinnerItemsRank.add(rank.OFFICER_RANK! + "#" + rank.OFFICER_RANK_CD!);
    }*/
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
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
                contentPadding: const EdgeInsets.only(left: 8, right: 8),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
            onChanged: (String? data) {
              setState(() {
                dropdownValueBeat = data!;
              });
            },
            items:
                spinnerItemsBeat.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.split("#")[0],
                    style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
          10.height,
          Text(
            getTranlateString("Rank"),
          ),
          4.height,
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: dropdownValueRank,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8, right: 8),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
            onChanged: (String? data) {
              dropdownValueRank = data!;
              if (dropdownValueRank != getTranlateString("select")) {
                _rank = data.split("#")[1];
              } else {
                _rank = "";
              }
              filterDataAccrodingToSelectedRank();
              setState(() {});
            },
            items:
                spinnerItemsRank.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.split("#")[0],
                    style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
          10.height,
          Text(
            getTranlateString("beat_constable"),
          ),
          4.height,
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: dropdownValueBeatCons,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8, right: 8),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
            onChanged: (String? data) {
              dropdownValueBeatCons = data!;
              _rank = dropdownValueBeatCons != getTranlateString("select")
                  ? data.split("#")[1]
                  : "";
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
          Align(
            alignment: Alignment.topRight,
            child: Button(
              title: "Add",
              onPressed: (dropdownValueBeat == getTranlateString("select") ||
                      dropdownValueBeatCons == getTranlateString("select"))
                  ? null
                  : () {
                      DialogHelper.showLoaderDialog(context);
                      _checkBeatStatus();
                    },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                  width: MediaQuery.of(context).size.width * .90,
                  margin: const EdgeInsets.only(top: 5),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const RangeMaintainingScrollPhysics(),
                          itemCount: lstBetaAllcation.length,
                          itemBuilder: (BuildContext context, int index) {
                            return getRowForConst(index);
                          }),
                      Button(
                        title: "Save",
                        width: double.maxFinite,
                        onPressed: lstBetaAllcation.isEmpty
                            ? null
                            : () {
                                DialogHelper.showLoaderDialog(context);
                                _addData();
                              },
                      ),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget getRowForConst(int index) {
    var data = lstBetaAllcation[index];
    return Container(
        margin: const EdgeInsets.only(top: 5, right: 1),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * .90,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Color(0x10000000),
                offset: Offset(
                  2.0,
                  2.0,
                ),
                blurRadius: 2.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              //BoxShadow
            ]),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("beat_name"),
                              style: getHeaderStyle()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(dropdownValueBeat.split("#")[0]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!
                                  .text("beat_constable"),
                              style: getHeaderStyle()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.BEAT_NAME ?? ""),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            AppTranslations.of(context)!.text("pno"),
                            style: getHeaderStyle(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.BEAT_CUG ?? ""),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              width: .5,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    lstBetaAllcation.removeAt(index);
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
