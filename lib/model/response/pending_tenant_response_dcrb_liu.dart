import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class PendingTenantResponseDcrbLiu {
  String beatName;
  String? serviceNumber;

  //@SerializedName("APPLICATION_DT")
  String? applicationDt;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("APPLICANT_NAME")
  String? applicantName;

  PendingTenantResponseDcrbLiu(this.beatName,
      this.serviceNumber, this.applicationDt,
      this.rEGISTEREDDT, this.applicantName);

  factory PendingTenantResponseDcrbLiu.fromJson(json) {
    return PendingTenantResponseDcrbLiu(json["BEAT_NAME"]??'',
        json["TENANT_SR_NUM"].toString(),
        json["APPLICATION_DT"], json["REGISTERED_DT"], json["APPLICANT_NAME"]);
  }


  static List<PendingTenantResponseDcrbLiu> getLast15DaysList(
      List<PendingTenantResponseDcrbLiu> inputlist) {
    List<PendingTenantResponseDcrbLiu> outputList =
    inputlist.where((PendingTenantResponseDcrbLiu element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.applicationDt.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<PendingTenantResponseDcrbLiu> getLast15To30DaysList(
      List<PendingTenantResponseDcrbLiu> inputlist) {
    List<PendingTenantResponseDcrbLiu> outputList =
    inputlist.where((PendingTenantResponseDcrbLiu element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.applicationDt.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<PendingTenantResponseDcrbLiu> getBefore30DaysList(
      List<PendingTenantResponseDcrbLiu> inputlist) {
    List<PendingTenantResponseDcrbLiu> outputList =
    inputlist.where((PendingTenantResponseDcrbLiu element) {
      try {
        final date =
        DateFormat('dd/MM/yyyy').parse(element.applicationDt.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<PendingTenantResponseDcrbLiu> getDataFromToDateList(String fDate,String tDate,List<PendingTenantResponseDcrbLiu> inputlist) {
    List<PendingTenantResponseDcrbLiu> outputList = inputlist.where((PendingTenantResponseDcrbLiu element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.applicationDt.toString());
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
      context, List<PendingTenantResponseDcrbLiu> lst) async {
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
      sheet.getRangeByIndex(1, 2).setText('APPLICATION_DT');
      sheet.getRangeByIndex(1, 3).setText('REGISTERED_DT');
      sheet.getRangeByIndex(1, 4).setText('APPLICANT_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].serviceNumber??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].applicationDt??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].rEGISTEREDDT??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].applicantName??"").toString());
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
