import 'weapon_beat_report_table.dart';
import 'weapon_detail_table.dart';

class LicenseWeaponDetailResponse {
  //@SerializedName("Table")
  List<WeaponDetail_Table>? weaponDetail;

  /* //@SerializedName("Table1")
     List<DomesticDetailAttachment> domesticAttachment = null;*/

  //@SerializedName("Table1")
  List<WeaponBeatReport_Table>? beatReport;

  LicenseWeaponDetailResponse(this.weaponDetail, this.beatReport);

  factory LicenseWeaponDetailResponse.fromJson(json){
    return LicenseWeaponDetailResponse(json["Table"], json["Table1"]);
  }
}
