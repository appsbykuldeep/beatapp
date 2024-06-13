import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class SharedInformation {
  //@SerializedName("INFO_SR_NUM")
  String beatName;
  String? infoSrNum;

  //@SerializedName("DISTRICT")
  String? district;

  //@SerializedName("PS")
  String? ps;

  //@SerializedName("IS_INFO")
  String? isInfo;

  //@SerializedName("IS_HENIOUS")
  String? isHenous;

  //@SerializedName("LATITUDE")
  String? latitude;

  //@SerializedName("LONGITUDE")
  String? longitude;

  //@SerializedName("INFO_DETAIL")
  String? infoDetails;

  //@SerializedName("INFORMATION_INCIDENT_TYPE")
  String? infoIncidentType;

  //@SerializedName("PERSON_NAME")
  String? personName;

  //@SerializedName("OFFICER_RANK")
  String? officerRank;

  //@SerializedName("FILE_NAME")
  String? fileName;

  //@SerializedName("FILEDETAIL")
  String? fileDetail;

  //@SerializedName("SHARED_INFO_DATE")
  String? dateTime;

  //@SerializedName("IS_FOR_ALL_BEATS")
  String? isAll;

  SharedInformation(
      this.beatName,
      this.infoSrNum,
      this.district,
      this.ps,
      this.isInfo,
      this.isHenous,
      this.latitude,
      this.longitude,
      this.infoDetails,
      this.infoIncidentType,
      this.personName,
      this.officerRank,
      this.fileName,
      this.fileDetail,
      this.dateTime,
      this.isAll);

  factory SharedInformation.fromJson(json) {
    return SharedInformation(
        json["BEAT_NAME"]??'',
        json["INFO_SR_NUM"].toString(),
        json["DISTRICT"].toString(),
        json["PS"].toString(),
        json["IS_INFO"].toString(),
        json["IS_HENIOUS"].toString(),
        json["LATITUDE"].toString(),
        json["LONGITUDE"].toString(),
        json["INFO_DETAIL"].toString(),
        json["INFORMATION_INCIDENT_TYPE"].toString(),
        json["PERSON_NAME"].toString(),
        json["OFFICER_RANK"].toString(),
        json["FILE_NAME"].toString(),
        json["FILEDETAIL"],
        json["SHARED_INFO_DATE"].toString(),
        json["IS_FOR_ALL_BEATS"].toString());
  }

  static Future<void> generateExcel(
      context, List<SharedInformation> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('INFO_SR_NUM');
      sheet.getRangeByIndex(1, 2).setText('DISTRICT');
      sheet.getRangeByIndex(1, 3).setText('PS');
      sheet.getRangeByIndex(1, 4).setText('IS_INFO');
      sheet.getRangeByIndex(1, 5).setText('IS_HENIOUS');
      sheet.getRangeByIndex(1, 6).setText('LATITUDE');
      sheet.getRangeByIndex(1, 7).setText('LONGITUDE');
      sheet.getRangeByIndex(1, 8).setText('INFO_DETAIL');
      sheet.getRangeByIndex(1, 9).setText('INFORMATION_INCIDENT_TYPE');
      sheet.getRangeByIndex(1, 10).setText('PERSON_NAME');
      sheet.getRangeByIndex(1, 11).setText('OFFICER_RANK');
      sheet.getRangeByIndex(1, 12).setText('SHARED_INFO_DATE');
      sheet.getRangeByIndex(1, 13).setText('IS_FOR_ALL_BEATS');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].infoSrNum??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].district??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].ps??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].isInfo??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].isHenous??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].latitude??"").toString());
        sheet.getRangeByIndex(i+2, 7).setText((lst[i].longitude??"").toString());
        sheet.getRangeByIndex(i+2, 8).setText((lst[i].infoDetails??"").toString());
        sheet.getRangeByIndex(i+2, 9).setText((lst[i].infoIncidentType??"").toString());
        sheet.getRangeByIndex(i+2, 10).setText((lst[i].personName??"").toString());
        sheet.getRangeByIndex(i+2, 11).setText((lst[i].officerRank??"").toString());
        sheet.getRangeByIndex(i+2, 12).setText((lst[i].dateTime??"").toString());
        sheet.getRangeByIndex(i+2, 13).setText((lst[i].isAll??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('ShareInfo', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
