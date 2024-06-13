import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class Arrest {
  //@SerializedName("FIR_DATE")
  String beatName;
  String? firDate;

  //@SerializedName("FIR_REG_NUM")
  String? firRegNum;

  //@SerializedName("ACCUSED_SRNO")
  String? accusedSrNo;

  //@SerializedName("ACCUSED_NAME")
  String? accusedName;

  //@SerializedName("ACCUSED_PRESENT_ADDRESS")
  String? accusedPresentAddress;

  //@SerializedName("ACCUSED_PERMANENT_ADDRESS")
  String? accusedPermanentAddress;

  //@SerializedName("ASSIGNED_TO_NAME")
  String? assignedTo;

  //@SerializedName("ASSIGN_DT")
  String? assignDate;

  //@SerializedName("TARGET_DT")
  String? targetDate;

  //@SerializedName("MOBILE")
  String? mobile;

  //@SerializedName("FIR_NUM")
  String? firNum;

  //@SerializedName("REMARKS")
  String? remark;

  //@SerializedName("IS_ARRESTED")
  String? isArrested;

  //@SerializedName("PHOTO")
  String? photo;

  //@SerializedName("ACT_SECTION")
  String? actSection;

  Arrest(
      this.beatName,
      this.firDate,
      this.firRegNum,
      this.accusedSrNo,
      this.accusedName,
      this.accusedPresentAddress,
      this.accusedPermanentAddress,
      this.assignedTo,
      this.assignDate,
      this.targetDate,
      this.mobile,
      this.firNum,
      this.remark,
      this.isArrested,
      this.photo,
      this.actSection);

  factory Arrest.fromJson(json) {
    return Arrest(
        json["BEAT_NAME"]??'',
        json["FIR_DATE"],
        json["FIR_REG_NUM"].toString(),
        json["ACCUSED_SRNO"].toString(),
        json["ACCUSED_NAME"],
        json["ACCUSED_PRESENT_ADDRESS"],
        json["ACCUSED_PERMANENT_ADDRESS"],
        json["ASSIGNED_TO_NAME"],
        json["ASSIGN_DT"],
        json["TARGET_DT"],
        json["MOBILE"],
        json["FIR_NUM"],
        json["REMARKS"],
        json["IS_ARRESTED"],
        json["PHOTO"],
        json["ACT_SECTION"]);
  }

  List<Arrest> getCategoryList(List<Arrest> inputlist) {
    List<Arrest> outputList =
        inputlist.where((o) => o.isArrested == 'Y').toList();
    return outputList;
  }

  static List<Arrest> getLast15DaysList(List<Arrest> inputlist) {
    List<Arrest> outputList = inputlist.where((Arrest element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.firDate.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<Arrest> getLast15To30DaysList(List<Arrest> inputlist) {
    List<Arrest> outputList = inputlist.where((Arrest element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.firDate.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<Arrest> getDataFromToDateList(String fDate,String tDate,List<Arrest> inputlist) {
    List<Arrest> outputList = inputlist.where((Arrest element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.firDate.toString());
        return DateFormat('MM/dd/yyyy')
            .parse(fDate).isBefore(date) &&
            DateFormat('MM/dd/yyyy')
                .parse(tDate).isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<Arrest> getBefore30DaysList(List<Arrest> inputlist) {
    List<Arrest> outputList = inputlist.where((Arrest element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.firDate.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }


  static Future<void> generateExcel(
      context, List<Arrest> lst,String fileName) async {
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

      sheet.getRangeByIndex(1, 1).setText('FIR_DATE');
      sheet.getRangeByIndex(1, 2).setText('FIR_REG_NUM');
      sheet.getRangeByIndex(1, 3).setText('ACCUSED_SRNO');
      sheet.getRangeByIndex(1, 4).setText('ACCUSED_NAME');
      sheet.getRangeByIndex(1, 5).setText('ACCUSED_PRESENT_ADDRESS');
      sheet.getRangeByIndex(1, 6).setText('ACCUSED_PERMANENT_ADDRESS');
      sheet.getRangeByIndex(1, 7).setText('ASSIGNED_TO_NAME');
      sheet.getRangeByIndex(1, 8).setText('ASSIGN_DT');
      sheet.getRangeByIndex(1, 9).setText('TARGET_DT');
      sheet.getRangeByIndex(1, 10).setText('MOBILE');
      sheet.getRangeByIndex(1, 11).setText('FIR_NUM');
      sheet.getRangeByIndex(1, 12).setText('REMARKS');
      sheet.getRangeByIndex(1, 13).setText('IS_ARRESTED');
      sheet.getRangeByIndex(1, 14).setText('ACT_SECTION');


      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].firDate??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].firRegNum??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].accusedSrNo??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].accusedName??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].accusedPresentAddress??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].accusedPermanentAddress??"").toString());
        sheet.getRangeByIndex(i+2, 7).setText((lst[i].assignedTo??"").toString());
        sheet.getRangeByIndex(i+2, 8).setText((lst[i].assignDate??"").toString());
        sheet.getRangeByIndex(i+2, 9).setText((lst[i].targetDate??"").toString());
        sheet.getRangeByIndex(i+2, 10).setText((lst[i].mobile??"").toString());
        sheet.getRangeByIndex(i+2, 11).setText((lst[i].firNum??"").toString());
        sheet.getRangeByIndex(i+2, 12).setText((lst[i].remark??"").toString());
        sheet.getRangeByIndex(i+2, 13).setText((lst[i].isArrested=="Y"?"Yes":"No").toString());
        sheet.getRangeByIndex(i+2, 14).setText((lst[i].actSection??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage(fileName, bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    } else {
      MessageUtility.showNoDataMsg(context);
    }
  }

  static sortByAccusedName(List<Arrest> lst, bool type) {
    lst.sort((a, b) => type
        ? a.accusedName!.compareTo(b.accusedName!)
        : b.accusedName!.compareTo(a.accusedName!));
  }

  static sortByPAddress(List<Arrest> lst, bool type) {
    lst.sort((a, b) => type
        ? a.accusedPresentAddress!.compareTo(b.accusedPresentAddress!)
        : b.accusedPresentAddress!.compareTo(a.accusedPresentAddress!));
  }

  static sortByAssBeat(List<Arrest> lst, bool type) {
    lst.sort((a, b) => type
        ? a.assignedTo!.compareTo(b.assignedTo!)
        : b.assignedTo!.compareTo(a.assignedTo!));
  }

  static sortByFirDate(List<Arrest> lst, bool type) {
    lst.sort((a, b) => type
        ? DateFormat('dd/MM/yyyy')
            .parse(a.firDate.toString())
            .compareTo(DateFormat('dd/MM/yyyy').parse(b.firDate.toString()))
        : DateFormat('dd/MM/yyyy')
            .parse(b.firDate.toString())
            .compareTo(DateFormat('dd/MM/yyyy').parse(a.firDate.toString())));
  }

  static sortByAssDate(List<Arrest> lst, bool type) {
    lst.sort((a, b) => type
        ? DateFormat('dd/MM/yyyy')
        .parse(a.assignDate.toString())
        .compareTo(DateFormat('dd/MM/yyyy').parse(b.assignDate.toString()))
        : DateFormat('dd/MM/yyyy')
        .parse(b.assignDate.toString())
        .compareTo(DateFormat('dd/MM/yyyy').parse(a.assignDate.toString())));
  }

  static sortByTargetDate(List<Arrest> lst, bool type) {
    lst.sort((a, b) => type
        ? DateFormat('dd/MM/yyyy')
        .parse(a.assignDate.toString())
        .compareTo(DateFormat('dd/MM/yyyy').parse(b.assignDate.toString()))
        : DateFormat('dd/MM/yyyy')
        .parse(b.assignDate.toString())
        .compareTo(DateFormat('dd/MM/yyyy').parse(a.assignDate.toString())));
  }
}
