import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class VillageBeatDetailsResponse {
  //@SerializedName("VILL_STR_SR_NUM")
  String? VILL_STR_SR_NUM;

  //@SerializedName("DISTRICT")
  String? DISTRICT;

  //@SerializedName("PS")
  String? PS;

  //@SerializedName("VILL_STREET")
  String? VILL_STREET;

  //@SerializedName("VILL_STREET_ENGLISH")
  String? VILL_STREET_ENGLISH;

  //@SerializedName("VILL_STREET_HINDI")
  String? VILL_STREET_HINDI;

  //@SerializedName("REGIONAL_NAME")
  String? REGIONAL_NAME;

  //@SerializedName("ENGLISH_NAME")
  String? ENGLISH_NAME;

  //@SerializedName("IS_VILLAGE")
  String? IS_VILLAGE;

  //@SerializedName("BEAT_NAME_HINDI")
  String? BEAT_NAME_HINDI;

  //@SerializedName("BEAT_NAME_ENGLISH")
  String? BEAT_NAME_ENGLISH;

  //@SerializedName("BEAT_CD")
  String? BEAT_CD;

  VillageBeatDetailsResponse(this.VILL_STR_SR_NUM,
      this.DISTRICT,
      this.PS,
      this.VILL_STREET,
      this.VILL_STREET_ENGLISH,
      this.VILL_STREET_HINDI,
      this.REGIONAL_NAME,
      this.ENGLISH_NAME,
      this.IS_VILLAGE,
      this.BEAT_NAME_HINDI,
      this.BEAT_NAME_ENGLISH,
      this.BEAT_CD);

  factory VillageBeatDetailsResponse.fromJson(json) {
    return VillageBeatDetailsResponse(
        json["VILL_STR_SR_NUM"].toString(),
        json["DISTRICT"],
        json["PS"],
        json["VILL_STREET"],
        json["VILL_STREET_ENGLISH"],
        json["VILL_STREET_HINDI"],
        json["REGIONAL_NAME"],
        json["ENGLISH_NAME"],
        json["IS_VILLAGE"],
        json["BEAT_NAME_HINDI"],
        json["BEAT_NAME_ENGLISH"],
        json["BEAT_CD"].toString());
  }

  static Future<void> generateExcelBeat(
      context, List<VillageBeatDetailsResponse> lstBeat) async {
    DialogHelper.showLoaderDialog(context);
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();
    final Range range6 = sheet.getRangeByName('A1:C1');
    range6.cellStyle.fontSize = 10;
    range6.columnWidth = 20;
    range6.cellStyle.bold = true;

    sheet.getRangeByIndex(1, 1).setText('BEAT_CD');
    sheet.getRangeByIndex(1, 2).setText('BEAT_NAME_HINDI');
    sheet.getRangeByIndex(1, 3).setText('BEAT_NAME_ENGLISH');

    for (int i = 0; i < lstBeat.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(lstBeat[i].BEAT_CD.toString());
      sheet
          .getRangeByIndex(i + 2, 2)
          .setText(lstBeat[i].BEAT_NAME_HINDI.toString());
      sheet
          .getRangeByIndex(i + 2, 3)
          .setText(lstBeat[i].BEAT_NAME_ENGLISH.toString());
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    Navigator.pop(context);

    //Save and launch the file.
    await CameraAndFileProvider.saveBytesInStorage('Beat', bytes, ".xlsx");
    MessageUtility.showToastOnTop(
        context, "Report Downloaded into Download Folder");
  }

  static Future<void> generateExcelVillage(
      context, List<VillageBeatDetailsResponse> lstVillage) async {
    DialogHelper.showLoaderDialog(context);
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();
    JsonToExcel.setExcelStyle(sheet);

    sheet.getRangeByIndex(1, 1).setText('VILL STR SR NUM');
    sheet.getRangeByIndex(1, 2).setText('VILLAGE/Street');
    sheet.getRangeByIndex(1, 3).setText('HINDI NAME');
    sheet.getRangeByIndex(1, 4).setText('ENGLISH NAME');

    for (int i = 0; i < lstVillage.length; i++) {
      sheet
          .getRangeByIndex(i + 2, 1)
          .setText((lstVillage[i].VILL_STR_SR_NUM ?? "").toString());
      sheet.getRangeByIndex(i + 2, 2).setText(
          (lstVillage[i].IS_VILLAGE == "Y" ? "Village" : "Street").toString());
      sheet
          .getRangeByIndex(i + 2, 3)
          .setText((lstVillage[i].REGIONAL_NAME ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 4)
          .setText((lstVillage[i].ENGLISH_NAME ?? "").toString());
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    Navigator.pop(context);

    //Save and launch the file.
    await CameraAndFileProvider.saveBytesInStorage('Village', bytes, ".xlsx");
    MessageUtility.showToastOnTop(
        context, "Report Downloaded into Download Folder");
  }

  static List<VillageBeatDetailsResponse> getListByPS(String Ps, List<VillageBeatDetailsResponse> inputlist) {
    List<VillageBeatDetailsResponse> outputList = inputlist.where((VillageBeatDetailsResponse element) {
      try {
        return element.PS.toString().trim() == Ps.trim();
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }
}
