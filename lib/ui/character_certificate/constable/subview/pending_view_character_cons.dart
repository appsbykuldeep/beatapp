import 'package:beatapp/api/api_connection.dart';
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/character_certificate.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/character_certificate/verify_character_view.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PendingFragmentCharacterCons extends StatefulWidget {
  const PendingFragmentCharacterCons({Key? key}) : super(key: key);

  @override
  State<PendingFragmentCharacterCons> createState() =>
      _PendingFragmentCharacterConsState();
}

class _PendingFragmentCharacterConsState
    extends BaseFullState<PendingFragmentCharacterCons> {
  List<CharacterCertificate> lstData = [];
  List<CharacterCertificate> lstDataAll = [];

  @override
  void initState() {
    _getCharacterCertList();
    super.initState();
  }

  void _getCharacterCertList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await postRequestWithTokenAndBody(context,
        EndPoints.END_POINT_GET_ASSIGNED_CHARACTER_LIST_BEAT, data, true);
    if (response.statusCode == 200) {
      lstData = [];
      lstDataAll = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = CharacterCertificate.fromJson(i);
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

  void savePdf({required List<CharacterCertificate> finalData}) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoMedium();
    pw.Container heading;
    heading = pw.Container(
      height: 50,
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
            height: 40,
            padding: const pw.EdgeInsets.only(left: 4, right: 4),
            color: PdfColor.fromHex("#f60000"),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    "Beat",
                    style: pw.TextStyle(
                        font: font,
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    "Service number",
                    style: pw.TextStyle(
                        font: font,
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    getTranlateString("date_of_registration"),
                    style: pw.TextStyle(
                        font: font,
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    getTranlateString("assigned_date"),
                    style: pw.TextStyle(
                        font: font,
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    getTranlateString("applicant_name"),
                    style: pw.TextStyle(
                        font: font,
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    getTranlateString("beat_constable"),
                    style: pw.TextStyle(
                        font: font,
                        color: PdfColor.fromHex("#ffffff"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    getTranlateString("enquiry_officer_name"),
                    style: pw.TextStyle(
                        font: font,
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
                            style: pw.TextStyle(font: font, fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].srNum ?? '',
                            style: pw.TextStyle(font: font, fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].regDate ?? '',
                            style: pw.TextStyle(font: font, fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].assignedDt ?? '',
                            style: pw.TextStyle(font: font, fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].complainantName ?? '',
                            style: pw.TextStyle(font: font, fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].beatConstableName ?? '',
                            style: pw.TextStyle(font: font, fontSize: 10)),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(finalData[index].eoName ?? '',
                            style: pw.TextStyle(font: font, fontSize: 10)),
                      ),
                    ],
                  ),
                );
              })
        ];
      },
    ));
    await CameraAndFileProvider.saveFile(
        "CharacterCertificate", await pdf.save(), ".pdf");

    MessageUtility.showDownloadCompleteMsg(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("character_certificate")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: lstData.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
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
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            color: Colors.white,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    "Beat",
                                  ),
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text(
                                    "Service number",
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    getTranlateString("date_of_registration"),
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    getTranlateString("assigned_date"),
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    getTranlateString("applicant_name"),
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    getTranlateString("beat_constable"),
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    getTranlateString("enquiry_officer_name"),
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
                  ],
                ),
              )
            : CustomView.getNoRecordView(context),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: InkWell(
          onTap: () {
            showDownloadOption(onPdfClick: () {
              savePdf(finalData: lstData);
            }, onXlsxClick: () {
              CharacterCertificate.generateExcelAccepted(context, lstData);
            });
          },
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
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
      ),
    );
  }

  Widget getRowForConst(int index) {
    var data = lstData[index];
    return InkWell(
      onTap: () async {
        bool res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyCharacterActivity(
                  data: {"CHARACTER_SR_NUM": data.srNum}),
            ));
        if (res) {
          _getCharacterCertList();
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 4),
        height: 40,
        color: index % 2 == 0
            ? ColorProvider.redColor.withOpacity(0.05)
            : ColorProvider.blueColor.withOpacity(0.05),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                data.beatName,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 130,
              child: Text(
                data.srNum ?? "",
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 130,
              child: Text(
                data.regDate ?? "",
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 130,
              child: Text(
                data.assignedDt ?? "",
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 130,
              child: Text(
                data.complainantName ?? "",
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 130,
              child: Text(
                data.beatConstableName ?? "",
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 130,
              child: Text(
                data.eoName ?? "",
                style: const TextStyle(fontSize: 12),
              ),
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
                  const Text("Filter Based On Assigned Date"),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 1 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 1;
                            selectedFilterText = "All";
                            setFilterData();
                            Navigator.pop(context);
                          }),
                      const Text("All")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 2 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 2;
                            selectedFilterText = "15 days";
                            setFilterData();
                            Navigator.pop(context);
                          }),
                      const Text("15 days")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 3 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 3;
                            selectedFilterText = "15 to 30 days";
                            setFilterData();
                            Navigator.pop(context);
                          }),
                      const Text("15 to 30 days")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 4 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 4;
                            selectedFilterText = "After 30 days";
                            setFilterData();
                            Navigator.pop(context);
                          }),
                      const Text("After 30 days")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 5 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 5;
                            selectedFilterText = "All";
                            Navigator.pop(context);
                            setFilterData();
                          }),
                      const Text("Select From And To Date")
                    ],
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
                          lstData = CharacterCertificate.getDataFromToDateList(
                              selectedFDate, selectedTDate, lstDataAll);
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
    lstData = [];
    if (checkedFilter == 1) {
      lstData = lstDataAll;
    } else if (checkedFilter == 2) {
      lstData = CharacterCertificate.getLast15DaysListAssigned(lstDataAll);
    } else if (checkedFilter == 3) {
      lstData = CharacterCertificate.getLast15To30DaysListAssigned(lstDataAll);
    } else if (checkedFilter == 4) {
      lstData = CharacterCertificate.getBefore30DaysListAssigned(lstDataAll);
    } else {
      lstData = lstDataAll;
      showDateSelectDialog();
    }
    setState(() {});
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}