import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CharacterCertificate {
  //@SerializedName("CHARACTER_SR_NUM")
  String? srNum;

  //@SerializedName("COMPLAINANT_NAME")
  String beatName;
  String? complainantName;

  //@SerializedName("ASSIGNED_DT")
  String? assignedDt;

  //@SerializedName("COMPL_DT")
  String? completeDt;

  //@SerializedName("REG_DT")
  String? regDate;

  //@SerializedName("EO_NAME")
  String? eoName;

  //@SerializedName("ASSIGN_STATUS")
  String? assignStatus;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? beatConstableName;

  //@SerializedName("APPLICATION_DT")
  String? applicationDt;

  //@SerializedName("REGISTERED_DT")
  String? registeredDt;

  //@SerializedName("APPLICANT_NAME")
  String? applicantName;

  CharacterCertificate(
      this.beatName,
      this.srNum,
      this.complainantName,
      this.assignedDt,
      this.completeDt,
      this.regDate,
      this.eoName,
      this.assignStatus,
      this.beatConstableName,
      this.applicationDt,
      this.registeredDt,
      this.applicantName);

  factory CharacterCertificate.fromJson(json) {
    return CharacterCertificate(
        json["BEAT_NAME"]??'',
        json["CHARACTER_SR_NUM"].toString(),
        json["COMPLAINANT_NAME"],
        json["ASSIGNED_DT"],
        json["COMPL_DT"],
        json["REG_DT"],
        json["EO_NAME"],
        json["ASSIGN_STATUS"],
        json["BEAT_CONSTABLE_NAME"],
        json["APPLICATION_DT"],
        json["REGISTERED_DT"],
        json["APPLICANT_NAME"]);
  }

  factory CharacterCertificate.emptyData() {
    return CharacterCertificate(
        '',null, null, null, null, null, null, null, null, null, null, null);
  }

  static List<CharacterCertificate> getLast15DaysList(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList =
        inputlist.where((CharacterCertificate element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.regDate.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CharacterCertificate> getLast15To30DaysList(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList =
        inputlist.where((CharacterCertificate element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.regDate.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CharacterCertificate> getBefore30DaysList(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList =
        inputlist.where((CharacterCertificate element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.regDate.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CharacterCertificate> getDataFromToDateList(String fDate,String tDate,List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList = inputlist.where((CharacterCertificate element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.regDate.toString());
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

  static List<CharacterCertificate> getLast15DaysListAssigned(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList =
        inputlist.where((CharacterCertificate element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.assignedDt.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CharacterCertificate> getLast15To30DaysListAssigned(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList =
        inputlist.where((CharacterCertificate element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.assignedDt.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CharacterCertificate> getBefore30DaysListAssigned(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList =
        inputlist.where((CharacterCertificate element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.assignedDt.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CharacterCertificate> getLast15DaysListComplete(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList =
        inputlist.where((CharacterCertificate element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.completeDt.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CharacterCertificate> getLast15To30DaysListComplete(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList =
        inputlist.where((CharacterCertificate element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.completeDt.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CharacterCertificate> getBefore30DaysListComplete(
      List<CharacterCertificate> inputlist) {
    List<CharacterCertificate> outputList = inputlist.where((CharacterCertificate element) {
      try {
        final date =
            DateFormat('dd/MM/yyyy').parse(element.completeDt.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static Future<void> generateExcelUnAssigned(
      context, List<CharacterCertificate> lst) async {
    DialogHelper.showLoaderDialog(context);
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    JsonToExcel.setExcelStyle(sheet);

    sheet.getRangeByIndex(1, 1).setText('SR NUM');
    sheet.getRangeByIndex(1, 2).setText('COMPLAINANT NAME');
    sheet.getRangeByIndex(1, 3).setText('REGISTERD DATE');
    sheet.getRangeByIndex(1, 4).setText('RECORD CREATED ON');
    sheet.getRangeByIndex(1, 5).setText('ASSIGNED STATUS');

    for (int i = 0; i < lst.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText((lst[i].srNum ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 2)
          .setText((lst[i].complainantName ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 3)
          .setText((lst[i].regDate ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 4)
          .setText((lst[i].applicationDt).toString());
      sheet
          .getRangeByIndex(i + 2, 5)
          .setText((lst[i].assignStatus ?? "").toString());
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    Navigator.pop(context);

    //Save and launch the file.
    await CameraAndFileProvider.saveBytesInStorage(
        'UnassignedCharacterCert', bytes, ".xlsx");
    MessageUtility.showDownloadCompleteMsg(context);
  }

  static Future<void> generateExcelAssigned(
      context, List<CharacterCertificate> lst) async {
    DialogHelper.showLoaderDialog(context);
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    JsonToExcel.setExcelStyle(sheet);

    sheet.getRangeByIndex(1, 1).setText('SR NUM');
    sheet.getRangeByIndex(1, 2).setText('COMPLAINANT NAME');
    sheet.getRangeByIndex(1, 3).setText('REGISTERED DATE');
    sheet.getRangeByIndex(1, 4).setText('ASSIGNED DATE');
    sheet.getRangeByIndex(1, 5).setText('RECORD CREATED ON');
    sheet.getRangeByIndex(1, 6).setText('BEAT CONSTABLE NAME');
    sheet.getRangeByIndex(1, 7).setText('EO NAME');

    for (int i = 0; i < lst.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText((lst[i].srNum ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 2)
          .setText((lst[i].complainantName ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 3)
          .setText((lst[i].regDate ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 4)
          .setText((lst[i].assignedDt ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 5)
          .setText((lst[i].applicationDt ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 6)
          .setText((lst[i].beatConstableName ?? "").toString());
      sheet.getRangeByIndex(i + 2, 7).setText((lst[i].eoName ?? "").toString());
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    Navigator.pop(context);

    //Save and launch the file.
    await CameraAndFileProvider.saveBytesInStorage(
        'AssignedCharacterCert', bytes, ".xlsx");
    MessageUtility.showDownloadCompleteMsg(context);
  }

  static Future<void> generateExcelAccepted(
      context, List<CharacterCertificate> lst) async {
    DialogHelper.showLoaderDialog(context);
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    JsonToExcel.setExcelStyle(sheet);

    sheet.getRangeByIndex(1, 1).setText('SR NUM');
    sheet.getRangeByIndex(1, 2).setText('COMPLAINANT NAME');
    sheet.getRangeByIndex(1, 3).setText('COMPLETED DATE');
    sheet.getRangeByIndex(1, 4).setText('ASSIGNED DATE');
    sheet.getRangeByIndex(1, 5).setText('RECORD CREATED ON');
    sheet.getRangeByIndex(1, 6).setText('BEAT CONSTABLE NAME');
    sheet.getRangeByIndex(1, 7).setText('EO NAME');

    for (int i = 0; i < lst.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText((lst[i].srNum ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 2)
          .setText((lst[i].complainantName ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 3)
          .setText((lst[i].completeDt ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 4)
          .setText((lst[i].assignedDt ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 5)
          .setText((lst[i].applicationDt ?? "").toString());
      sheet
          .getRangeByIndex(i + 2, 6)
          .setText((lst[i].beatConstableName ?? "").toString());
      sheet.getRangeByIndex(i + 2, 7).setText((lst[i].eoName ?? "").toString());
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    Navigator.pop(context);

    //Save and launch the file.
    await CameraAndFileProvider.saveBytesInStorage(
        'AcceptedCharacterCert', bytes, ".xlsx");
    MessageUtility.showDownloadCompleteMsg(context);
  }
}
