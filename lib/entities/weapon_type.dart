//@Entity(tableName = "m_weapon_subtype")
class WeaponType {
  //@PrimaryKey
  //@ColumnInfo(name = "WEAPON_SUBTYPE_CD")
  int? weaponSubtypeCd;

  //@ColumnInfo(name = "LANG_CD")
  int? langCD;

  //@ColumnInfo(name = "WEAPON_SUBTYPE")
  String? weaponSubtype;

  //@ColumnInfo(name = "RECORD_STATUS")
  String? recordStatus;

  //@ColumnInfo(name = "RECORD_CREATED_ON")
  String? createdDate;

  WeaponType(int this.weaponSubtypeCd, String this.weaponSubtype);

  //@Override
  @override
  String toString() {
    return weaponSubtype!;
  }
}
