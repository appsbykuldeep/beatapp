import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class UnassignedTenantResponse {
  //@SerializedName("TENANT_SR_NUM")
  String beatName;
  String? tENANTSRNUM;

  //@SerializedName("RECORD_CREATED_ON")
  String? rECORDCREATEDON;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("STATUS")
  String? sTATUS;

  //@SerializedName("REGISTRATION_DATE")
  String? rEGISTRATIONDATE;

  //@SerializedName("ASSIGN_STATUS")
  String? aSSIGNSTATUS;

  UnassignedTenantResponse(this.beatName,this.tENANTSRNUM, this.rECORDCREATEDON, this.nAME,
      this.sTATUS, this.rEGISTRATIONDATE, this.aSSIGNSTATUS);

  factory UnassignedTenantResponse.fromJson(json) {
    return UnassignedTenantResponse(
        json["BEAT_NAME"]??'',
        json["TENANT_SR_NUM"].toString(),
        json["RECORD_CREATED_ON"],
        json["NAME"],
        json["STATUS"],
        json["REGISTRATION_DATE"],
        json["ASSIGN_STATUS"]);
  }

  static List<UnassignedTenantResponse> getLast15DaysList(
      List<UnassignedTenantResponse> inputlist) {
    List<UnassignedTenantResponse> outputList =
        inputlist.where((UnassignedTenantResponse element) {
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

  static List<UnassignedTenantResponse> getLast15To30DaysList(
      List<UnassignedTenantResponse> inputlist) {
    List<UnassignedTenantResponse> outputList =
        inputlist.where((UnassignedTenantResponse element) {
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

  static List<UnassignedTenantResponse> getBefore30DaysList(
      List<UnassignedTenantResponse> inputlist) {
    List<UnassignedTenantResponse> outputList =
        inputlist.where((UnassignedTenantResponse element) {
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

  static List<UnassignedTenantResponse> getDataFromToDateList(
      String fDate, String tDate, List<UnassignedTenantResponse> inputlist) {
    List<UnassignedTenantResponse> outputList =
        inputlist.where((UnassignedTenantResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.rEGISTRATIONDATE.toString());
        return DateFormat('MM/dd/yyyy').parse(fDate).isBefore(date) &&
            DateFormat('MM/dd/yyyy').parse(tDate).isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static Future<void> generateExcel(
      context, List<UnassignedTenantResponse> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('TENANT_SR_NUM');
      sheet.getRangeByIndex(1, 2).setText('RECORD_CREATED_ON');
      sheet.getRangeByIndex(1, 3).setText('NAME');
      sheet.getRangeByIndex(1, 4).setText('STATUS');
      sheet.getRangeByIndex(1, 5).setText('REGISTRATION_DATE');
      sheet.getRangeByIndex(1, 6).setText('ASSIGN_STATUS');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].tENANTSRNUM??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].rECORDCREATEDON??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].nAME??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].sTATUS??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].rEGISTRATIONDATE??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].aSSIGNSTATUS??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('UnassignedTenant', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
