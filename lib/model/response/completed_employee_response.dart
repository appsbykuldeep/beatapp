import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CompletedEmployeeResponse {
  //@SerializedName("EMPLOYEE_SR_NUM")
  String beatName;
  String? eMPLOYEESRNUM;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("EMPLOYEE_NAME")
  String? eMPLOYEENAME;

  //@SerializedName("REQUESTING_AGENCY_NAME")
  String? rEQUESTINGAGENCYNAME;

  //@SerializedName("EO_NAME")
  String? eONAME;

  CompletedEmployeeResponse(
      this.beatName,
      this.eMPLOYEESRNUM,
      this.rEGISTEREDDT,
      this.aSSIGNEDDT,
      this.cOMPDT,
      this.tARGETDT,
      this.bEATCONSTABLENAME,
      this.eMPLOYEENAME,
      this.rEQUESTINGAGENCYNAME,
      this.eONAME);

  factory CompletedEmployeeResponse.fromJson(Map<String, dynamic> json) {
    return CompletedEmployeeResponse(
        json["BEAT_NAME"]??'',
        json["EMPLOYEE_SR_NUM"],
        json["REGISTERED_DT"],
        json["ASSIGNED_DT"],
        json["COMP_DT"],
        json["TARGET_DT"],
        json["BEAT_CONSTABLE_NAME"],
        json["EMPLOYEE_NAME"],
        json["REQUESTING_AGENCY_NAME"],
        json["EO_NAME"]);
  }

  static List<CompletedEmployeeResponse> getLast15DaysList(
      List<CompletedEmployeeResponse> inputlist) {
    List<CompletedEmployeeResponse> outputList =
    inputlist.where((CompletedEmployeeResponse element) {
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

  static List<CompletedEmployeeResponse> getLast15To30DaysList(
      List<CompletedEmployeeResponse> inputlist) {
    List<CompletedEmployeeResponse> outputList =
    inputlist.where((CompletedEmployeeResponse element) {
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

  static List<CompletedEmployeeResponse> getBefore30DaysList(
      List<CompletedEmployeeResponse> inputlist) {
    List<CompletedEmployeeResponse> outputList =
    inputlist.where((CompletedEmployeeResponse element) {
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
  static List<CompletedEmployeeResponse> getDataFromToDateList(String fDate,String tDate,List<CompletedEmployeeResponse> inputlist) {
    List<CompletedEmployeeResponse> outputList = inputlist.where((CompletedEmployeeResponse element) {
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
      context, List<CompletedEmployeeResponse> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('EMPLOYEE_SR_NUM');
      sheet.getRangeByIndex(1, 2).setText('REGISTERED_DT');
      sheet.getRangeByIndex(1, 3).setText('ASSIGNED_DT');
      sheet.getRangeByIndex(1, 4).setText('COMP_DT');
      sheet.getRangeByIndex(1, 5).setText('TARGET_DT');
      sheet.getRangeByIndex(1, 6).setText('BEAT_CONSTABLE_NAME');
      sheet.getRangeByIndex(1, 7).setText('EMPLOYEE_NAME');
      sheet.getRangeByIndex(1, 8).setText('REQUESTING_AGENCY_NAME');
      sheet.getRangeByIndex(1, 9).setText('EO_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].eMPLOYEESRNUM??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].rEGISTEREDDT??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].aSSIGNEDDT??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].cOMPDT??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].tARGETDT??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].bEATCONSTABLENAME??"").toString());
        sheet.getRangeByIndex(i+2, 7).setText((lst[i].eMPLOYEENAME??"").toString());
        sheet.getRangeByIndex(i+2, 8).setText((lst[i].rEQUESTINGAGENCYNAME??"").toString());
        sheet.getRangeByIndex(i+2, 9).setText((lst[i].eONAME??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('CompletedEmpVer', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
