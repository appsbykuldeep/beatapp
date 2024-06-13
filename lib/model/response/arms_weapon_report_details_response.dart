import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ArmsWeaponReportDetailsResponse {
  //@SerializedName("ARM_SR_NUM")
  String? ARM_SR_NUM;

  //@SerializedName("DISTRICT")
  String? DISTRICT;

  //@SerializedName("PS")
  String? PS;

  //@SerializedName("VILL_STREET")
  String? VILL_STREET;

  //@SerializedName("BEAT_NAME")
  String? BEAT_NAME;

  //@SerializedName("LISCENSE_HOLDER_NAME")
  String? LISCENSE_HOLDER_NAME;

  //@SerializedName("FATHER_NAME")
  String? FATHER_NAME;

  ArmsWeaponReportDetailsResponse(
      this.ARM_SR_NUM,
      this.DISTRICT,
      this.PS,
      this.VILL_STREET,
      this.BEAT_NAME,
      this.LISCENSE_HOLDER_NAME,
      this.FATHER_NAME);

  factory ArmsWeaponReportDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ArmsWeaponReportDetailsResponse(
        json["ARM_SR_NUM"].toString(),
        json["DISTRICT"],
        json["PS"],
        json["VILL_STREET"],
        json["BEAT_NAME"],
        json["LISCENSE_HOLDER_NAME"],
        json["FATHER_NAME"]);
  }

  factory ArmsWeaponReportDetailsResponse.emptyData() {
    return ArmsWeaponReportDetailsResponse(
        null, null, null, null, null, null, null);
  }

  static Future<void> generateExcel(
      context, List<ArmsWeaponReportDetailsResponse> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('ARM_SR_NUM');
      sheet.getRangeByIndex(1, 2).setText('DISTRICT');
      sheet.getRangeByIndex(1, 3).setText('PS');
      sheet.getRangeByIndex(1, 4).setText('VILL_STREET');
      sheet.getRangeByIndex(1, 5).setText('BEAT_NAME');
      sheet.getRangeByIndex(1, 6).setText('LISCENSE_HOLDER_NAME');
      sheet.getRangeByIndex(1, 7).setText('FATHER_NAME');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].ARM_SR_NUM??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].DISTRICT??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].PS??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].VILL_STREET??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].BEAT_NAME??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].LISCENSE_HOLDER_NAME??"").toString());
        sheet.getRangeByIndex(i+2, 7).setText((lst[i].FATHER_NAME??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('ArmWeaponReport', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }

  static List<ArmsWeaponReportDetailsResponse> getAWListPS(String Ps, List<ArmsWeaponReportDetailsResponse> inputlist) {
    List<ArmsWeaponReportDetailsResponse> outputList = inputlist.where((ArmsWeaponReportDetailsResponse element) {
      try {
        return element.PS.toString().trim() == Ps.trim();
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }
}
