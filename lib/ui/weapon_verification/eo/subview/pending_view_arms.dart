import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/license_weapon_list_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/weapon_verification/sho/main/arms_weapon_detail_view.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PendingFragmentArms extends StatefulWidget {
  const PendingFragmentArms({Key? key}) : super(key: key);

  @override
  State<PendingFragmentArms> createState() => _PendingFragmentArmsState();
}

class _PendingFragmentArmsState extends BaseFullState<PendingFragmentArms> {
  final List<LicenseWeaponListResponse> _lstData = [];

  @override
  void initState() {
    _getWeaponVerificationList();
    super.initState();
  }

  void _getWeaponVerificationList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_LSCD_WPN_LIST, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = LicenseWeaponListResponse.fromJson(i);
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

  void savePdf({required List<LicenseWeaponListResponse> finalData}) async {
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
                "License holder name",
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
                        child: pw.Text(finalData[index].bEATNAME,
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].vILLSTREETNAME ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(
                            finalData[index].lISCENSEHOLDERNAME ?? '',
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
        "ArmsAndWeaponVerification", await pdf.save(), ".pdf");

    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("arms_weapon_verification")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Column(children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
              child: CustomView.getCountView(context, _lstData.length),
            ),
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
                        child: Text(getTranlateString("beat"),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        getTranlateString("village_street"),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(getTranlateString("license_holder_name"),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
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
      ]),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (_lstData.isNotEmpty) {
            showDownloadOption(
                onPdfClick: () {
                  savePdf(finalData: _lstData);
                },
                onXlsxClick: () {});
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
    var data = _lstData[index];
    return InkWell(
      onTap: () async {
        bool result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArmsWeaponDetailActivity(
                  data: {"WEAPON_SR_NUM": data.wEAPONSRNUM}),
            ));
        if (result) {
          _getWeaponVerificationList();
        }
      },
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
              child: Text(
                data.bEATNAME,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                data.vILLSTREETNAME ?? "",
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                data.lISCENSEHOLDERNAME ?? "",
              ),
            ),
          ],
        ), /*Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          AppTranslations.of(context)!
                              .text("village_street"),
                          style: getHeaderStyle()),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(data.vILLSTREETNAME ?? ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          AppTranslations.of(context)!
                              .text("weapon_type"),
                          style: getHeaderStyle()),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(data.wEAPONSUBTYPE ?? ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppTranslations.of(context)!.text("license_holder_name"),
                        style: getHeaderStyle(),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(data.lISCENSEHOLDERNAME ?? ""),
                      flex: 1,
                    )
                  ],
                ),
              ),
            ],
          ),*/
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
