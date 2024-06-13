class WeaponTypeModel {
  //@SerializedName("WEAPON_SUBTYPE_CD")
  String? WEAPON_SUBTYPE_CD;

  //@SerializedName("WEAPON_SUBTYPE")
  String? WEAPON_SUBTYPE;

  WeaponTypeModel(this.WEAPON_SUBTYPE_CD, this.WEAPON_SUBTYPE);

  factory WeaponTypeModel.fromJson(json) {
    return WeaponTypeModel(
        json["WEAPON_SUBTYPE_CD"].toString(), json["WEAPON_SUBTYPE"]);
  }
}
