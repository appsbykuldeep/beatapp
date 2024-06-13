import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CsEoActionListResponse {
  //@SerializedName("SERVICE_TYPE")
  String? sERVICETYPE;
  String beatName;

  //@SerializedName("SERVICE_NAME")
  String? sERVICENAME;

  //@SerializedName("APPLICATION_SR_NUM")
  String? aPPLICATIONSRNUM;

  //@SerializedName("REQUESTER_NAME")
  String? rEQUESTERNAME;

  //@SerializedName("APPLICATION_DT")
  String? aPPLICATIONDT;

  //@SerializedName("COMPL_DT")
  String? cOMPLDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  CsEoActionListResponse(this.sERVICETYPE,
      this.sERVICENAME,
      this.beatName,
      this.aPPLICATIONSRNUM,
      this.rEQUESTERNAME,
      this.aPPLICATIONDT,
      this.cOMPLDT,
      this.bEATCONSTABLENAME);

  factory CsEoActionListResponse.fromJson(json) {
    return CsEoActionListResponse(
        json["SERVICE_TYPE"].toString(),
        json["SERVICE_NAME"],
        json["BEAT_NAME"]??'',
        json["APPLICATION_SR_NUM"].toString(),
        json["REQUESTER_NAME"],
        json["APPLICATION_DT"],
        json["COMPL_DT"],
        json["BEAT_CONSTABLE_NAME"]);
  }

  static List<CsEoActionListResponse> getLast15DaysList(
      List<CsEoActionListResponse> inputlist) {
    List<CsEoActionListResponse> outputList =
        inputlist.where((CsEoActionListResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.aPPLICATIONDT.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CsEoActionListResponse> getLast15To30DaysList(
      List<CsEoActionListResponse> inputlist) {
    List<CsEoActionListResponse> outputList =
        inputlist.where((CsEoActionListResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.aPPLICATIONDT.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CsEoActionListResponse> getBefore30DaysList(
      List<CsEoActionListResponse> inputlist) {
    List<CsEoActionListResponse> outputList =
        inputlist.where((CsEoActionListResponse element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.aPPLICATIONDT.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CsEoActionListResponse> getDataFromToDateList(String fDate,String tDate,List<CsEoActionListResponse> inputlist) {
    List<CsEoActionListResponse> outputList = inputlist.where((CsEoActionListResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.aPPLICATIONDT.toString());
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

  static Future<void> generateExcelUnAssigned(
      context, List<CsEoActionListResponse> lst) async {
    if (lst.isNotEmpty) {
      DialogHelper.showLoaderDialog(context);
      //Creating a workbook.
      final Workbook workbook = Workbook();
      //Accessing via index
      final Worksheet sheet = workbook.worksheets[0];
      sheet.showGridlines = true;

      // Enable calculation for worksheet.
      JsonToExcel.setExcelStyle(sheet);

      sheet.getRangeByIndex(1, 1).setText('SERVICE TYPE');
      sheet.getRangeByIndex(1, 2).setText('SERVICE NAME');
      sheet.getRangeByIndex(1, 3).setText('APPLICATION SR NUM');
      sheet.getRangeByIndex(1, 4).setText('REQUESTER NAME');
      sheet.getRangeByIndex(1, 5).setText('APPLICATION DATE');
      sheet.getRangeByIndex(1, 6).setText('COMPLETED DATE');
      sheet.getRangeByIndex(1, 7).setText('BEAT CONSTABLE NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet
            .getRangeByIndex(i + 2, 1)
            .setText((lst[i].sERVICETYPE ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 2)
            .setText((lst[i].sERVICENAME ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 3)
            .setText((lst[i].aPPLICATIONSRNUM ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 4)
            .setText((lst[i].rEQUESTERNAME).toString());
        sheet
            .getRangeByIndex(i + 2, 5)
            .setText((lst[i].aPPLICATIONDT ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 6)
            .setText((lst[i].cOMPLDT ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 7)
            .setText((lst[i].bEATCONSTABLENAME ?? "").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage(
          'UnassignedCharacterCert', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    } else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
