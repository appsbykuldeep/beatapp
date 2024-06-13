import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/entities/police_station.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/arms_weapon_report_details_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/weapon_verification/sho/main/arms_weapon_detail_view.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ArmsAndWeaponReportActivity extends StatefulWidget {
  const ArmsAndWeaponReportActivity({Key? key}) : super(key: key);

  @override
  State<ArmsAndWeaponReportActivity> createState() =>
      _ArmsAndWeaponReportActivityState();
}

class _ArmsAndWeaponReportActivityState
    extends BaseFullState<ArmsAndWeaponReportActivity> {
  late List<ArmsWeaponReportDetailsResponse> lstHS = [];
  late List<ArmsWeaponReportDetailsResponse> lstHSAll = [];
  var districtName = "";
  String districtId = "";
  var psName = "";
  var psId = "";
  String role = "";
  List<PoliceStation> psList = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () async {
      _getWeaponList();
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

  void _getWeaponList() async {
    var userData = await LoginResponseModel.fromPreference();
    districtName = userData.district ?? "";
    psName = userData.ps ?? "";
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_REPORT_ARMS_WEAPON_DETAILS, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = ArmsWeaponReportDetailsResponse.fromJson(i);
          lstHS.add(data);
          lstHSAll.add(data);
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

  void savePdf(
      {required List<ArmsWeaponReportDetailsResponse> finalData}) async {
    final pdf = pw.Document();
    pw.TextStyle headingStyle = pw.TextStyle(
        color: PdfColor.fromHex("#ffffff"),
        fontWeight: pw.FontWeight.bold,
        fontSize: 12);
    pw.TextStyle bodyStyle = const pw.TextStyle(fontSize: 10);

    pw.Container heading;

    heading = pw.Container(
      color: PdfColor.fromHex("#f60000"),
      constraints: const pw.BoxConstraints(
        minHeight: 50,
      ),
      child: pw.Container(
        constraints: const pw.BoxConstraints(minHeight: 40),
        padding: const pw.EdgeInsets.only(left: 4, right: 4),
        color: PdfColor.fromHex("#f60000"),
        child: pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                "Beat",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Police station",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Village/Street",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "License holder",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Father name",
                style: headingStyle,
              ),
            ),
          ],
        ),
      ),
    );

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return [
          heading,
          pw.ListView.builder(
              itemCount: finalData.length,
              itemBuilder: (context, index) {
                return pw.Container(
                  constraints: const pw.BoxConstraints(minHeight: 40),
                  padding: const pw.EdgeInsets.only(left: 4, right: 4),
                  color: index % 2 == 0
                      ? PdfColor.fromHex("#f3f3fc")
                      : PdfColor.fromHex("#fdf5f5"),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(finalData[index].BEAT_NAME ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].PS ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].VILL_STREET ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(
                            finalData[index].LISCENSE_HOLDER_NAME ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].FATHER_NAME ?? '',
                            style: bodyStyle),
                      ),
                    ],
                  ),
                );
              })
        ];
      },
    ));
    await CameraAndFileProvider.saveFile(
        "ArmsAndWeapon", await pdf.save(), ".pdf");

    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(getTranlateString("arms_weapon")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Column(
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
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
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
                child:
                    CustomView.getCountViewWithOutShadow(context, lstHS.length),
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
              if (lstHS.isNotEmpty) {
                showDownloadOption(onXlsxClick: () {
                  ArmsWeaponReportDetailsResponse.generateExcel(context, lstHS);
                }, onPdfClick: () {
                  savePdf(finalData: lstHS);
                });
              }
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
    );
  }

  Widget getRowForConst(int index) {
    var data = lstHS[index];
    return InkWell(
        onTap: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArmsWeaponDetailActivity(
                    data: {"WEAPON_SR_NUM": data.ARM_SR_NUM}),
              ));
          if (result) {
            _getWeaponList();
          }
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
                          child: Text(getTranlateString("police_station"),
                              style: getHeaderStyle()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.PS ?? ""),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(getTranlateString("village_street"),
                              style: getHeaderStyle()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.VILL_STREET ?? ""),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(getTranlateString("beat_name"),
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
                              AppTranslations.of(context)!
                                  .text("license_holder_name"),
                              style: getHeaderStyle()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.LISCENSE_HOLDER_NAME ?? ""),
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
                            getTranlateString("father_name"),
                            style: getHeaderStyle(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(data.FATHER_NAME ?? ""),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  void getFilteredData() {
    if (psId != "") {
      lstHS = ArmsWeaponReportDetailsResponse.getAWListPS(psName, lstHSAll);
    } else {
      lstHS = lstHSAll;
    }
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
