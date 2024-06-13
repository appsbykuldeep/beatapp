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

class BeatViewActivity extends StatefulWidget {
  const BeatViewActivity({Key? key}) : super(key: key);

  @override
  State<BeatViewActivity> createState() => _BeatViewActivityState();
}

class _BeatViewActivityState extends BaseFullState<BeatViewActivity> {
  late List<VillageBeatDetailsResponse> beat_list = [];

  @override
  void initState() {
    super.initState();
    _getBeatList();
  }

  void _getBeatList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.BEAT_VIEW_LIST, data, true);
    if (response.statusCode == 200) {
      beat_list = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = VillageBeatDetailsResponse.fromJson(i);
          beat_list.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    }
  }

  _deleteBeat(String srNo) async {
    var request = {"BEAT_CD": srNo};
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.BEAT_DELETE, request, true);
    if (response.statusCode == 200) {
      MessageUtility.showToast(
          context, getTranlateString("record_successfully_deleted"));
      _getBeatList();
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
                "Beat name",
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
                            finalData[index].BEAT_NAME_ENGLISH.toString(),
                            style: bodyStyle),
                      ),
                    ],
                  ),
                );
              })
        ];
      },
    ));
    await CameraAndFileProvider.saveFile("Beat", await pdf.save(), ".pdf");
    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("beat")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
            child: CustomView.getCountView(context, beat_list.length),
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
                          child: Text(getTranlateString("beat_name_english"),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          getTranlateString("beat_name_hindi"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
          beat_list.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(2),
                      itemCount: beat_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getRowForConst(index);
                      }))
              : CustomView.getNoRecordView(context),
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (beat_list.isNotEmpty) {
            showDownloadOption(onPdfClick: () {
              savePdf(finalData: beat_list);
            }, onXlsxClick: () {
              VillageBeatDetailsResponse.generateExcelBeat(context, beat_list);
            });
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
    var data = beat_list[index];
    return InkWell(
        onTap: () {},
        child: Container(
            padding: const EdgeInsets.only(left: 4, right: 4),
            color: index % 2 == 0
                ? ColorProvider.redColor.withOpacity(0.05)
                : ColorProvider.blueColor.withOpacity(0.05),
            constraints: const BoxConstraints(minHeight: 40),
            child: Container(
                child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      data.BEAT_NAME_ENGLISH ?? "",
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    data.BEAT_NAME_HINDI ?? "",
                  ),
                ),
                InkWell(
                  onTap: () {
                    DialogHelper.showCallDialog(
                        context,
                        getTranlateString("delete"),
                        getTranlateString("beat_delete_sure"),
                        () => {_deleteBeat(data.BEAT_CD!)});
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 24,
                  ),
                )
              ],
            ))));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
