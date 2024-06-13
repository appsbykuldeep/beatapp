import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/pending_employee_list_cons_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/ui/employee_verification/constable/cons_employee_info_submit_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ConsPendingFragmentEmployee extends StatefulWidget {
  const ConsPendingFragmentEmployee({Key? key}) : super(key: key);

  @override
  State<ConsPendingFragmentEmployee> createState() =>
      _ConsPendingFragmentEmployeeState();
}

class _ConsPendingFragmentEmployeeState
    extends BaseFullState<ConsPendingFragmentEmployee> {
  List<PendingEmployeeListConsResponse> _lstData = [];
  List<PendingEmployeeListConsResponse> _lstDataAll = [];

  @override
  void initState() {
    _getEmployeeVerificationList();
    super.initState();
  }

  void _getEmployeeVerificationList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_ASSIGNED_EMPLOYEE_CONS, data, true);
    if (response.statusCode == 200) {
      _lstData = [];
      _lstDataAll = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = PendingEmployeeListConsResponse.fromJson(i);
          _lstData.add(data);
          _lstDataAll.add(data);
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

  void savePdf(
      {required List<PendingEmployeeListConsResponse> finalData}) async {
    final pdf = pw.Document();
    pw.TextStyle headingStyle = pw.TextStyle(
        color: PdfColor.fromHex("#ffffff"),
        fontWeight: pw.FontWeight.bold,
        fontSize: 12);
    pw.TextStyle bodyStyle = const pw.TextStyle(fontSize: 10);

    pw.Container heading;

    heading = pw.Container(
      constraints: const pw.BoxConstraints(minHeight: 50),
      child: pw.Stack(
        children: [
          pw.Align(
            alignment: pw.Alignment.bottomLeft,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Container(
                  color: PdfColor.fromHex("#f60000"),
                  height: 5,
                  width: 830,
                ),
                pw.Container(
                  color: PdfColor.fromHex("#01007f"),
                  height: 5,
                  width: 830,
                )
              ],
            ),
          ),
          pw.Container(
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
                    "Service Number",
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
                    "Employee name",
                    style: headingStyle,
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "Related department",
                    style: headingStyle,
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "Assigned date",
                    style: headingStyle,
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "Enquiry officer name",
                    style: headingStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
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
                        child: pw.Text(finalData[index].eMPLOYEESRNUM ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].rEGDT ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].eMPLOYEENAME ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(
                            finalData[index].rEQUESTINGAGENCYNAME ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].aSSIGNEDON ?? '',
                            style: bodyStyle),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].eONAME ?? '',
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
        "EmployeeVerification", await pdf.save(), ".pdf");

    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("employee_verification")),
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
                                context, _lstData.length),
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
                                    width: 888,
                                  ),
                                  Container(
                                    color: ColorProvider.blueColor,
                                    height: 5,
                                    width: 888,
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
                                    child: Text(
                                      "Beat",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 130,
                                    child: Text(
                                      "Service Number",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("date_of_application"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("employee_name"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("related_department"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("assigned_date"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("enquiry_officer_name"),
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
                            _lstData.length, (index) => getRowForConst(index)),
                      ),
                    ]),
              )
            : CustomView.getNoRecordView(context),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (_lstData.isNotEmpty) {
            showDownloadOption(onPdfClick: () {
              savePdf(finalData: _lstData);
            }, onXlsxClick: () {
              PendingEmployeeListConsResponse.generateExcel(context, _lstData);
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
    var data = _lstData[index];
    return InkWell(
      onTap: () async {
        bool res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConsEmployeeInfoSubmitActivity(
                  data: {"EMPLOYEE_SR_NUM": data.eMPLOYEESRNUM}),
            ));
        if (res) {
          _getEmployeeVerificationList();
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
              child: Text(data.eMPLOYEESRNUM ?? "", maxLines: 2),
            ),
            SizedBox(
              width: 130,
              child: Text(data.rEGDT ?? "", maxLines: 2),
            ),
            SizedBox(
              width: 130,
              child: Text(data.eMPLOYEENAME ?? "", maxLines: 2),
            ),
            SizedBox(
              width: 130,
              child: Text(data.rEQUESTINGAGENCYNAME ?? "", maxLines: 2),
            ),
            SizedBox(
              width: 130,
              child: Text(data.aSSIGNEDON ?? "", maxLines: 2),
            ),
            SizedBox(
              width: 130,
              child: Text(data.eONAME ?? "", maxLines: 2),
            ),
          ],
        ),
      ),
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
                      AppTranslations.of(context)!.text(
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
                    child: const Text("Filter Based On Assigned Date"),
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
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 5 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 5;
                              selectedFilterText = "All";
                              Navigator.pop(context);
                              setFilterData();
                            }),
                        Container(
                          child: const Text("Select From And To Date"),
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

  String selectedFDate = "";
  String selectedTDate = "";

  void showDateSelectDialog() {
    selectedFDate = "";
    selectedTDate = "";
    showGeneralDialog(
      context: context,
      barrierLabel: "Date Selection",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(// You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(10),
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
                        AppTranslations.of(context)!.text(
                          "Select From And To Date",
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
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width * .96,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          getTranlateString("From Date"),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .96,
                        height: 35,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          right: 5,
                          left: 5,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              selectedFDate,
                            )),
                            InkWell(
                                onTap: () async {
                                  selectedFDate =
                                      await DialogHelper.openDatePickerDialog(
                                          context);
                                  setState(() {});
                                },
                                child: const Icon(Icons.date_range))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width * .96,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          getTranlateString("To Date"),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .96,
                        height: 35,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          right: 5,
                          left: 5,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              selectedTDate,
                            )),
                            InkWell(
                                onTap: () async {
                                  selectedTDate =
                                      await DialogHelper.openDatePickerDialog(
                                          context);
                                  setState(() {});
                                },
                                child: const Icon(Icons.date_range))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: InkWell(
                        onTap: () {
                          if (selectedFDate == "") {
                            MessageUtility.showToast(
                                context, "Please Select From Date");
                            return;
                          } else if (selectedTDate == "") {
                            MessageUtility.showToast(
                                context, "Please Select To Date");
                            return;
                          }
                          _lstData = PendingEmployeeListConsResponse
                              .getDataFromToDateList(
                                  selectedFDate, selectedTDate, _lstDataAll);
                          selectedFilterText =
                              "$selectedFDate - $selectedTDate";
                          Navigator.pop(context);
                          super.setState(() {});
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          height: 40,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                            color: Color(ColorProvider.colorPrimary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            AppTranslations.of(context)!.text("submit"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
      },
    );
  }

  setFilterData() {
    _lstData = [];
    if (checkedFilter == 1) {
      _lstData = _lstDataAll;
    } else if (checkedFilter == 2) {
      _lstData = PendingEmployeeListConsResponse.getLast15DaysList(_lstDataAll);
    } else if (checkedFilter == 3) {
      _lstData =
          PendingEmployeeListConsResponse.getLast15To30DaysList(_lstDataAll);
    } else if (checkedFilter == 4) {
      _lstData =
          PendingEmployeeListConsResponse.getBefore30DaysList(_lstDataAll);
    } else {
      _lstData = _lstDataAll;
      showDateSelectDialog();
    }
    setState(() {});
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
