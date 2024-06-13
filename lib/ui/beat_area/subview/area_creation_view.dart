import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/area_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/loaction_utils.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AreaCreation_fragment extends StatefulWidget {
  const AreaCreation_fragment({Key? key}) : super(key: key);

  @override
  State<AreaCreation_fragment> createState() => _AreaCreation_fragmentState();
}

class _AreaCreation_fragmentState extends BaseFullState<AreaCreation_fragment> {
  var con_Area = TextEditingController();
  List<AreaResponse> _lstArea = [];

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 400), () {
      _getAreaList();
    });
  }

  void _getAreaList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_AREA_MASTER, data, true);
    if (response.statusCode == 200) {
      _lstArea = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          _lstArea.add(AreaResponse.fromJson(i));
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

  void _addArea() async {
    var position = await LocationUtils().determinePosition();
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "AREA_NAME": con_Area.text,
      "DISTRICT_CD": userData.districtCD,
      "LAT": position.latitude.toString(),
      "LONG": position.latitude.toString(),
      "PS_CD": userData.psCd
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_ADD_AREA, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      MessageUtility.showToast(
          context, getTranlateString("area_successfully_added"));
      con_Area.text = "";
      _getAreaList();
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  _deleteArea(String srNo) async {
    var request = {"AREA_SR_NUM": srNo};
    var response = await HttpRequst.postRequestTokenWithBody(
        context, EndPoints.END_POINT_DELETE_AREA, request, true);
    if (response.statusCode == 200) {
      MessageUtility.showToast(
          context, getTranlateString("record_successfully_deleted"));
      _getAreaList();
    }
  }

  final formKey = GlobalKey<FormState>();
  void savePdf({required List<AreaResponse> finalData}) async {
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
                "Serial number",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                "Area",
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
                        child: pw.Text(finalData[index].aREASRNUM.toString(),
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(finalData[index].aREANAME.toString(),
                            style: bodyStyle),
                      ),
                    ],
                  ),
                );
              })
        ];
      },
    ));
    await CameraAndFileProvider.saveFile("Area", await pdf.save(), ".pdf");
    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTranlateString("Area_to_be_added"),
            ),
            4.height,
            EditTextBorder(
              controller: con_Area,
              validator: Validations.emptyValidator,
            ),
            12.height,
            Button(
              title: "submit",
              width: double.maxFinite,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  DialogHelper.showLoaderDialog(context);
                  _addArea();
                }
              },
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
                  Text(
                    getTranlateString("Existing_Areas"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            getTranlateString("serial_number"),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            getTranlateString("area"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              getTranlateString("delete"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _lstArea.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _lstArea.length,
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        physics: const RangeMaintainingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return getRowForConst(index);
                        }),
                  )
                : CustomView.getNoRecordView(context),
            InkWell(
              onTap: () {
                if (_lstArea.isNotEmpty) {
                  showDownloadOption(onPdfClick: () {
                    savePdf(finalData: _lstArea);
                  }, onXlsxClick: () {
                    AreaResponse.generateExcel(context, _lstArea);
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
      ),
    );
  }

  Widget getRowForConst(int index) {
    var data = _lstArea[index];
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 4),
      color: index % 2 == 0
          ? ColorProvider.redColor.withOpacity(0.05)
          : ColorProvider.blueColor.withOpacity(0.05),
      constraints: const BoxConstraints(minHeight: 40),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.aREASRNUM ?? "",
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              getTranlateString(data.aREANAME ?? ""),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  DialogHelper.showCallDialog(
                      context,
                      "${getTranlateString("delete")} : ${data.aREANAME!}",
                      getTranlateString("area_delete_sure"),
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
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
