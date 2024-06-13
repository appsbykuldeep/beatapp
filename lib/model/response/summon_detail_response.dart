import 'table.dart';
import 'table1.dart';
import 'table2.dart';
import 'table3.dart';
import 'table4.dart';
import 'table5.dart';

class SummonDetailResponse {
  //@SerializedName("Table")
  List<Table>? table = [];

  //@SerializedName("Table1")
  List<Table1> table1 = [];

  //@SerializedName("Table2")
  List<Table2> table2 = [];

  //@SerializedName("Table3")
  List<Table3> table3 = [];

  //@SerializedName("Table4")
  List<Table4> table4 = [];

  //@SerializedName("Table5")
  List<Table5> table5 = [];

  Map<String?, Object> additionalProperties = {};

  SummonDetailResponse(this.table, this.table1, this.table2, this.table3,
      this.table4, this.table5);

  factory SummonDetailResponse.fromJson(json) {
    List<Table> lstTbl = Table.fromJsonArray(json["Table"]);
    List<Table1> lstTbl1 = Table1.fromJsonArray(json["Table1"]);
    List<Table2> lstTbl2 = Table2.fromJsonArray(json["Table2"]);
    List<Table3> lstTbl3 = Table3.fromJsonArray(json["Table3"]);
    List<Table4> lstTbl4 = Table4.fromJsonArray(json["Table4"]);
    List<Table5> lstTbl5 = Table5.fromJsonArray(json["Table5"]);

    for (var x in (json as Map).entries) {
      print(x);
    }
    return SummonDetailResponse(
        lstTbl, lstTbl1, lstTbl2, lstTbl3, lstTbl4, lstTbl5);
  }
}
