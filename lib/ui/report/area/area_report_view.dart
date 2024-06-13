import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/entities/police_station.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/area_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class AreaReportActivity extends StatefulWidget {
  const AreaReportActivity({Key? key}) : super(key: key);

  @override
  State<AreaReportActivity> createState() => _AreaReportActivityState();
}

class _AreaReportActivityState extends State<AreaReportActivity> {
  late List<AreaResponse> lstHS = [];
  var districtName = "";
  var psName = "";
  String districtId = "";
  var psId = "";
  String role = "";
  List<PoliceStation> psList = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () async {
      _getHSList();
      role = AppUser.ROLE_CD;
      if (role == "16" || role == "17") {
        getPSList();
      }
    });
  }

  void getPSList() async {
    var userData = await LoginResponseModel.fromPreference();
    psName = getTranlateString("all");
    psId = "";
    psList = await PoliceStation.searchPS(userData.districtCD!);
    psList.insert(0, PoliceStation(psId, psName));
    setState(() {});
  }

  void _getHSList() async {
    var userData = await LoginResponseModel.fromPreference();
    districtName = userData.district ?? "";
    if (role != "16" && role != "17") {
      psId = userData.psCd ?? "";
      psName = userData.ps ?? "";
    }
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": psId};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_REPORT_AREA_DETAILS, data, true);
    if (response.statusCode == 200) {
      try {
        lstHS = [];
        for (Map<String, dynamic> i in response.data) {
          var data = AreaResponse.fromJson(i);
          lstHS.add(data);
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

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(getTranlateString("area")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                  margin: const EdgeInsets.only(left: 12, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: Colors.black, width: .5)),
                  child: Text(districtName),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                    margin: const EdgeInsets.only(left: 12, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(color: Colors.black, width: .5)),
                    child: InkWell(
                      onTap: () {
                        if (role == "16" || role == "17") {
                          showPSListDialog();
                        }
                      },
                      child: Row(children: [
                        if (role == "16" || role == "17")
                          const Icon(
                            Icons.filter_alt,
                            size: 18,
                          ),
                        Text(psName),
                      ]),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                  child: CustomView.getCountViewWithOutShadow(
                      context, lstHS.length),
                )
              ],
            ),
            lstHS.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: lstHS.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getRowForConst(index);
                        }))
                : CustomView.getNoRecordView(context),
            InkWell(
              onTap: () {
                AreaResponse.generateExcel(context, lstHS);
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
          ],
        ),
      ),
    );
  }

  Widget getRowForConst(int index) {
    var data = lstHS[index];
    return InkWell(
        onTap: () {
          setState(() {});
        },
        child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("${index + 1}. ${data.aREANAME ?? ""}"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  void getFilteredData() {
    _getHSList();
    setState(() {});
  }

  showPSListDialog() async {
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: 300,
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(getTranlateString("police_station")),
            ),
            CustomView.getHorizontalDevider(context),
            psList.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: psList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getRowForPS(index);
                      },
                    ),
                  )
                : CustomView.getNoRecordView(context),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getRowForPS(int index) {
    var data = psList[index];
    return InkWell(
        onTap: () {
          psId = data.psCD ?? "";
          psName = data.ps ?? "";
          Navigator.pop(context);
          getFilteredData();
        },
        child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      1.0,
                      1.0,
                    ),
                    blurRadius: 2.0,
                    spreadRadius: 1.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Text(data.ps ?? ""),
            )));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
