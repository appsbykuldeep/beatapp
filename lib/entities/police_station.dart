//@Entity(tableName = "m_police_station")
import 'package:beatapp/database/asset_db_helper.dart';

class PoliceStation {
  //@PrimaryKey
  //@ColumnInfo(name = "PS_CD")
  String? psCD;

  //@ColumnInfo(name = "LANG_CD")
  String? langCD;

  //@ColumnInfo(name = "DISTRICT_CD")
  String? districtCD;

  //@ColumnInfo(name = "SUB_DISTRICT_CD")
  String? subDistrictCD;

  //@ColumnInfo(name = "PS")
  String? ps;

  //@ColumnInfo(name = "RECORD_CREATED_ON")
  String? createdDate;

  PoliceStation(this.psCD, this.ps);

  factory PoliceStation.fromJson(json) {
    return PoliceStation(json["PS_CD"].toString(), json["PS"]);
  }

  //@Override
  @override
  String toString() {
    return ps!;
  }

  static Future<List<PoliceStation>> searchPS(String distID) async {
    List<PoliceStation> lst = [];
    AssetDbHelper helper = AssetDbHelper();
    await helper.openDataBaseConnection();
    if (helper.initialized) {
      String query = '''select m_police_station.PS,m_police_station.PS_CD 
      from m_police_station where m_police_station.DISTRICT_CD = $distID''';
      var data = await helper.db!.rawQuery(query);
      for (int i = 0; i < data.length; i++) {
        lst.add(PoliceStation(
            data[i]["PS_CD"].toString(), data[i]["PS"].toString()));
      }
    }
    return lst;
  }
}
