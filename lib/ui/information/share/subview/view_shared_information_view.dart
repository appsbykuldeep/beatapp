import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/shared_information.dart';
import 'package:beatapp/ui/information/share/shared_information_detail_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ViewSharedInformationFragment extends StatefulWidget {
  final data;

  const ViewSharedInformationFragment({Key? key, required this.data})
      : super(key: key);

  @override
  State<ViewSharedInformationFragment> createState() =>
      _ViewSharedInformationFragmentState(data);
}

class _ViewSharedInformationFragmentState
    extends BaseFullState<ViewSharedInformationFragment> {
  late final List<SharedInformation> _lstInformation = [];
  var con_Comment = TextEditingController();

  String role = "0";

  _ViewSharedInformationFragmentState(data) {
    role = data["role"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getInformationList();
    super.initState();
  }

  void _getInformationList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    late Response response;
    if (role == "23") {
      response = await HttpRequst.postRequestWithTokenAndBody(
          context, EndPoints.END_POINT_GET_SHARED_INFO_LIST_HC, data, true);
    } else {
      response = await HttpRequst.postRequestWithTokenAndBody(
          context, EndPoints.END_POINT_GET_SHARED_INFO_LIST_SHO, data, true);
    }
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = SharedInformation.fromJson(i);
          _lstInformation.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  void savePdf({required List<SharedInformation> finalData}) async {
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
                "Date time",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Person name",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Rank",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Info. type",
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
                        child: pw.Text(finalData[index].beatName,
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].dateTime ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].personName ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].officerRank ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].infoIncidentType ?? '',
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
        "SharedInformation", await pdf.save(), ".pdf");

    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
            child: CustomView.getCountView(context, _lstInformation.length),
          ),
          _lstInformation.isNotEmpty
              ? Expanded(
                  flex: 1,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _lstInformation.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getRowForConst(index);
                      }),
                )
              : CustomView.getNoRecordView(context),
          InkWell(
            onTap: () {
              if (_lstInformation.isNotEmpty) {
                showDownloadOption(onXlsxClick: () {
                  SharedInformation.generateExcel(context, _lstInformation);
                }, onPdfClick: () {
                  savePdf(finalData: _lstInformation);
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
        ]));
  }

  Widget getRowForConst(int index) {
    var data = _lstInformation[index];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SharedInformationDetailActivity(info: data),
            ));
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
                        AppTranslations.of(context)!.text("date_and_time"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.dateTime!),
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
                    child: Text(
                        AppTranslations.of(context)!.text("name_of_person"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.personName!),
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
                    child: Text(AppTranslations.of(context)!.text("rank"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.officerRank!),
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
                    child: Text(
                        AppTranslations.of(context)!
                            .text("type_of_information"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.infoIncidentType!),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
