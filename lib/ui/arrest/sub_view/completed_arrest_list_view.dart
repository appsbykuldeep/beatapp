import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/arrest.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/arrest/arrest_detail_view.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CompletedArrestListFragment extends StatefulWidget {
  final data;

  const CompletedArrestListFragment({Key? key, required this.data})
      : super(key: key);

  @override
  State<CompletedArrestListFragment> createState() =>
      _CompletedArrestListFragmentState(data);
}

class _CompletedArrestListFragmentState
    extends BaseFullState<CompletedArrestListFragment> {
  List<Arrest> _lstArrest = [];
  final List<Arrest> _lstArrestAll = [];

  String role = "0";

  _CompletedArrestListFragmentState(data) {
    role = data["role"];
  }

  @override
  void initState() {
    _getArrestCompleteList();
    super.initState();
  }

  void _getArrestCompleteList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    late Response response;
    if (role == "23") {
      response = await HttpRequst.postRequestWithTokenAndBody(context,
          EndPoints.END_POINT_GET_COMPLETED_ARREST_LIST_BEAT, data, true);
    } else {
      response = await HttpRequst.postRequestWithTokenAndBody(context,
          EndPoints.END_POINT_GET_COMPLETED_ARREST_LIST_SHO, data, true);
    }
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = Arrest.fromJson(i);
          _lstArrest.add(data);
          _lstArrestAll.add(data);
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

  void savePdf({required List<Arrest> finalData}) async {
    final pdf = pw.Document();
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
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "Accused person",
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "FIR date",
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "Assigned date",
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "Assigned constable",
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "Target Date",
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
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
                  height: 40,
                  padding: const pw.EdgeInsets.only(left: 4, right: 4),
                  color: index % 2 == 0
                      ? PdfColor.fromHex("#f3f3fc")
                      : PdfColor.fromHex("#fdf5f5"),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(finalData[index].beatName,
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].accusedName ?? '',
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].firDate ?? '',
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].assignDate ?? '',
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].assignedTo ?? '',
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].targetDate ?? '',
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                );
              })
        ];
      },
    ));
    await CameraAndFileProvider.saveFile(
        "ArrestedCriminals", await pdf.save(), ".pdf");

    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("completed_arrest")),
        backgroundColor: Color(ColorProvider.colorPrimary),
        //bottom: getTabs(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _lstArrest.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showFilterDialog(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.filter_alt,
                                      size: 18,
                                    ),
                                    Text(selectedFilterText)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                              child: CustomView.getCountView(
                                  context, _lstArrest.length),
                            )
                          ],
                        ),
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
                                    width: 750,
                                  ),
                                  Container(
                                    color: ColorProvider.blueColor,
                                    height: 5,
                                    width: 750,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              color: Colors.white,
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
                                      getTranlateString("accused_name"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("fir_date"),
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
                                      getTranlateString("assigned_beat_person"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      getTranlateString("target_date"),
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
                        children: List.generate(_lstArrest.length,
                            (index) => getRowForConst(index)),
                      ),
                    ]),
              )
            : CustomView.getNoRecordView(context),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (_lstArrest.isNotEmpty) {
            showDownloadOption(
              onXlsxClick: () {
                Arrest.generateExcel(context, _lstArrest, "CompletedArrest");
              },
              onPdfClick: () {
                savePdf(finalData: _lstArrest);
              },
            );
          }
        },
        child: Container(
          height: 45,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
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
    var data = _lstArrest[index];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArrestDetailActivity(arrest: data),
            ));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 4),
        color: index % 2 == 0
            ? ColorProvider.redColor.withOpacity(0.05)
            : ColorProvider.blueColor.withOpacity(0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    data.beatName,
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    data.accusedName ?? "",
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(data.firDate ?? ""),
                ),
                SizedBox(
                  width: 130,
                  child: Text(data.assignDate ?? ""),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    data.assignedTo ?? "",
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    data.targetDate ?? "",
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool sortByAcc = false;
  bool sortByFirDt = false;
  bool sortByAssDt = false;
  bool sortByAssBeat = false;
  bool sortByTGTDT = false;

  sortData(type) {
    if (type == 1) {
      sortByAcc = !sortByAcc;
      Arrest.sortByAccusedName(_lstArrest, sortByAcc);
    } else if (type == 2) {
      sortByFirDt = !sortByFirDt;
      Arrest.sortByFirDate(_lstArrest, sortByFirDt);
    } else if (type == 3) {
      sortByAssDt = !sortByAssDt;
      Arrest.sortByAssDate(_lstArrest, sortByAssDt);
    } else if (type == 4) {
      sortByAssBeat = !sortByAssBeat;
      Arrest.sortByAssBeat(_lstArrest, sortByAssBeat);
    } else {
      sortByTGTDT = !sortByTGTDT;
      Arrest.sortByTargetDate(_lstArrest, sortByAssBeat);
    }
    setState(() {});
  }

  int checkedFilter = 1;
  String selectedFilterText = "All";
  String selectedFDate = "";
  String selectedTDate = "";

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
                    child: const Text("Filter Based On FIR Date"),
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
                          _lstArrest = Arrest.getDataFromToDateList(
                              selectedFDate, selectedTDate, _lstArrestAll);
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
    _lstArrest = [];
    if (checkedFilter == 1) {
      _lstArrest = _lstArrestAll;
    } else if (checkedFilter == 2) {
      _lstArrest = Arrest.getLast15DaysList(_lstArrestAll);
    } else if (checkedFilter == 3) {
      _lstArrest = Arrest.getLast15To30DaysList(_lstArrestAll);
    } else if (checkedFilter == 4) {
      _lstArrest = Arrest.getBefore30DaysList(_lstArrestAll);
    } else {
      _lstArrest = _lstArrestAll;
      showDateSelectDialog();
    }
    setState(() {});
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
