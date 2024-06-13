import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class LicenseWeaponListResponse {
  //@SerializedName("WEAPON_SR_NUM")
  String? wEAPONSRNUM;

  //@SerializedName("BEAT_NAME")
  String bEATNAME;

  //@SerializedName("VILL_STREET_NAME")
  String? vILLSTREETNAME;

  //@SerializedName("WEAPON_SUBTYPE")
  String? wEAPONSUBTYPE;

  //@SerializedName("LISCENSE_HOLDER_NAME")
  String? lISCENSEHOLDERNAME;

  //@SerializedName("FATHER_NAME")
  String? fATHERNAME;

  //@SerializedName("RECORD_CREATED_ON")
  String? rECORDCREATEDON;

//@SerializedName("SR_NUM")
  String? SR_NUM;

  //@SerializedName("WEAPON")
  String? WEAPON;

  LicenseWeaponListResponse(
      this.wEAPONSRNUM,
      this.bEATNAME,
      this.vILLSTREETNAME,
      this.wEAPONSUBTYPE,
      this.lISCENSEHOLDERNAME,
      this.fATHERNAME,
      this.rECORDCREATEDON,
      this.SR_NUM,
      this.WEAPON);

  factory LicenseWeaponListResponse.fromJson(json) {
    return LicenseWeaponListResponse(
        json["WEAPON_SR_NUM"].toString(),
        json["BEAT_NAME"] ?? '',
        json["VILL_STREET_NAME"],
        json["WEAPON_SUBTYPE"],
        json["LISCENSE_HOLDER_NAME"],
        json["FATHER_NAME"],
        json["RECORD_CREATED_ON"],
        json["SR_NUM"].toString(),
        json["WEAPON"]);
  }

  static Future<void> generateExcel(
      context, List<LicenseWeaponListResponse> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('WEAPON_SR_NUM');
      sheet.getRangeByIndex(1, 2).setText('BEAT_NAME');
      sheet.getRangeByIndex(1, 3).setText('VILL_STREET_NAME');
      sheet.getRangeByIndex(1, 4).setText('WEAPON_SUBTYPE');
      sheet.getRangeByIndex(1, 5).setText('LISCENSE_HOLDER_NAME');
      sheet.getRangeByIndex(1, 6).setText('FATHER_NAME');
      sheet.getRangeByIndex(1, 7).setText('RECORD_CREATED_ON');
      sheet.getRangeByIndex(1, 8).setText('SR_NUM');
      sheet.getRangeByIndex(1, 9).setText('WEAPON');

      for (int i = 0; i < lst.length; i++) {
        sheet
            .getRangeByIndex(i + 2, 1)
            .setText((lst[i].wEAPONSRNUM ?? "").toString());
        sheet.getRangeByIndex(i + 2, 2).setText((lst[i].bEATNAME).toString());
        sheet
            .getRangeByIndex(i + 2, 3)
            .setText((lst[i].vILLSTREETNAME ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 4)
            .setText((lst[i].wEAPONSUBTYPE ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 5)
            .setText((lst[i].lISCENSEHOLDERNAME ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 6)
            .setText((lst[i].fATHERNAME ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 7)
            .setText((lst[i].rECORDCREATEDON ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 7)
            .setText((lst[i].SR_NUM ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 7)
            .setText((lst[i].WEAPON ?? "").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage(
          'ArmWeapon', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    } else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
