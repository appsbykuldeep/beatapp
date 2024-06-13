import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/beat.dart';
import 'package:beatapp/model/response/area_response.dart';
import 'package:beatapp/model/response/beat_area_list_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/material.dart';

class AreaAllotment_fragment extends StatefulWidget {
  const AreaAllotment_fragment({Key? key}) : super(key: key);

  @override
  State<AreaAllotment_fragment> createState() => _AreaAllotment_fragmentState();
}

class _AreaAllotment_fragmentState extends State<AreaAllotment_fragment> {
  late List<BeatAreaListResponse> lstAreaBeat = [];

  String dropdownValueBeat = "Select";
  List<String> spinnerItemsBeat = ["Select"];
  String dropdownValueArea = "Select";

  List<String> spinnerItemsArea = ["Select"];

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getBeatList();
      _getAreaList();
      _getBeatAreaList();
    });
  }

  String getSelectedAreaId() {
    return dropdownValueArea.split("#")[1];
  }

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
  }

  void _getBeatList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_MASTER, data, true);
    if (response.statusCode == 200) {
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

  void _getBeatAreaList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_AREA_LIST, data, true);
    if (response.statusCode == 200) {
      lstAreaBeat = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = BeatAreaListResponse.fromJson(i);
          lstAreaBeat.add(data);
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

  void _getAreaList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_AREA_MASTER, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = AreaResponse.fromJson(i);
          spinnerItemsArea.add("${data.aREANAME!}#${data.aREASRNUM!}");
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

  void _addAreaBeat() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "AREA_SR_NUM": getSelectedAreaId(),
      "BEAT_CD": getSelectedBeatId(),
      "DISTRICT_CD": userData.districtCD,
      "PS_CD": userData.psCd
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_ADD_BEAT_AREA, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      if (response.data.toString() != "-1") {
        MessageUtility.showToast(
            context, getTranlateString("area_successfully_added"));
        dropdownValueBeat = getTranlateString("select");
        dropdownValueArea = getTranlateString("select");
        _getBeatAreaList();
      } else {
        MessageUtility.showToast(context,
            AppTranslations.of(context)!.text("area_already_available"));
      }
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  _deleteArea(String srNo) async {
    var request = {"AREA_SR_NUM": srNo};
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.END_POINT_REMOVE_BEAT_AREA, request, true);
    if (response.statusCode == 200) {
      MessageUtility.showToast(
          context, getTranlateString("record_successfully_deleted"));
      _getBeatAreaList();
    }
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
                contentPadding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),
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
          12.height,
          Text(
            getTranlateString("area"),
            textAlign: TextAlign.left,
          ),
          4.height,
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: dropdownValueArea,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
            onChanged: (String? data) {
              setState(() {
                dropdownValueArea = data!;
              });
            },
            items:
                spinnerItemsArea.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.split("#")[0],
                    style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
          12.height,
          Button(
            title: "submit",
            width: double.maxFinite,
            onPressed: (dropdownValueBeat == getTranlateString("select") ||
                    dropdownValueArea == getTranlateString("select"))
                ? null
                : () {
                    DialogHelper.showLoaderDialog(context);
                    _addAreaBeat();
                  },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(top: 5),
                child: lstAreaBeat.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: lstAreaBeat.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getRowForConst(index);
                        })
                    : Container(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getRowForConst(int index) {
    var data = lstAreaBeat[index];
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
                          child: Text(AppTranslations.of(context)!.text("beat"),
                              style: getHeaderStyle()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.bEATNAME ?? ""),
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
                          child: Text(AppTranslations.of(context)!.text("area"),
                              style: getHeaderStyle()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.aREANAME ?? ""),
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
                            AppTranslations.of(context)!.text("date"),
                            style: getHeaderStyle(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.cREATEDDATE ?? ""),
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
                    DialogHelper.showCallDialog(
                        context,
                        "${getTranlateString("delete")} : ${data.aREANAME!}",
                        getTranlateString("beat_delete_sure"),
                        () => {_deleteArea(data.aREASRNUM!)});
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
