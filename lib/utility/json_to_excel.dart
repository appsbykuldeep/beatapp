import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class JsonToExcel{
   static setExcelStyle(sheet){
     final Range range = sheet.getRangeByName('A1:Z1');
     range.cellStyle.fontSize = 10;
     range.columnWidth = 20;
     range.autoFitRows();
     range.cellStyle.bold = true;
   }
}