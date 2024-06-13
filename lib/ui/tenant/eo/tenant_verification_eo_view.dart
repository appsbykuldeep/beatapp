import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/cs_eo_action_list_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/feedback/eo_feefback_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TenantVerificationEoActivity extends StatefulWidget {
  final data;
  const TenantVerificationEoActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<TenantVerificationEoActivity> createState() =>
      _TenantVerificationEoActivityState();
}

class _TenantVerificationEoActivityState
    extends BaseFullState<TenantVerificationEoActivity> {
  List<CsEoActionListResponse> lstData = [];
  List<CsEoActionListResponse> lstDataAll = [];

  @override
  void initState() {
    _getTenantList();
    super.initState();
  }

  void _getTenantList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd, "SERVICE_TYPE": "4"};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.CS_EO_ACTION_LIST, data, true);
    lstData = [];
    lstDataAll = [];
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = CsEoActionListResponse.fromJson(i);
          lstData.add(data);
          lstDataAll.add(data);
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

  void savePdf({required List<CsEoActionListResponse> finalData}) async {
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
                "Application Serial number",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Name of applicant",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Application date",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Completed by constable on",
                style: headingStyle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                "Beat constable",
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
                        child: pw.Text(finalData[index].aPPLICATIONSRNUM ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].rEQUESTERNAME ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].aPPLICATIONDT ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].cOMPLDT ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].bEATCONSTABLENAME ?? '',
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
        "TenantVerification", await pdf.save(), ".pdf");

    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("tenant_verification")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: lstData.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x80000000),
                                      offset: Offset(
                                        2.0,
                                        2.0,
                                      ),
                                      blurRadius: 3.0,
                                      spreadRadius: 2.0,
                                    ), //BoxShadow
                                    //BoxShadow
                                  ]),
                              child: InkWell(
                                onTap: () {
                                  showFilterDialog(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.filter_alt,
                                      size: 18,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(selectedFilterText),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                            child: CustomView.getCountView(
                                context, lstData.length),
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
                                    width: 758,
                                  ),
                                  Container(
                                    color: ColorProvider.blueColor,
                                    height: 5,
                                    width: 758,
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
                                  const SizedBox(
                                    width: 100,
                                    child: Text("Beat"),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString(
                                          "application_serial_number"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("applicant_name"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("application_date"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString(
                                          "completed_by_constable_on"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("beat_constable"),
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
                        children: List.generate(
                            lstData.length, (index) => getRowForConst(index)),
                      ),
                    ]),
              ))
          : Center(
              child: Text(AppTranslations.of(context)!.text("no_record_found")),
            ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (lstData.isNotEmpty) {
            showDownloadOption(onXlsxClick: () {
              CsEoActionListResponse.generateExcelUnAssigned(context, lstData);
            }, onPdfClick: () {
              savePdf(finalData: lstData);
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
    var data = lstData[index];
    return InkWell(
      onTap: () async {
        bool result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EoFeedbackActivity(
                data: {
                  "APPLICATION_SR_NUM": data.aPPLICATIONSRNUM,
                  "SERVICE_TYPE": "4"
                },
              ),
            ));
        if (result) {
          _getTenantList();
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
              SizedBox(
                width: 100,
                child: Text(data.beatName),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  data.aPPLICATIONSRNUM ?? "",
                ),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  data.rEQUESTERNAME ?? "",
                ),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  (data.aPPLICATIONDT ?? "").split(" ")[0],
                ),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  (data.cOMPLDT ?? "").split(" ")[0],
                ),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  data.bEATCONSTABLENAME ?? "",
                ),
              ),
            ],
          )),
    );
  }

  int checkedFilter = 1;
  String selectedFilterText = "All";

  void showFilterDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "filter",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * .90,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF000000),
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    //BoxShadow
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Text(
                      getTranlateString(
                        "Filter",
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    child: const Text("Filter Based On Registered Date"),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 1 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 1;
                              selectedFilterText = "All";
                              setFilterData();
                              Navigator.pop(context);
                            }),
                        Container(
                          child: const Text("All"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 2 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 2;
                              selectedFilterText = "15 days";
                              setFilterData();
                              Navigator.pop(context);
                            }),
                        Container(
                          child: const Text("15 days"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 3 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 3;
                              selectedFilterText = "15 to 30 days";
                              setFilterData();
                              Navigator.pop(context);
                            }),
                        Container(
                          child: const Text("15 to 30 days"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 4 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 4;
                              selectedFilterText = "After 30 days";
                              setFilterData();
                              Navigator.pop(context);
                            }),
                        Container(
                          child: const Text("After 30 days"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }

  setFilterData() {
    lstData = [];
    if (checkedFilter == 1) {
      lstData = lstDataAll;
    } else if (checkedFilter == 2) {
      lstData = CsEoActionListResponse.getLast15DaysList(lstDataAll);
    } else if (checkedFilter == 3) {
      lstData = CsEoActionListResponse.getLast15To30DaysList(lstDataAll);
    } else {
      lstData = CsEoActionListResponse.getBefore30DaysList(lstDataAll);
    }
    setState(() {});
  }
}
