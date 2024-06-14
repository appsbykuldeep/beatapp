/*-----------------------------------gov.upp.beatapp.SUMMON.POJO.SummonResponse.java-----------------------------------*/

import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/extentions/api_reponse_parser.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class SummonResponse {
  /*Unassigned*/
  String beatName;
  String FIR_PETTY_CASE_DATE;
  String SUMM_WARR_SR_NUM;
  String EXECUTION_LAST_DT;
  String FIR_PETTY_CASE_NUM;
  String ISSUED_TO_PERSON_NAME;
  String SUMM_WARR_NUM;
  String POLICESTATIONNAME;

  /*Pending*/
  String ASSIGNED_TO_ID;
  String ASSIGNED_TO_RANK;
  String COMPLETION_DATE;
  String ASSIGNED_ON;
  String TARGET_DATE;
  String ASSIGNED_TO_NAME;
  String FIR_REG_NUM;

  /*Completed*/
  String LAT;
  String LONG;

  /*Officer Name*/
  String LOGIN_ID;
  String OFFICER_RANK;
  String NAME;

  SummonResponse({
    this.beatName = '',
    this.FIR_PETTY_CASE_DATE = '',
    this.SUMM_WARR_SR_NUM = '',
    this.EXECUTION_LAST_DT = '',
    this.FIR_PETTY_CASE_NUM = '',
    this.ISSUED_TO_PERSON_NAME = '',
    this.SUMM_WARR_NUM = '',
    this.POLICESTATIONNAME = '',
    this.ASSIGNED_TO_ID = '',
    this.ASSIGNED_TO_RANK = '',
    this.COMPLETION_DATE = '',
    this.ASSIGNED_ON = '',
    this.TARGET_DATE = '',
    this.ASSIGNED_TO_NAME = '',
    this.FIR_REG_NUM = '',
    this.LAT = '',
    this.LONG = '',
    this.LOGIN_ID = '',
    this.OFFICER_RANK = '',
    this.NAME = '',
  });

  factory SummonResponse.fromJson(json) {
    return SummonResponse(
      beatName: ["BEAT_NAME"].fetchString(json),
      FIR_PETTY_CASE_DATE: ["FIR_PETTY_CASE_DATE"].fetchString(json),
      SUMM_WARR_SR_NUM: ["SUMM_WARR_SR_NUM"].fetchString(json),
      EXECUTION_LAST_DT: ["EXECUTION_LAST_DT"].fetchString(json),
      FIR_PETTY_CASE_NUM: ["FIR_PETTY_CASE_NUM"].fetchString(json),
      ISSUED_TO_PERSON_NAME: ["ISSUED_TO_PERSON_NAME"].fetchString(json),
      SUMM_WARR_NUM: ["SUMM_WARR_NUM"].fetchString(json),
      POLICESTATIONNAME: ["POLICESTATIONNAME"].fetchString(json),
      ASSIGNED_TO_ID: ["ASSIGNED_TO_ID"].fetchString(json),
      ASSIGNED_TO_RANK: ["ASSIGNED_TO_RANK"].fetchString(json),
      COMPLETION_DATE: ["COMPLETION_DATE"].fetchString(json),
      ASSIGNED_ON: ["ASSIGNED_ON"].fetchString(json),
      TARGET_DATE: ["TARGET_DATE"].fetchString(json),
      ASSIGNED_TO_NAME: ["ASSIGNED_TO_NAME"].fetchString(json),
      FIR_REG_NUM: ["FIR_REG_NUM"].fetchString(json),
      LAT: ["LAT"].fetchString(json, "0"),
      LONG: ["LONG"].fetchString(json, "0"),
      LOGIN_ID: ["LOGIN_ID"].fetchString(json),
      OFFICER_RANK: ["OFFICER_RANK"].fetchString(json),
      NAME: ["NAME"].fetchString(json),
    );
  }

  static List<SummonResponse> getLast15DaysList(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.FIR_PETTY_CASE_DATE.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getLast15To30DaysList(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.FIR_PETTY_CASE_DATE.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getBefore30DaysList(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.FIR_PETTY_CASE_DATE.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getDataFromToDateList(
      String fDate, String tDate, List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.FIR_PETTY_CASE_DATE.toString());
        return DateFormat('MM/dd/yyyy').parse(fDate).isBefore(date) &&
            DateFormat('MM/dd/yyyy').parse(tDate).isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getLast15DaysListAssigned(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.ASSIGNED_ON.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getLast15To30DaysListAssigned(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.ASSIGNED_ON.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getBefore30DaysListAssigned(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.ASSIGNED_ON.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getLast15DaysListComplete(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.COMPLETION_DATE.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getLast15To30DaysListComplete(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.COMPLETION_DATE.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<SummonResponse> getBefore30DaysListComplete(
      List<SummonResponse> inputlist) {
    List<SummonResponse> outputList = inputlist.where((SummonResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.COMPLETION_DATE.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static Future<void> generateExcel(
      context, List<SummonResponse> lst, String fileName) async {
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

      sheet.getRangeByIndex(1, 1).setText('FIR_PETTY_CASE_DATE');
      sheet.getRangeByIndex(1, 2).setText('SUMM_WARR_SR_NUM');
      sheet.getRangeByIndex(1, 3).setText('EXECUTION_LAST_DT');
      sheet.getRangeByIndex(1, 4).setText('FIR_PETTY_CASE_NUM');
      sheet.getRangeByIndex(1, 5).setText('ISSUED_TO_PERSON_NAME');
      sheet.getRangeByIndex(1, 6).setText('SUMM_WARR_NUM');
      sheet.getRangeByIndex(1, 7).setText('POLICESTATIONNAME');
      sheet.getRangeByIndex(1, 8).setText('ASSIGNED_TO_ID');
      sheet.getRangeByIndex(1, 9).setText('ASSIGNED_TO_RANK');
      sheet.getRangeByIndex(1, 10).setText('COMPLETION_DATE');
      sheet.getRangeByIndex(1, 11).setText('ASSIGNED_ON');
      sheet.getRangeByIndex(1, 12).setText('TARGET_DATE');
      sheet.getRangeByIndex(1, 13).setText('ASSIGNED_TO_NAME');
      sheet.getRangeByIndex(1, 14).setText('FIR_REG_NUM');
      sheet.getRangeByIndex(1, 15).setText('LAT');
      sheet.getRangeByIndex(1, 16).setText('LONG');
      sheet.getRangeByIndex(1, 17).setText('LOGIN_ID');
      sheet.getRangeByIndex(1, 18).setText('OFFICER_RANK');
      sheet.getRangeByIndex(1, 19).setText('NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet
            .getRangeByIndex(i + 2, 1)
            .setText((lst[i].FIR_PETTY_CASE_DATE).toString());
        sheet
            .getRangeByIndex(i + 2, 2)
            .setText((lst[i].SUMM_WARR_SR_NUM).toString());
        sheet
            .getRangeByIndex(i + 2, 3)
            .setText((lst[i].EXECUTION_LAST_DT).toString());
        sheet
            .getRangeByIndex(i + 2, 4)
            .setText((lst[i].FIR_PETTY_CASE_NUM).toString());
        sheet
            .getRangeByIndex(i + 2, 5)
            .setText((lst[i].ISSUED_TO_PERSON_NAME).toString());
        sheet
            .getRangeByIndex(i + 2, 6)
            .setText((lst[i].SUMM_WARR_NUM).toString());
        sheet
            .getRangeByIndex(i + 2, 7)
            .setText((lst[i].POLICESTATIONNAME).toString());
        sheet
            .getRangeByIndex(i + 2, 8)
            .setText((lst[i].ASSIGNED_TO_ID).toString());
        sheet
            .getRangeByIndex(i + 2, 9)
            .setText((lst[i].ASSIGNED_TO_RANK).toString());
        sheet
            .getRangeByIndex(i + 2, 10)
            .setText((lst[i].COMPLETION_DATE).toString());
        sheet
            .getRangeByIndex(i + 2, 11)
            .setText((lst[i].ASSIGNED_ON).toString());
        sheet
            .getRangeByIndex(i + 2, 12)
            .setText((lst[i].TARGET_DATE).toString());
        sheet
            .getRangeByIndex(i + 2, 13)
            .setText((lst[i].ASSIGNED_TO_NAME).toString());
        sheet
            .getRangeByIndex(i + 2, 14)
            .setText((lst[i].FIR_REG_NUM).toString());
        sheet.getRangeByIndex(i + 2, 15).setText((lst[i].LAT).toString());
        sheet.getRangeByIndex(i + 2, 16).setText((lst[i].LONG).toString());
        sheet.getRangeByIndex(i + 2, 17).setText((lst[i].LOGIN_ID).toString());
        sheet
            .getRangeByIndex(i + 2, 18)
            .setText((lst[i].OFFICER_RANK).toString());
        sheet.getRangeByIndex(i + 2, 19).setText((lst[i].NAME).toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage(fileName, bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
      workbook.dispose();
    } else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
