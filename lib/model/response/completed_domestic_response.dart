import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CompletedDomesticResponse {
  //@SerializedName("DOMESTIC_SR_NUM")
  String beatName;
  String? dOMESTICSRNUM;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("APPLICANTNAME")
  String? aPPLICANTNAME;

  //@SerializedName("EO_NAME")
  String? eONAME;

  CompletedDomesticResponse(
      this.beatName,
      this.dOMESTICSRNUM,
      this.rEGISTEREDDT,
      this.aSSIGNEDDT,
      this.bEATCONSTABLENAME,
      this.cOMPDT,
      this.aPPLICANTNAME,
      this.eONAME);

  factory CompletedDomesticResponse.fromJson(Map<String, dynamic> json) {
    return CompletedDomesticResponse(
        json["BEAT_NAME"]??'',
        json["DOMESTIC_SR_NUM"].toString(),
        json["REGISTERED_DT"],
        json["ASSIGNED_DT"],
        json["BEAT_CONSTABLE_NAME"],
        json["COMP_DT"],
        json["APPLICANTNAME"],
        json["EO_NAME"]);
  }


  static List<CompletedDomesticResponse> getLast15DaysList(
      List<CompletedDomesticResponse> inputlist) {
    List<CompletedDomesticResponse> outputList =
    inputlist.where((CompletedDomesticResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.cOMPDT.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CompletedDomesticResponse> getLast15To30DaysList(
      List<CompletedDomesticResponse> inputlist) {
    List<CompletedDomesticResponse> outputList =
    inputlist.where((CompletedDomesticResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.cOMPDT.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CompletedDomesticResponse> getBefore30DaysList(
      List<CompletedDomesticResponse> inputlist) {
    List<CompletedDomesticResponse> outputList =
    inputlist.where((CompletedDomesticResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.cOMPDT.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CompletedDomesticResponse> getDataFromToDateList(String fDate,String tDate,List<CompletedDomesticResponse> inputlist) {
    List<CompletedDomesticResponse> outputList = inputlist.where((CompletedDomesticResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.cOMPDT.toString());
        return DateFormat('MM/dd/yyyy')
            .parse(fDate).isBefore(date) &&
            DateFormat('MM/dd/yyyy')
                .parse(tDate).isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static Future<void> generateExcel(
      context, List<CompletedDomesticResponse> lst) async {
    if (lst.isNotEmpty) {
      DialogHelper.showLoaderDialog(context);
      //Creating a workbook.
      final Workbook workbook = Workbook();
      //Accessing via index
      final Worksheet sheet = workbook.worksheets[0];
      sheet.showGridlines = true;

      // Enable calculation for worksheet.
      sheet.enableSheetCalculations();
      JsonToExcel.setExcelStyle(sheet);

      sheet.getRangeByIndex(1, 1).setText('DOMESTIC_SR_NUM');
      sheet.getRangeByIndex(1, 2).setText('REGISTERED_DT');
      sheet.getRangeByIndex(1, 3).setText('ASSIGNED_DT');
      sheet.getRangeByIndex(1, 4).setText('BEAT_CONSTABLE_NAME');
      sheet.getRangeByIndex(1, 5).setText('COMP_DT');
      sheet.getRangeByIndex(1, 6).setText('APPLICANTNAME');
      sheet.getRangeByIndex(1, 7).setText('EO_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].dOMESTICSRNUM??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].rEGISTEREDDT??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].aSSIGNEDDT??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].bEATCONSTABLENAME??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].cOMPDT??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].aPPLICANTNAME??"").toString());
        sheet.getRangeByIndex(i+2, 7).setText((lst[i].eONAME??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('CompletedDomesticVerification', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
