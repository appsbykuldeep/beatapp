import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CitizenServicesStatusResponse {
  //@SerializedName("USER_ROLE")
  String? uSERROLE;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("CVR_STATUS")
  String? cVRSTATUS;

  //@SerializedName("EMPLOYEE_STATUS")
  String? eMPLOYEESTATUS;

  //@SerializedName("TENANT_STATUS")
  String? tENANTSTATUS;

  //@SerializedName("DOMESTIC_STATUS")
  String? dOMESTICSTATUS;

  //@SerializedName("CSI_STATUS")
  String? cSISTATUS;

  CitizenServicesStatusResponse(
      this.uSERROLE,
      this.nAME,
      this.cVRSTATUS,
      this.eMPLOYEESTATUS,
      this.tENANTSTATUS,
      this.dOMESTICSTATUS,
      this.cSISTATUS);

  factory CitizenServicesStatusResponse.fromJson(Map<String, dynamic> json) {
    return CitizenServicesStatusResponse(
        json["USER_ROLE"],
        json["NAME"],
        json["CVR_STATUS"].toString(),
        json["EMPLOYEE_STATUS"].toString(),
        json["TENANT_STATUS"].toString(),
        json["DOMESTIC_STATUS"].toString(),
        json["CSI_STATUS"].toString());
  }

  static Future<void> generateExcel(
      context, List<CitizenServicesStatusResponse> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('USER_ROLE');
      sheet.getRangeByIndex(1, 2).setText('NAME');
      sheet.getRangeByIndex(1, 3).setText('CVR_STATUS');
      sheet.getRangeByIndex(1, 4).setText('EMPLOYEE_STATUS');
      sheet.getRangeByIndex(1, 5).setText('TENANT_STATUS');
      sheet.getRangeByIndex(1, 6).setText('DOMESTIC_STATUS');
      sheet.getRangeByIndex(1, 7).setText('CSI_STATUS');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].uSERROLE??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].nAME??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].cVRSTATUS??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].eMPLOYEESTATUS??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].tENANTSTATUS??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].dOMESTICSTATUS??"").toString());
        sheet.getRangeByIndex(i+2, 7).setText((lst[i].cSISTATUS??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('CompletedDomesticVerification', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }

  static List<CitizenServicesStatusResponse> getAWListPS(String Ps, List<CitizenServicesStatusResponse> inputlist) {
    List<CitizenServicesStatusResponse> outputList = inputlist.where((CitizenServicesStatusResponse element) {
      try {
        return element.eMPLOYEESTATUS.toString().trim() == Ps.trim();
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }
}
