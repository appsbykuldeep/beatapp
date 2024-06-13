//@Entity(tableName = "M_INFORMATION_TYPE")
import 'package:beatapp/database/asset_db_helper.dart';

class InformationType {
  //@PrimaryKey
  //@ColumnInfo(name = "INFORM_CD")
  String? informationCD;

  //@ColumnInfo(name = "LANG_CD")
  int? langCD;

  //@ColumnInfo(name = "INFORMATION_TYPE")
  String? informationType;

  //@ColumnInfo(name = "RECORD_CREATED_ON")
  String? createdDate;

  InformationType(this.informationType, this.informationCD);

  @override
  String toString() {
    return informationType!;
  }

  static Future<List<InformationType>> getInfoTypeList() async {
    List<InformationType> lst = [];
    AssetDbHelper helper = AssetDbHelper();
    await helper.openDataBaseConnection();
    if (helper.initialized) {
      String query = '''SELECT M_INFORMATION_TYPE.INFORMATION_TYPE,
          M_INFORMATION_TYPE.INFORM_CD FROM M_INFORMATION_TYPE''';
      var data = await helper.db!.rawQuery(query);
      for (int i = 0; i < data.length; i++) {
        lst.add(InformationType(data[i]["INFORMATION_TYPE"].toString(),
            data[i]["INFORM_CD"].toString()));
      }
    }
    return lst;
  }
}
