import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class AreaResponse {
  //@SerializedName("AREA_SR_NUM")
  String? aREASRNUM;

  //@SerializedName("AREA_NAME")
  String? aREANAME;

  //@SerializedName("CREATED_DATE")
  String? cREATEDDATE;

  AreaResponse(this.aREASRNUM, this.aREANAME, this.cREATEDDATE);

  factory AreaResponse.fromJson(Map<String, dynamic> json) {
    return AreaResponse(
        json["AREA_SR_NUM"].toString(), json["AREA_NAME"], json["CREATED_DATE"]);
  }

  static Future<void> generateExcel(
      context, List<AreaResponse> lst) async {
    DialogHelper.showLoaderDialog(context);
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();
    JsonToExcel.setExcelStyle(sheet);

    sheet.getRangeByIndex(1, 1).setText('AREA SR NUM');
    sheet.getRangeByIndex(1, 2).setText('AREA NAME');
    sheet.getRangeByIndex(1, 3).setText('CREATED DATE');

    for (int i = 0; i < lst.length; i++) {
      sheet
          .getRangeByIndex(i + 2, 1)
          .setText((lst[i].aREASRNUM ?? "").toString());
      sheet.getRangeByIndex(i + 2, 2).setText(
          (lst[i].aREANAME ??"").toString());
      sheet
          .getRangeByIndex(i + 2, 3)
          .setText((lst[i].cREATEDDATE ?? "").toString());
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    Navigator.pop(context);

    //Save and launch the file.
    await CameraAndFileProvider.saveBytesInStorage('Area', bytes, ".xlsx");
    MessageUtility.showDownloadCompleteMsg(context);
  }
  
}
