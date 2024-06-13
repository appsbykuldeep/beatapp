import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class UnassignedDomesticResponse {
  //@SerializedName("DOMESTIC_SR_NUM")
  String beatName;
  String? dOMESTICSRNUM;

  //@SerializedName("APPLICATION_DT")
  String? aPPLICATIONDT;

  //@SerializedName("APPLICANTNAME")
  String? aPPLICANTNAME;

  //@SerializedName("ASSIGN_STATUS")
  String? aSSIGNSTATUS;

  UnassignedDomesticResponse(this.beatName,this.dOMESTICSRNUM, this.aPPLICATIONDT,
      this.aPPLICANTNAME, this.aSSIGNSTATUS);

  factory UnassignedDomesticResponse.fromJson(json) {
    return UnassignedDomesticResponse(json["BEAT_NAME"]??'',json["DOMESTIC_SR_NUM"].toString(),
        json["APPLICATION_DT"], json["APPLICANTNAME"], json["ASSIGN_STATUS"]);
  }


  static List<UnassignedDomesticResponse> getLast15DaysList(List<UnassignedDomesticResponse> inputlist) {
    List<UnassignedDomesticResponse> outputList =
    inputlist.where((UnassignedDomesticResponse element) {
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

  static List<UnassignedDomesticResponse> getLast15To30DaysList(List<UnassignedDomesticResponse> inputlist) {
    List<UnassignedDomesticResponse> outputList =
    inputlist.where((UnassignedDomesticResponse element) {
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

  static List<UnassignedDomesticResponse> getBefore30DaysList(
      List<UnassignedDomesticResponse> inputlist) {
    List<UnassignedDomesticResponse> outputList =
    inputlist.where((UnassignedDomesticResponse element) {
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

  static List<UnassignedDomesticResponse> getDataFromToDateList(String fDate,String tDate,List<UnassignedDomesticResponse> inputlist) {
    List<UnassignedDomesticResponse> outputList = inputlist.where((UnassignedDomesticResponse element) {
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

  static Future<void> generateExcel(
      context, List<UnassignedDomesticResponse> lst) async {
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
      sheet.getRangeByIndex(1, 3).setText('APPLICANTNAME');
      sheet.getRangeByIndex(1, 4).setText('ASSIGN_STATUS');

      for (int i = 0; i < lst.length; i++) {
        sheet
            .getRangeByIndex(i + 2, 1)
            .setText((lst[i].dOMESTICSRNUM ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 2)
            .setText((lst[i].aPPLICATIONDT ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 3)
            .setText((lst[i].aPPLICANTNAME ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 4)
            .setText((lst[i].aSSIGNSTATUS ?? "").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage(
          'UnassignedDomesticVerification', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    } else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
