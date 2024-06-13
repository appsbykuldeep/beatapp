import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class UnassignedEmployeeResponse {
  //@SerializedName("EMPLOYEE_SR_NUM")
  String beatName;
  String? eMPLOYEESRNUM;

  //@SerializedName("REGISTRATION_DATE")
  String? rEGISTRATIONDATE;

  //@SerializedName("EMPLOYEE_NAME")
  String? eMPLOYEENAME;

  //@SerializedName("REQUESTING_AGENCY_NAME")
  String? rEQUESTINGAGENCYNAME;

  //@SerializedName("ASSIGN_STATUS")
  String? aSSIGNSTATUS;

  UnassignedEmployeeResponse(this.beatName,this.eMPLOYEESRNUM, this.rEGISTRATIONDATE,
      this.eMPLOYEENAME, this.rEQUESTINGAGENCYNAME, this.aSSIGNSTATUS);

  factory UnassignedEmployeeResponse.fromJson(json) {
    return UnassignedEmployeeResponse(
        json["BEAT_NAME"]??'',
        json["EMPLOYEE_SR_NUM"].toString(),
        json["REGISTRATION_DATE"],
        json["EMPLOYEE_NAME"],
        json["REQUESTING_AGENCY_NAME"],
        json["ASSIGN_STATUS"]);
  }

  static List<UnassignedEmployeeResponse> getLast15DaysList(
      List<UnassignedEmployeeResponse> inputlist) {
    List<UnassignedEmployeeResponse> outputList =
    inputlist.where((UnassignedEmployeeResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.rEGISTRATIONDATE.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<UnassignedEmployeeResponse> getLast15To30DaysList(
      List<UnassignedEmployeeResponse> inputlist) {
    List<UnassignedEmployeeResponse> outputList =
    inputlist.where((UnassignedEmployeeResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.rEGISTRATIONDATE.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<UnassignedEmployeeResponse> getBefore30DaysList(
      List<UnassignedEmployeeResponse> inputlist) {
    List<UnassignedEmployeeResponse> outputList =
    inputlist.where((UnassignedEmployeeResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.rEGISTRATIONDATE.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<UnassignedEmployeeResponse> getDataFromToDateList(String fDate,String tDate,List<UnassignedEmployeeResponse> inputlist) {
    List<UnassignedEmployeeResponse> outputList = inputlist.where((UnassignedEmployeeResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.rEGISTRATIONDATE.toString());
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
      context, List<UnassignedEmployeeResponse> lst) async {
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
      sheet.getRangeByIndex(1, 2).setText('REGISTRATION_DATE');
      sheet.getRangeByIndex(1, 3).setText('EMPLOYEE_NAME');
      sheet.getRangeByIndex(1, 4).setText('REQUESTING_AGENCY_NAME');
      sheet.getRangeByIndex(1, 5).setText('ASSIGN_STATUS');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].eMPLOYEESRNUM??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].rEGISTRATIONDATE??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].eMPLOYEENAME??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].rEQUESTINGAGENCYNAME??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].aSSIGNSTATUS??"").toString());
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
