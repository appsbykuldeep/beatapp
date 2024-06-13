import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/constable_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/master/constable/constable_delete_view.dart';
import 'package:beatapp/ui/master/constable/constable_edit_view.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ConstableViewActivity extends StatefulWidget {
  const ConstableViewActivity({Key? key}) : super(key: key);

  @override
  State<ConstableViewActivity> createState() => _ConstableViewActivityState();
}

class _ConstableViewActivityState extends BaseFullState<ConstableViewActivity> {
  late List<ConstableResponse> constable_list = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 400), () {
      _getConstableList();
    });
  }

  void _getConstableList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_CONSTABLE_LIST, data, true);
    if (response.statusCode == 200) {
      constable_list = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var office = ConstableResponse.fromJson(i);
          constable_list.add(office);
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

  void savePdf({required List<ConstableResponse> finalData}) async {
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
              flex: 1,
              child: pw.Text(
                "Name",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                "Mobile",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                "P.N.O",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                "Rank",
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
                        flex: 1,
                        child: pw.Text(
                            finalData[index].BEAT_CONSTABLE_NAME.toString(),
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(finalData[index].MOBILE.toString(),
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(finalData[index].PNO ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(finalData[index].OFFICER_RANK ?? '',
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
        "BeatConstable", await pdf.save(), ".pdf");
    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("beat_constable")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
            child: CustomView.getCountView(context, constable_list.length),
          ),
          SizedBox(
            height: 50,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: ColorProvider.redColor,
                        height: 5,
                        width: double.maxFinite,
                      ),
                      Container(
                        color: ColorProvider.blueColor,
                        height: 5,
                        width: double.maxFinite,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(getTranlateString("name")),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Mobile",
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(getTranlateString("pno")),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(getTranlateString("rank")),
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          constable_list.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(2),
                      itemCount: constable_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getRowForConst(index);
                      }))
              : CustomView.getNoRecordView(context),
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (constable_list.isNotEmpty) {
            showDownloadOption(
              onPdfClick: () {
                savePdf(finalData: constable_list);
              },
              onXlsxClick: () {
                ConstableResponse.generateExcel(context, constable_list);
              },
            );
          }
        },
        child: Container(
          height: 50,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_download_outlined),
              Text(getTranlateString("download").toUpperCase())
            ],
          ),
        ),
      ),
    );
  }

  Widget getRowForConst(int index) {
    var constabledata = constable_list[index];
    return InkWell(
        onTap: () {},
        child: Container(
            padding: const EdgeInsets.only(left: 4, right: 4),
            color: index % 2 == 0
                ? ColorProvider.redColor.withOpacity(0.05)
                : ColorProvider.blueColor.withOpacity(0.05),
            constraints: const BoxConstraints(minHeight: 40),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        constabledata.BEAT_CONSTABLE_NAME ?? "",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      constabledata.MOBILE ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        constabledata.PNO ?? "",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        constabledata.OFFICER_RANK ?? "",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConstableEditActivity(
                              data: constabledata,
                            ),
                          ));
                      if (shouldRefresh) {
                        shouldRefresh = false;
                        _getConstableList();
                      }
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      bool? res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ConstableDeleteActivity(data: constabledata),
                          ));
                      if (res != null && res) {
                        _getConstableList();
                      }
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 25,
                    ),
                  )
                ],
              ),
            )));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
