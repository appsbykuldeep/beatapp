import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/date_time_helper.dart';
import 'package:beatapp/utility/json_to_excel.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CitizenMessage {
  //@SerializedName("PERSON_ID")
  String? personId;

  //@SerializedName("DISTRICT")
  String? district;

  //@SerializedName("PS")
  String? ps;

  //@SerializedName("NAME")
  String? name;

  //@SerializedName("MOBILE_NO")
  String? mobileNo;

  //@SerializedName("SHARE_DT")
  String? shareDate;

  //@SerializedName("SHARE_DT")
  String? REG_DT;

  //@SerializedName("SHARE_DT")
  String? ASSIGNED_ON;

//@SerializedName("SHARE_DT")
  String? TARGET_DT;

  String? COMP_DT;

  //@SerializedName("SHARE_DT")
  String? ASSIGN_STATUS;

  String? EO_NAME;

  CitizenMessage(
      this.personId,
      this.district,
      this.ps,
      this.name,
      this.mobileNo,
      this.shareDate,
      this.ASSIGN_STATUS,
      this.ASSIGNED_ON,
      this.TARGET_DT,
      this.EO_NAME,
      this.REG_DT,
      this.COMP_DT);

  factory CitizenMessage.fromJson(json) {
    return CitizenMessage(
        json["PERSON_ID"].toString(),
        json["DISTRICT"],
        json["PS"],
        json["NAME"],
        json["MOBILE_NO"],
        json["SHARE_DT"],
        json["ASSIGN_STATUS"],
        json["ASSIGNED_ON"],
        json["TARGET_DT"],
        json["EO_NAME"],
        json["REG_DT"],
        json["COMP_DT"]);
  }
  

  static List<CitizenMessage> getLast15DaysList(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CitizenMessage> getLast15To30DaysList(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CitizenMessage> getBefore30DaysList(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CitizenMessage> getDataFromToDateList(String fDate,String tDate,List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(element.shareDate.toString());
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

  static List<CitizenMessage> getLast15DaysListAssigned(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CitizenMessage> getLast15To30DaysListAssigned(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CitizenMessage> getBefore30DaysListAssigned(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CitizenMessage> getLast15DaysListComplete(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.get15days().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CitizenMessage> getLast15To30DaysListComplete(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.get15days().isAfter(date) &&
            DateTimeHelper.getBefore30day().isBefore(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<CitizenMessage> getBefore30DaysListComplete(
      List<CitizenMessage> inputlist) {
    List<CitizenMessage> outputList = inputlist.where((CitizenMessage element) {
      try {
        final date = DateFormat('dd/MM/yyyy')
            .parse(element.shareDate.toString());
        return DateTimeHelper.getBefore30day().isAfter(date);
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }


  static Future<void> generateExcel(
      context, List<CitizenMessage> lst) async {
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

      sheet.getRangeByIndex(1, 1).setText('PERSON_ID');
      sheet.getRangeByIndex(1, 2).setText('DISTRICT');
      sheet.getRangeByIndex(1, 3).setText('PS');
      sheet.getRangeByIndex(1, 4).setText('NAME');
      sheet.getRangeByIndex(1, 5).setText('MOBILE_NO');
      sheet.getRangeByIndex(1, 6).setText('SHARE_DT');
      sheet.getRangeByIndex(1, 7).setText('ASSIGN_STATUS');

      for (int i = 0; i < lst.length; i++) {
        sheet.getRangeByIndex(i+2, 1).setText((lst[i].personId??"").toString());
        sheet.getRangeByIndex(i+2, 2).setText((lst[i].district??"").toString());
        sheet.getRangeByIndex(i+2, 3).setText((lst[i].ps??"").toString());
        sheet.getRangeByIndex(i+2, 4).setText((lst[i].name??"").toString());
        sheet.getRangeByIndex(i+2, 5).setText((lst[i].mobileNo??"").toString());
        sheet.getRangeByIndex(i+2, 6).setText((lst[i].shareDate??"").toString());
        sheet.getRangeByIndex(i+2, 7).setText((lst[i].ASSIGN_STATUS??"").toString());
      }

      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      //Dispose the document.
      workbook.dispose();

      Navigator.pop(context);

      //Save and launch the file.
      await CameraAndFileProvider.saveBytesInStorage('UnussignedCitizenMSG', bytes, ".xlsx");
      MessageUtility.showDownloadCompleteMsg(context);
    }else {
      MessageUtility.showNoDataMsg(context);
    }
  }
}
