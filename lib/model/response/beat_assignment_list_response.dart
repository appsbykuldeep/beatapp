import 'package:beatapp/model/response/get_constable_details.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class BeatAssignmentListResponse {
  //@SerializedName("DISTRICT")
  String? district;

  //@SerializedName("PS")
  String? ps;

  //@SerializedName("BEAT_NAME")
  String? beatName;

  //@SerializedName("BEAT_CD")
  String? beatCd;

  //@SerializedName("SHO_DETAIL")
  String? shoDetails;

  //@SerializedName("ROASTER_SR_NUM")
  String? roasterSrNum;

  //@SerializedName("SHO_CUG")
  String? shoCug;

  //@SerializedName("ASSIGNMENT_DT")
  String? assignmentDt;

  //@SerializedName("BEAT_PERSON_DETAILS")
  String? beatPersonDetails;

  //@SerializedName("AREA")
  String? area;

  String? beatCUG;
  String? beatOfficerName;
  String? beatRank;
  int? itemType;

  BeatAssignmentListResponse(this.district,
      this.ps,
      this.beatName,
      this.beatCd,
      this.shoDetails,
      this.roasterSrNum,
      this.shoCug,
      this.assignmentDt,
      this.beatPersonDetails,
      this.area,
      this.beatCUG,
      this.beatOfficerName,
      this.beatRank,
      this.itemType);

  BeatAssignmentListResponse copy() {
    BeatAssignmentListResponse newItem = BeatAssignmentListResponse(
        district,
        ps,
        beatName,
        beatCd,
        shoDetails,
        roasterSrNum,
        shoCug,
        assignmentDt,
        beatPersonDetails,
        area,
        beatCUG,
        beatOfficerName,
        beatRank,
        itemType);
    return newItem;
  }

  factory BeatAssignmentListResponse.fromJson(Map<String, dynamic> json) {
    return BeatAssignmentListResponse(
        json["DISTRICT"],
        json["PS"],
        json["BEAT_NAME"],
        json["BEAT_CD"].toString(),
        json["SHO_DETAIL"],
        json["ROASTER_SR_NUM"].toString(),
        json["SHO_CUG"].toString(),
        json["ASSIGNMENT_DT"],
        json["BEAT_PERSON_DETAILS"],
        json["AREA"],
        json["beatCUG"].toString(),
        json["beatOfficerName"],
        json["beatRank"],
        json["itemType"]);
  }

  static Future<void> generateExcel(
      context, List<BeatAssignmentListResponse> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('ROASTER SR NUM');
      sheet.getRangeByIndex(1, 2).setText('DISTRICT');
      sheet.getRangeByIndex(1, 3).setText('PS');
      sheet.getRangeByIndex(1, 4).setText('BEAT NAME');
      sheet.getRangeByIndex(1, 5).setText('SHO DETAIL');
      sheet.getRangeByIndex(1, 6).setText('SHO CUG');
      sheet.getRangeByIndex(1, 7).setText('ASSIGNMENT DT');
      sheet.getRangeByIndex(1, 8).setText('BEAT PERSON DETAILS');
      sheet.getRangeByIndex(1, 8).columnWidth = 50;
      sheet.getRangeByIndex(1, 8).autoFitRows();

      for (int i = 0; i < lst.length; i++) {
        sheet
            .getRangeByIndex(i+2, 1)
            .setText((lst[i].roasterSrNum ?? "").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].district ?? "").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].ps ?? "").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].beatName ?? "").toString());
        sheet.getRangeByIndex(i+2, 5).setText(
            (lst[i].shoDetails ?? "").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].shoCug ?? "").toString());
        sheet
            .getRangeByIndex(i+2, 7)
            .setText((lst[i].assignmentDt ?? "").toString());
        String pD = GetConstableDetails.fromStringToString(lst[i].beatPersonDetails!);
        sheet.getRangeByIndex(i+2, 8).setText(pD);
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('BeatAssign', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }

  static List<BeatAssignmentListResponse> getListAcordPS(String Ps, List<BeatAssignmentListResponse> inputlist) {
    List<BeatAssignmentListResponse> outputList = inputlist.where((BeatAssignmentListResponse element) {
      try {
        return element.ps.toString().trim() == Ps.trim();
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }
}
