import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class HistorySheetersDetailsResponse {
  //@SerializedName("HST_SR_NUM")
  String? hSTSRNUM;

  //@SerializedName("VILL_STREET_NAME")
  String? vILLSTREETNAME;

  //@SerializedName("VILL_STREET")
  String? VILL_STREET;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("IS_ACTIVE")
  String? iSACTIVE;

  //@SerializedName("RECORD_CREATED_ON")
  String? rECORDCREATEDON;

  //@SerializedName("VERIFICATION_STATUS")
  String? VERIFICATION_STATUS;

  //@SerializedName("VERIFICATION_STATUS_CODE")
  String? VERIFICATION_STATUS_CODE;

  //@SerializedName("PENDING_TYPE")
  String? PENDING_TYPE;

  String BEAT_NAME;

  String? ROUTINE_VERIFICATION_STATUS;
  String? ROUTINE_VERIFICATION_DATE;
  String? ROUTINE_VERIFICATION_DAYS;

  HistorySheetersDetailsResponse(this.hSTSRNUM,
      this.vILLSTREETNAME,
      this.VILL_STREET,
      this.nAME,
      this.iSACTIVE,
      this.rECORDCREATEDON,
      this.VERIFICATION_STATUS,
      this.VERIFICATION_STATUS_CODE,
      this.PENDING_TYPE,
      this.BEAT_NAME,
      this.ROUTINE_VERIFICATION_STATUS,
      this.ROUTINE_VERIFICATION_DATE,
      this.ROUTINE_VERIFICATION_DAYS
      );

  factory HistorySheetersDetailsResponse.fromJson(json) {
    return HistorySheetersDetailsResponse(
        json["HST_SR_NUM"].toString(),
        json["VILL_STREET_NAME"],
        json["VILL_STREET"],
        json["NAME"],
        json["IS_ACTIVE"],
        json["RECORD_CREATED_ON"],
        json["VERIFICATION_STATUS"],
        json["VERIFICATION_STATUS_CODE"],
        json["PENDING_TYPE"],
        json["BEAT_NAME"]??'',
        json["ROUTINE_VERIFICATION_STATUS"],
        json["ROUTINE_VERIFICATION_DATE"],
        json["ROUTINE_VERIFICATION_DAYS"].toString()
    );
  }

  static Future<void> generateExcel(
      context, List<HistorySheetersDetailsResponse> lst) async {
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
      sheet.getRangeByIndex(1, 2).setText('VILL_STREET_NAME');
      sheet.getRangeByIndex(1, 3).setText('VILL_STREET');
      sheet.getRangeByIndex(1, 4).setText('NAME');
      sheet.getRangeByIndex(1, 5).setText('IS_ACTIVE');
      sheet.getRangeByIndex(1, 6).setText('RECORD_CREATED_ON');
      sheet.getRangeByIndex(1, 7).setText('VERIFICATION_STATUS');
      sheet.getRangeByIndex(1, 8).setText('VERIFICATION_STATUS_CODE');
      sheet.getRangeByIndex(1, 9).setText('PENDING_TYPE');

      for (int i = 0; i < lst.length; i++) {
        sheet
            .getRangeByIndex(i + 2, 1)
            .setText((lst[i].hSTSRNUM ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 2)
            .setText((lst[i].vILLSTREETNAME ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 3)
            .setText((lst[i].vILLSTREETNAME ?? "").toString());
        sheet.getRangeByIndex(i + 2, 4).setText((lst[i].nAME ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 5)
            .setText((lst[i].iSACTIVE ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 6)
            .setText((lst[i].rECORDCREATEDON ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 7)
            .setText((lst[i].VERIFICATION_STATUS ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 8)
            .setText((lst[i].VERIFICATION_STATUS_CODE ?? "").toString());
        sheet
            .getRangeByIndex(i + 2, 9)
            .setText((lst[i].PENDING_TYPE ?? "").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('HST', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    } else {
      MessageUtility.showNoDataMsg(context);
    }
  }

  static sortByAss(List<HistorySheetersDetailsResponse> lst, bool type) {
    lst.sort((a, b) => type
        ? a.BEAT_NAME.compareTo(b.BEAT_NAME)
        : b.BEAT_NAME.compareTo(a.BEAT_NAME));
  }

  static List<HistorySheetersDetailsResponse> getActiveList(List<HistorySheetersDetailsResponse> inputlist) {
    List<HistorySheetersDetailsResponse> outputList = inputlist.where((HistorySheetersDetailsResponse element) {
      try {
        return element.iSACTIVE == "सक्रिय";
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<HistorySheetersDetailsResponse> getInActiveList(List<HistorySheetersDetailsResponse> inputlist) {
    List<HistorySheetersDetailsResponse> outputList = inputlist.where((HistorySheetersDetailsResponse element) {
      try {
        return element.iSACTIVE == "निष्क्रिय";
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }
}
