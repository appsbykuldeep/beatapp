// ignore_for_file: non_constant_identifier_names

import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class HistorySheetersReportDetailsResponse {
  //@SerializedName("HST_SR_NUM")
  String? hSTSRNUM;

  //@SerializedName("VILL_STREET")
  String? vILLSTREETNAME;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("IS_ACTIVE")
  String? iSACTIVE;

  //@SerializedName("IS_ACTIVE_CODE")
  String? IS_ACTIVE_CODE;

  String? fatherName;

  //@SerializedName("DISTRICT")
  String? DISTRICT;

  //@SerializedName("BEAT_NAME")
  String BEAT_NAME;

  //@SerializedName("PS")
  String? Ps;

//@SerializedName("AREA_NAME")
  String? AREA_NAME;

  HistorySheetersReportDetailsResponse(
      this.hSTSRNUM,
      this.vILLSTREETNAME,
      this.nAME,
      this.iSACTIVE,
      this.IS_ACTIVE_CODE,
      this.fatherName,
      this.DISTRICT,
      this.BEAT_NAME,
      this.Ps,
      this.AREA_NAME);

  factory HistorySheetersReportDetailsResponse.fromJson(json) {
    return HistorySheetersReportDetailsResponse(
        json["HST_SR_NUM"].toString(),
        json["VILL_STREET"],
        json["NAME"],
        json["IS_ACTIVE"],
        json["IS_ACTIVE_CODE"],
        json["FATHER_NAME"],
        json["DISTRICT"],
        json["BEAT_NAME"],
        json["PS"],
        json["AREA_NAME"]);
  }

  static Future<void> generateExcel(
      context, List<HistorySheetersReportDetailsResponse> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('HST_SR_NUM');
      sheet.getRangeByIndex(1, 2).setText('VILL_STREET');
      sheet.getRangeByIndex(1, 3).setText('NAME');
      sheet.getRangeByIndex(1, 4).setText('IS_ACTIVE');
      sheet.getRangeByIndex(1, 5).setText('IS_ACTIVE_CODE');
      sheet.getRangeByIndex(1, 6).setText('FATHER_NAME');
      sheet.getRangeByIndex(1, 7).setText('DISTRICT');
      sheet.getRangeByIndex(1, 8).setText('BEAT_NAME');
      sheet.getRangeByIndex(1, 9).setText('PS');
      sheet.getRangeByIndex(1, 10).setText('AREA_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet
            .getRangeByIndex(i + 2, 1)
            .setText((lst[i].hSTSRNUM ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 2)
            .setText((lst[i].vILLSTREETNAME ?? "").toString());
        sheet.getRangeByIndex(i + 2, 3).setText((lst[i].nAME ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 4)
            .setText((lst[i].iSACTIVE ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 5)
            .setText((lst[i].IS_ACTIVE_CODE ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 6)
            .setText((lst[i].fatherName ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 7)
            .setText((lst[i].DISTRICT ?? "").toString());
        sheet.getRangeByIndex(i + 2, 8).setText((lst[i].BEAT_NAME).toString());
        sheet.getRangeByIndex(i + 2, 9).setText((lst[i].Ps ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 10)
            .setText((lst[i].AREA_NAME ?? "").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage(
          'HSReport', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    } else {
      MessageUtility.showNoDataMsg(context);
    }
  }

  static List<HistorySheetersReportDetailsResponse> getHSListPS(
      String Ps, List<HistorySheetersReportDetailsResponse> inputlist) {
    List<HistorySheetersReportDetailsResponse> outputList =
        inputlist.where((HistorySheetersReportDetailsResponse element) {
      try {
        return element.Ps.toString().trim() == Ps.trim();
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }
}
