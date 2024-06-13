class WeaponDetail_Table {
  //@SerializedName("WEAPON_SR_NUM")
  String? wEAPONSRNUM;

  //@SerializedName("DISTRICT")
  String? dISTRICT;

  //@SerializedName("PS")
  String? pS;

  //@SerializedName("BEAT_NAME")
  String bEATNAME;

  //@SerializedName("VILL_STREET_NAME")
  String? vILLSTREETNAME;

  //@SerializedName("WEAPON")
  String? wEAPON;

  //@SerializedName("LISCENSE_HOLDER_NAME")
  String? lISCENSEHOLDERNAME;

  //@SerializedName("FATHER_NAME")
  String? fATHERNAME;

  //@SerializedName("ADDRESS")
  String? aDDRESS;

  //@SerializedName("AGE")
  String? aGE;

  //@SerializedName("WEAPON_EXPIRT_DATE")
  String? wEAPONEXPIRTDATE;

  //@SerializedName("MOBILE")
  String? mOBILE;

  //@SerializedName("ARMS_MODEL")
  String? aRMSMODEL;

  //@SerializedName("RECORD_CREATED_ON")
  String? rECORDCREATEDON;

  //@SerializedName("ARMS_LISCENSE_NO")
  String? aRMSLISCENSENO;

//@SerializedName("WEAPON_SUBTYPE_CD")
  String? WEAPON_SUBTYPE_CD;

//@SerializedName("BEAT_CD")
  String? BEAT_CD;

//@SerializedName("VILL_STR_SR_NUM")
  String? VILL_STR_SR_NUM;

  String? BEAT_CONSTABLE_NAME;
  String? WEAPON_SUBTYPE;

  WeaponDetail_Table(
      this.wEAPONSRNUM,
      this.dISTRICT,
      this.pS,
      this.bEATNAME,
      this.vILLSTREETNAME,
      this.wEAPON,
      this.lISCENSEHOLDERNAME,
      this.fATHERNAME,
      this.aDDRESS,
      this.aGE,
      this.wEAPONEXPIRTDATE,
      this.mOBILE,
      this.aRMSMODEL,
      this.rECORDCREATEDON,
      this.aRMSLISCENSENO,
      this.WEAPON_SUBTYPE_CD,
      this.BEAT_CD,
      this.VILL_STR_SR_NUM,
      this.BEAT_CONSTABLE_NAME,
      this.WEAPON_SUBTYPE);

  factory WeaponDetail_Table.fromJson(json) {
    return WeaponDetail_Table(
        json["WEAPON_SR_NUM"].toString(),
        json["DISTRICT"],
        json["PS"],
        json["BEAT_NAME"]??'',
        json["VILL_STREET_NAME"],
        json["WEAPON"],
        json["LISCENSE_HOLDER_NAME"],
        json["FATHER_NAME"],
        json["ADDRESS"],
        json["AGE"].toString(),
        json["WEAPON_EXPIRT_DATE"],
        json["MOBILE"],
        json["ARMS_MODEL"],
        json["RECORD_CREATED_ON"],
        json["ARMS_LISCENSE_NO"],
        json["WEAPON_SUBTYPE_CD"].toString(),
        json["BEAT_CD"].toString(),
        json["VILL_STR_SR_NUM"].toString(),
        json["BEAT_CONSTABLE_NAME"],
        json["WEAPON_SUBTYPE"]);
  }

  factory WeaponDetail_Table.emptyData() {
    return WeaponDetail_Table(null, null, null, '', null, null, null, null,
        null, null, null, null, null, null, null, null, null, null, null, null);
  }
}
