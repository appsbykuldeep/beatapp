import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CompletedTenantConsResponse {
  //@SerializedName("TENANT_SR_NUM")
  String? tENANTSRNUM;

  //@SerializedName("COMPLAINANT_NAME")
  String? cOMPLAINANTNAME;

  //@SerializedName("REG_DT")
  String? rEGDT;

  //@SerializedName("ASSIGNED_ON")
  String? aSSIGNEDON;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("EO_NAME")
  String? eONAME;

  CompletedTenantConsResponse(this.tENANTSRNUM, this.cOMPLAINANTNAME,
      this.rEGDT, this.aSSIGNEDON, this.tARGETDT, this.cOMPDT, this.eONAME);

  factory CompletedTenantConsResponse.fromJson(Map<String, dynamic> json) {
    return CompletedTenantConsResponse(
        json["TENANT_SR_NUM"].toString(),
        json["COMPLAINANT_NAME"].toString(),
        json["REG_DT"].toString(),
        json["ASSIGNED_ON"].toString(),
        json["TARGET_DT"].toString(),
        json["COMP_DT"].toString(),
        json["EO_NAME"].toString());
  }

  static List<CompletedTenantConsResponse> getLast15DaysList(
      List<CompletedTenantConsResponse> inputlist) {
    List<CompletedTenantConsResponse> outputList =
    inputlist.where((CompletedTenantConsResponse element) {
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

  static List<CompletedTenantConsResponse> getLast15To30DaysList(
      List<CompletedTenantConsResponse> inputlist) {
    List<CompletedTenantConsResponse> outputList =
    inputlist.where((CompletedTenantConsResponse element) {
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

  static List<CompletedTenantConsResponse> getBefore30DaysList(
      List<CompletedTenantConsResponse> inputlist) {
    List<CompletedTenantConsResponse> outputList =
    inputlist.where((CompletedTenantConsResponse element) {
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

  static List<CompletedTenantConsResponse> getDataFromToDateList(String fDate,String tDate,List<CompletedTenantConsResponse> inputlist) {
    List<CompletedTenantConsResponse> outputList = inputlist.where((CompletedTenantConsResponse element) {
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
      context, List<CompletedTenantConsResponse> lst) async {
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
      sheet.getRangeByIndex(1, 2).setText('COMPLETED_DT');
      sheet.getRangeByIndex(1, 3).setText('REGISTERED_DT');
      sheet.getRangeByIndex(1, 4).setText('BEAT_CONSTABLE_NAME');
      sheet.getRangeByIndex(1, 5).setText('EO_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].tENANTSRNUM??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].cOMPDT??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].rEGDT??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText(("").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].eONAME??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('CompletedTenant', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
