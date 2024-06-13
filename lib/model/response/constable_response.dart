import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ConstableResponse {
  //@SerializedName("BEAT_PERSON_SR_NUM")
  String? BEAT_PERSON_SR_NUM;

  //@SerializedName("DISTRICT")
  String? DISTRICT;

  //@SerializedName("PS")
  String? PS;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? BEAT_CONSTABLE_NAME;

  //@SerializedName("MOBILE")
  String? MOBILE;

  //@SerializedName("OFFICER_RANK")
  String? OFFICER_RANK;

  //@SerializedName("PNO")
  String? PNO;

  //@SerializedName("OFFICER_RANK_CD")
  String? OFFICER_RANK_CD;

  String? LANG_CD;

  ConstableResponse(
      this.BEAT_PERSON_SR_NUM,
      this.DISTRICT,
      this.PS,
      this.BEAT_CONSTABLE_NAME,
      this.MOBILE,
      this.OFFICER_RANK,
      this.PNO,
      this.OFFICER_RANK_CD,
      this.LANG_CD);

  factory ConstableResponse.fromJson(json) {
    return ConstableResponse(
        json["BEAT_PERSON_SR_NUM"].toString(),
        json["DISTRICT"].toString(),
        json["PS"].toString(),
        json["BEAT_CONSTABLE_NAME"].toString(),
        json["MOBILE"].toString(),
        json["OFFICER_RANK"].toString(),
        json["PNO"].toString(),
        json["OFFICER_RANK_CD"].toString(),
        "");
  }

  factory ConstableResponse.fromRankJson(json) {
    return ConstableResponse(
        "",
        "",
        "",
        "",
        "",
        json["OFFICER_RANK"].toString(),
        "",
        json["OFFICER_RANK_CD"].toString(),
        json["LANG_CD"].toString());
  }

  static Future<void> generateExcel(
      context, List<ConstableResponse> lst) async {
    DialogHelper.showLoaderDialog(context);
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();
    JsonToExcel.setExcelStyle(sheet);

    sheet.getRangeByIndex(1, 1).setText('BEAT PERSON SR NUM');
    sheet.getRangeByIndex(1, 2).setText('DISTRICT');
    sheet.getRangeByIndex(1, 3).setText('Police Station');
    sheet.getRangeByIndex(1, 4).setText('BEAT CONSTABLE NAME');
    sheet.getRangeByIndex(1, 5).setText('MOBILE');
    sheet.getRangeByIndex(1, 6).setText('OFFICER RANK');
    sheet.getRangeByIndex(1, 7).setText('PNO');

    for (int i = 0; i < lst.length; i++) {
      sheet
          .getRangeByIndex(i + 2, 1)
          .setText((lst[i].BEAT_PERSON_SR_NUM ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 2)
          .setText((lst[i].DISTRICT ?? "").toString());
      sheet.getRangeByIndex(i + 2, 3).setText((lst[i].PS ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 4)
          .setText((lst[i].BEAT_CONSTABLE_NAME ?? "").toString());
      sheet.getRangeByIndex(i + 2, 5).setText((lst[i].MOBILE ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 6)
          .setText((lst[i].OFFICER_RANK ?? "").toString());
      sheet.getRangeByIndex(i + 2, 7).setText((lst[i].PNO ?? "").toString());
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    Navigator.pop(context);

    //Save and launch the file.
    await CameraAndFileProvider.saveBytesInStorage('Beat', bytes, ".xlsx");
    MessageUtility.showDownloadCompleteMsg(context);
  }

  static List<ConstableResponse> getAllRanks(context) {
    List<ConstableResponse> list = [];
    list.add(ConstableResponse.fromJson(
        {"OFFICER_RANK_CD": 13, "OFFICER_RANK": "आरक्षी", "LANG_CD": 6}));
    list.add(ConstableResponse.fromJson(
        {"OFFICER_RANK_CD": 12, "OFFICER_RANK": "मुख्य-आरक्षी", "LANG_CD": 6}));
    list.add(ConstableResponse.fromJson(
        {"OFFICER_RANK_CD": 10, "OFFICER_RANK": "उपनिरीक्षक", "LANG_CD": 6}));
    list.add(ConstableResponse.fromJson(
        {"OFFICER_RANK_CD": 11, "OFFICER_RANK": "निरीक्षक", "LANG_CD": 6}));
    return list;
  }

  static bool checkHardCodedRank(String rankid, String rankName) {
    if (rankid == "13" &&
        (rankName.contains("आरक्षी") || rankName.contains("पुलिस सिपाही"))) {
      return true;
    } else if (rankid == "12" &&
        (rankName == "मुख्य आरक्षी" ||
            rankName.contains("प्रधान सिपाही"))) {
      return true;
    } else if (rankid == "10" &&
        (rankName == "उप-निरीक्षक" ||
            rankName.contains("उपनिरीक्षक/ अवर निरीक्षक"))) {
      return true;
    } else if (rankid == "11" && rankName == "सहायक उप-निरीक्षक") {
      return true;
    } else {
      return false;
    }
  }

//[{OFFICER_RANK_CD: 10, OFFICER_RANK: उपनिरीक्षक/ अवर निरीक्षक, LANG_CD: 6}, {OFFICER_RANK_CD: 12, OFFICER_RANK: प्रधान सिपाही, LANG_CD: 6}, {OFFICER_RANK_CD: 13, OFFICER_RANK: पुलिस सिपाही, LANG_CD: 6}, {OFFICER_RANK_CD: 11, OFFICER_RANK: सहायकउप - निरीक्षक, LANG_CD: 6}]
}
