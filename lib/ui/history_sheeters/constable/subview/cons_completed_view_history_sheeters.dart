import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/validated_history_sheeters_details_response.dart';
import 'package:beatapp/ui/history_sheeters/history_sheeters_detail_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ConsCompletedFragmentHistorySheeters extends StatefulWidget {
  const ConsCompletedFragmentHistorySheeters({Key? key}) : super(key: key);

  @override
  State<ConsCompletedFragmentHistorySheeters> createState() =>
      _ConsCompletedFragmentHistorySheetersState();
}

class _ConsCompletedFragmentHistorySheetersState
    extends BaseFullState<ConsCompletedFragmentHistorySheeters> {
  List<ValidatedHistorySheetersDetailsResponse> _lstData = [];
  final List<ValidatedHistorySheetersDetailsResponse> _lstDataAll = [];
  bool isActiveSelcted = true;

  @override
  void initState() {
    _getHSList();
    super.initState();
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  void _getHSList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_VALIDATED_HISTORY_SHEETERS_DETAILS, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = ValidatedHistorySheetersDetailsResponse.fromJson(i);
          _lstDataAll.add(data);
        }
        getSelectedList();
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  getSelectedList() {
    if (isActiveSelcted) {
      _lstData =
          ValidatedHistorySheetersDetailsResponse.getActiveList(_lstDataAll);
    } else {
      _lstData =
          ValidatedHistorySheetersDetailsResponse.getInActiveList(_lstDataAll);
    }
    setState(() {});
  }

  void savePdf(
      {required List<ValidatedHistorySheetersDetailsResponse>
          finalData}) async {
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
                "Village/Street",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "History Sheeter name",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "HSR no.",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Activity status",
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
                        child: pw.Text(finalData[index].vILLSTREETNAME ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].nAME ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].hSTSRNUM ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].iSACTIVE ?? '',
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
        "HistorySheeters", await pdf.save(), ".pdf");

    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("history_sheeters")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: _lstData.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                              child: CustomView.getCountView(
                                  context, _lstData.length),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                              child: InkWell(
                                onTap: () {
                                  isActiveSelcted = true;
                                  getSelectedList();
                                },
                                child: CustomView.getTextView(
                                    context, getTranlateString("active")),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                              child: InkWell(
                                onTap: () {
                                  isActiveSelcted = false;
                                  getSelectedList();
                                },
                                child: CustomView.getTextView(
                                    context, getTranlateString("inactive")),
                              ),
                            )
                          ],
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
                                      width: 628,
                                    ),
                                    Container(
                                      color: ColorProvider.blueColor,
                                      height: 5,
                                      width: 628,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                color: Colors.white,
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        "Beat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        getTranlateString("village_street"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        getTranlateString(
                                            "history_sheeter_name"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        getTranlateString("HSR No."),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        getTranlateString("activity_status"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(_lstData.length,
                              (index) => getRowForConst(index)),
                        ),
                      ]),
                )
              : CustomView.getNoRecordView(context)),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (_lstData.isNotEmpty) {
            showDownloadOption(
                onXlsxClick: () {},
                onPdfClick: () {
                  savePdf(finalData: _lstData);
                });
          }

          //ValidatedHistorySheetersDetailsResponse.generateExcel(context, _lstData);
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
    var data = _lstData[index];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistorySheetersDetailActivity(
                  data: {"HST_SR_NUM": data.hSTSRNUM}),
            ));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 4),
        color: index % 2 == 0
            ? ColorProvider.redColor.withOpacity(0.05)
            : ColorProvider.blueColor.withOpacity(0.05),
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(data.BEAT_NAME ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 130,
              child: Text(
                data.vILLSTREETNAME ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 130,
              child: Text(data.nAME ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 130,
              child: Text(data.hSTSRNUM ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 130,
              child: Text(data.iSACTIVE ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
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
