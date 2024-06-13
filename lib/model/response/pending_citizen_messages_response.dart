import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class PendingCitizenMessagesResponse {
  //@SerializedName("PERSON_ID")
  String? pERSONID;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("COMPLAINANT NAME")
  String? cOMPLAINANTNAME;

  //@SerializedName("EO_NAME")
  String? eONAME;

  PendingCitizenMessagesResponse(
      this.pERSONID,
      this.rEGISTEREDDT,
      this.aSSIGNEDDT,
      this.tARGETDT,
      this.bEATCONSTABLENAME,
      this.cOMPLAINANTNAME,
      this.eONAME);

  factory PendingCitizenMessagesResponse.fromJson(json) {
    return PendingCitizenMessagesResponse(
        json["PERSON_ID"].toString(),
        json["REGISTERED_DT"],
        json["ASSIGNED_DT"],
        json["TARGET_DT"],
        json["BEAT_CONSTABLE_NAME"],
        json["COMPLAINANT NAME"],
        json["EO_NAME"]);
  }

  static List<PendingCitizenMessagesResponse> getLast15DaysList(
      List<PendingCitizenMessagesResponse> inputlist) {
    List<PendingCitizenMessagesResponse> outputList = inputlist.where((PendingCitizenMessagesResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.rEGISTEREDDT.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<PendingCitizenMessagesResponse> getLast15To30DaysList(
      List<PendingCitizenMessagesResponse> inputlist) {
    List<PendingCitizenMessagesResponse> outputList = inputlist.where((PendingCitizenMessagesResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.rEGISTEREDDT.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<PendingCitizenMessagesResponse> getBefore30DaysList(
      List<PendingCitizenMessagesResponse> inputlist) {
    List<PendingCitizenMessagesResponse> outputList = inputlist.where((PendingCitizenMessagesResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.rEGISTEREDDT.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<PendingCitizenMessagesResponse> getDataFromToDateList(String fDate,String tDate,List<PendingCitizenMessagesResponse> inputlist) {
    List<PendingCitizenMessagesResponse> outputList = inputlist.where((PendingCitizenMessagesResponse element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.rEGISTEREDDT.toString());
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
      context, List<PendingCitizenMessagesResponse> lst,String fileName) async {
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

      sheet.getRangeByIndex(1, 1).setText('PERSON_ID');
      sheet.getRangeByIndex(1, 2).setText('REGISTERED_DT');
      sheet.getRangeByIndex(1, 3).setText('ASSIGNED_DT');
      sheet.getRangeByIndex(1, 4).setText('TARGET_DT');
      sheet.getRangeByIndex(1, 5).setText('BEAT_CONSTABLE_NAME');
      sheet.getRangeByIndex(1, 6).setText('COMPLAINANT');
      sheet.getRangeByIndex(1, 7).setText('EO_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].pERSONID??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].rEGISTEREDDT??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].aSSIGNEDDT??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].tARGETDT??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].bEATCONSTABLENAME??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].cOMPLAINANTNAME??"").toString());
        sheet.getRangeByIndex(i+2, 7).setText((lst[i].eONAME??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage(fileName, bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
