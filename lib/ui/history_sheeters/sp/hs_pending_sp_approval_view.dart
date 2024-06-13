import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/entities/police_station.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/history_sheeters_details_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/history_sheeters/sp/hs_pending_edit_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class HSPendingSPApprovalActivity extends StatefulWidget {
  const HSPendingSPApprovalActivity({Key? key}) : super(key: key);

  @override
  State<HSPendingSPApprovalActivity> createState() =>
      _HSPendingSPApprovalActivityState();
}

class _HSPendingSPApprovalActivityState
    extends State<HSPendingSPApprovalActivity> {
  List<HistorySheetersDetailsResponse> _lstData = [];
  String district = "";

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 150), () {
      getPSList();
    });
  }

  late String dropdownValuePS;
  List<String> spinnerItemsPS = [];

  void getPSList() async {
    var userData = await LoginResponseModel.fromPreference();
    district = userData.district ?? "";
    var lst = await PoliceStation.searchPS(userData.districtCD);
    dropdownValuePS = getTranlateString("select");
    spinnerItemsPS = [dropdownValuePS];
    if (lst.isNotEmpty) {
      for (int i = 0; i < lst.length; i++) {
        spinnerItemsPS.add("${lst[i].ps!}#${lst[i].psCD!}");
      }
    }
    setState(() {});
  }

  String getSelectedPSId() {
    return dropdownValuePS.split("#")[1].toString();
  }

  void _getHSList() async {
    if (dropdownValuePS.contains(getTranlateString("select"))) {
      return;
    }
    var data = {"PS_CD": getSelectedPSId()};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_HST_SP_LIST, data, true);
    if (response.statusCode == 200) {
      _lstData = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = HistorySheetersDetailsResponse.fromJson(i);
          _lstData.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(getTranlateString("history_sheeters")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            child: Column(children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                    child: CustomView.getTextView(context, district),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                    child: CustomView.getCountView(context, _lstData.length),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, top: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  getTranlateString("police_station"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 45,
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .98,
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: spinnerItemsPS.isNotEmpty
                        ? DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValuePS,
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
                              setState(() {
                                dropdownValuePS = data!;
                                _getHSList();
                              });
                            },
                            items: spinnerItemsPS
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.split("#")[0],
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * .98,
                decoration: BoxDecoration(
                    color: Color(ColorProvider.indigo_100),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              getTranlateString("village_street"),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                                getTranlateString("history_sheeter_name"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(getTranlateString("activity_status"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(getTranlateString("routine_status"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _lstData.isNotEmpty
                  ? Expanded(
                      flex: 1,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _lstData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return getRowForConst(index);
                          }),
                    )
                  : CustomView.getNoRecordView(context),
              InkWell(
                onTap: () {
                  //ValidatedHistorySheetersDetailsResponse.generateExcel(context, _lstData);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.file_download_outlined),
                      Text(getTranlateString("download").toUpperCase())
                    ],
                  ),
                ),
              )
            ])));
  }

  Widget getRowForConst(int index) {
    var data = _lstData[index];
    return InkWell(
      onTap: () async {
        bool res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HSPendingEditActivity(data: {"HST_SR_NUM": data.hSTSRNUM}),
            ));
        if (res) {
          _getHSList();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5, right: 1),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * .98,
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
              flex: 2,
              child: Text(
                data.VILL_STREET ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(data.nAME ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(data.iSACTIVE ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    data.ROUTINE_VERIFICATION_STATUS == "VERIFIED"
                        ? Icons.verified
                        : Icons.unpublished_rounded,
                    color: data.PENDING_TYPE == "D" ? Colors.green : Colors.red,
                    size: 24,
                  )),
            ),
            SizedBox(
              width: 24,
              child: InkWell(
                onTap: () {},
                child: Icon(
                  data.PENDING_TYPE == "D" ? Icons.delete : Icons.open_in_new,
                  color: data.PENDING_TYPE == "D" ? Colors.red : Colors.green,
                  size: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
