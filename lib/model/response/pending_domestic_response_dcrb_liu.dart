import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class PendingDomesticResponseDcrbLiu {
  String beatName;
  int serviceNumber;
  String applicationDt;
  String rEGISTEREDDT;
  String applicantName;

  PendingDomesticResponseDcrbLiu(this.beatName, this.serviceNumber,
      this.applicationDt, this.rEGISTEREDDT, this.applicantName);

  factory PendingDomesticResponseDcrbLiu.fromJson(json) {
    return PendingDomesticResponseDcrbLiu(
        json["BEAT_NAME"] ?? '',
        json["DOMESTIC_SR_NUM"] ?? 0,
        json["APPLICATION_DT"] ?? '',
        json["REGISTERED_DT"] ?? '',
        json["APPLICANT_NAME"] ?? '');
  }

  static Future<void> generateExcel(
      context, List<PendingDomesticResponseDcrbLiu> lst) async {
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
      sheet.getRangeByIndex(1, 2).setText('APPLICATION_DT');
      sheet.getRangeByIndex(1, 3).setText('REGISTERED_DT');
      sheet.getRangeByIndex(1, 4).setText('APPLICANT_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet
            .getRangeByIndex(i + 2, 1)
            .setText((lst[i].serviceNumber).toString());
        sheet
            .getRangeByIndex(i + 2, 2)
            .setText((lst[i].applicationDt).toString());
        sheet
            .getRangeByIndex(i + 2, 3)
            .setText((lst[i].rEGISTEREDDT).toString());
        sheet
            .getRangeByIndex(i + 2, 4)
            .setText((lst[i].applicantName).toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage(
          'PendingDomesticVerification', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    } else {
      MessageUtility.showNoDataMsg(context);
    }
  }

  static List<PendingDomesticResponseDcrbLiu> getLast15DaysList(
      List<PendingDomesticResponseDcrbLiu> inputlist) {
    List<PendingDomesticResponseDcrbLiu> outputList =
        inputlist.where((PendingDomesticResponseDcrbLiu element) {
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

  static List<PendingDomesticResponseDcrbLiu> getLast15To30DaysList(
      List<PendingDomesticResponseDcrbLiu> inputlist) {
    List<PendingDomesticResponseDcrbLiu> outputList =
        inputlist.where((PendingDomesticResponseDcrbLiu element) {
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

  static List<PendingDomesticResponseDcrbLiu> getBefore30DaysList(
      List<PendingDomesticResponseDcrbLiu> inputlist) {
    List<PendingDomesticResponseDcrbLiu> outputList =
        inputlist.where((PendingDomesticResponseDcrbLiu element) {
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

  static List<PendingDomesticResponseDcrbLiu> getDataFromToDateList(
      String fDate,
      String tDate,
      List<PendingDomesticResponseDcrbLiu> inputlist) {
    List<PendingDomesticResponseDcrbLiu> outputList =
        inputlist.where((PendingDomesticResponseDcrbLiu element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.applicationDt.toString());
        return DateFormat('MM/dd/yyyy').parse(fDate).isBefore(date) &&
            DateFormat('MM/dd/yyyy').parse(tDate).isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }
}
