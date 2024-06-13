//@Entity(tableName = "m_district")
import 'package:beatapp/database/asset_db_helper.dart';

class District {
  //@PrimaryKey
  //@ColumnInfo(name = "DISTRICT_CD")
  String? districtCD;

  //@ColumnInfo(name = "LANG_CD")
  String? langCD;

  //@ColumnInfo(name = "STATE_CD")
  String? stateCD;

  //@ColumnInfo(name = "RANGE_CD")
  String? rangeCD;

  //@ColumnInfo(name = "DISTRICT")
  String? district;

  //@ColumnInfo(name = "RECORD_CREATED_ON")
  String? createdDate;

  // District(String districtCD, String district) {
  //   this.districtCD = districtCD;
  //   this.district = district;
  // }

  District({
    this.districtCD,
    this.langCD,
    this.stateCD,
    this.rangeCD,
    this.district,
    this.createdDate,
  });

  factory District.fromJson(json) {
    return District(
        districtCD: json["DISTRICT_CD"].toString(), district: json["DISTRICT"]);
  }

  static Future<List<District>> getAllDistrict() async {
    List<District> lst = [];
    AssetDbHelper helper = AssetDbHelper();
    await helper.openDataBaseConnection();
    if (helper.initialized) {
      String query =
          '''SELECT m_district.DISTRICT,m_district.DISTRICT_CD from m_district''';
      var data = await helper.db!.rawQuery(query);
      for (int i = 0; i < data.length; i++) {
        lst.add(District(
            districtCD: data[i]["DISTRICT_CD"].toString(),
            district: data[i]["DISTRICT"].toString()));
      }
    }
    return lst;
  }
}
