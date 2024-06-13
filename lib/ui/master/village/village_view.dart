import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/village_beat_details_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class VillageViewActivity extends StatefulWidget {
  const VillageViewActivity({Key? key}) : super(key: key);

  @override
  State<VillageViewActivity> createState() => _VillageViewActivityState();
}

class _VillageViewActivityState extends BaseFullState<VillageViewActivity> {
  late List<VillageBeatDetailsResponse> villageStreet_list = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 400), () {
      _getVillageList();
    });
  }

  void _getVillageList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_Village_DETAILS, data, true);
    if (response.statusCode == 200) {
      villageStreet_list = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var office = VillageBeatDetailsResponse.fromJson(i);
          villageStreet_list.add(office);
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

  _deleteVillage(String srNo) async {
    var request = {"VILL_STR_SR_NUM": srNo};
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.END_POINT_POST_VILLAGE_DELETE, request, true);
    if (response.statusCode == 200) {
      MessageUtility.showToast(
          context, getTranlateString("record_successfully_deleted"));
      _getVillageList();
    }
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  void savePdf({required List<VillageBeatDetailsResponse> finalData}) async {
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
                "Village/Street name",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                "Village/Street",
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
                        child: pw.Text(finalData[index].ENGLISH_NAME.toString(),
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                            finalData[index].IS_VILLAGE == "Y"
                                ? getTranlateString("village")
                                : getTranlateString("street").toString(),
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
        "VillageStreet", await pdf.save(), ".pdf");
    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("village_street")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
            child: CustomView.getCountView(context, villageStreet_list.length),
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
                        child: Text(getTranlateString("village_street_english"),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          getTranlateString("village_street_hindi"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(getTranlateString("village_street"),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
          villageStreet_list.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(1),
                      itemCount: villageStreet_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getRowForConst(index);
                      }))
              : CustomView.getNoRecordView(context),
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (villageStreet_list.isNotEmpty) {
            showDownloadOption(
              onXlsxClick: () {
                VillageBeatDetailsResponse.generateExcelVillage(
                    context, villageStreet_list);
              },
              onPdfClick: () {
                savePdf(finalData: villageStreet_list);
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
    var data = villageStreet_list[index];
    return InkWell(
        child: Container(
      padding: const EdgeInsets.only(left: 4, right: 4),
      color: index % 2 == 0
          ? ColorProvider.redColor.withOpacity(0.05)
          : ColorProvider.blueColor.withOpacity(0.05),
      constraints: const BoxConstraints(minHeight: 40),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                data.ENGLISH_NAME ?? "",
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.REGIONAL_NAME ?? "",
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                data.IS_VILLAGE == "Y"
                    ? getTranlateString("village")
                    : getTranlateString("street"),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              DialogHelper.showCallDialog(
                  context,
                  "${getTranlateString("delete")} : ${data.ENGLISH_NAME!}",
                  getTranlateString("beat_delete_sure"), () {
                _deleteVillage(data.VILL_STR_SR_NUM!);
              });
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 24,
            ),
          )
        ],
      ),
    ));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
