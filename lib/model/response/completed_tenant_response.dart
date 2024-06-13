import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CompletedTenantResponse {
  //@SerializedName("TENANT_SR_NUM")
  String beatName;
  String? tENANTSRNUM;

  //@SerializedName("COMPLETED_DT")
  String? cOMPLETEDDT;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("EO_NAME")
  String? eONAME;

  CompletedTenantResponse(this.beatName,this.tENANTSRNUM, this.cOMPLETEDDT, this.rEGISTEREDDT,
      this.bEATCONSTABLENAME, this.eONAME);

  factory CompletedTenantResponse.fromJson(Map<String, dynamic> json) {
    return CompletedTenantResponse(
        json["BEAT_NAME"]??'',
        json["TENANT_SR_NUM"].toString(),
        json["COMPLETED_DT"],
        json["REGISTERED_DT"],
        json["BEAT_CONSTABLE_NAME"],
        json["EO_NAME"]);
  }
  static List<CompletedTenantResponse> getLast15DaysList(
      List<CompletedTenantResponse> inputlist) {
    List<CompletedTenantResponse> outputList =
    inputlist.where((CompletedTenantResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.cOMPLETEDDT.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CompletedTenantResponse> getLast15To30DaysList(
      List<CompletedTenantResponse> inputlist) {
    List<CompletedTenantResponse> outputList =
    inputlist.where((CompletedTenantResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.cOMPLETEDDT.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CompletedTenantResponse> getBefore30DaysList(
      List<CompletedTenantResponse> inputlist) {
    List<CompletedTenantResponse> outputList =
    inputlist.where((CompletedTenantResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.cOMPLETEDDT.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CompletedTenantResponse> getDataFromToDateList(String fDate,String tDate,List<CompletedTenantResponse> inputlist) {
    List<CompletedTenantResponse> outputList = inputlist.where((CompletedTenantResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.cOMPLETEDDT.toString());
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
      context, List<CompletedTenantResponse> lst) async {
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
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].cOMPLETEDDT??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].rEGISTEREDDT??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].bEATCONSTABLENAME??"").toString());
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
