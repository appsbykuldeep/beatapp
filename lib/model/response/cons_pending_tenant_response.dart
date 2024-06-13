import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ConsPendingTenantResponse {
  String? tENANTSRNUM;
  String? cOMPLAINANTNAME;

  //@SerializedName("REG_DT")
  String? rEGDT;

  //@SerializedName("ASSIGNED_ON")
  String? aSSIGNEDON;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("EO_NAME")
  String? eONAME;

  ConsPendingTenantResponse(this.tENANTSRNUM, this.cOMPLAINANTNAME, this.rEGDT,
      this.aSSIGNEDON, this.tARGETDT, this.eONAME);

  factory ConsPendingTenantResponse.fromJson(json) {
    return ConsPendingTenantResponse(
        json["TENANT_SR_NUM"].toString(),
        json["COMPLAINANT_NAME"].toString(),
        json["REG_DT"].toString(),
        json["ASSIGNED_ON"].toString(),
        json["TARGET_DT"].toString(),
        json["EO_NAME"].toString());
  }

  static List<ConsPendingTenantResponse> getLast15DaysList(
      List<ConsPendingTenantResponse> inputlist) {
    List<ConsPendingTenantResponse> outputList =
    inputlist.where((ConsPendingTenantResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.aSSIGNEDON.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<ConsPendingTenantResponse> getLast15To30DaysList(
      List<ConsPendingTenantResponse> inputlist) {
    List<ConsPendingTenantResponse> outputList =
    inputlist.where((ConsPendingTenantResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.aSSIGNEDON.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<ConsPendingTenantResponse> getBefore30DaysList(
      List<ConsPendingTenantResponse> inputlist) {
    List<ConsPendingTenantResponse> outputList =
    inputlist.where((ConsPendingTenantResponse element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.aSSIGNEDON.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<ConsPendingTenantResponse> getDataFromToDateList(String fDate,String tDate,List<ConsPendingTenantResponse> inputlist) {
    List<ConsPendingTenantResponse> outputList = inputlist.where((ConsPendingTenantResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.aSSIGNEDON.toString());
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
      context, List<ConsPendingTenantResponse> lst) async {
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
      sheet.getRangeByIndex(1, 2).setText('REGISTERED_DT');
      sheet.getRangeByIndex(1, 3).setText('ASSIGNED_DT');
      sheet.getRangeByIndex(1, 4).setText('BEAT_CONSTABLE_NAME');
      sheet.getRangeByIndex(1, 5).setText('EO_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].tENANTSRNUM??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].rEGDT??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].aSSIGNEDON??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText(("").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].eONAME??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('PendingTenant', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
