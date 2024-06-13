class VerifiedLicenseWeaponListResponse {
  //@SerializedName("WEAPON_SR_NUM")
  String? wEAPONSRNUM;

  //@SerializedName("BEAT_NAME")
  String? bEATNAME;

  //@SerializedName("VILL_STREET_NAME")
  String? vILLSTREETNAME;

  //@SerializedName("WEAPON_SUBTYPE")
  String? wEAPONSUBTYPE;

  //@SerializedName("LISCENSE_HOLDER_NAME")
  String? lISCENSEHOLDERNAME;

  //@SerializedName("FATHER_NAME")
  String? fATHERNAME;

  //@SerializedName("RECORD_CREATED_ON")
  String? rECORDCREATEDON;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  VerifiedLicenseWeaponListResponse(
      this.wEAPONSRNUM,
      this.bEATNAME,
      this.vILLSTREETNAME,
      this.wEAPONSUBTYPE,
      this.lISCENSEHOLDERNAME,
      this.fATHERNAME,
      this.rECORDCREATEDON,
      this.bEATCONSTABLENAME);

  factory VerifiedLicenseWeaponListResponse.fromJson(json) {
    return VerifiedLicenseWeaponListResponse(
        json["WEAPON_SR_NUM"],
        json["BEAT_NAME"],
        json["VILL_STREET_NAME"],
        json["WEAPON_SUBTYPE"],
        json["LISCENSE_HOLDER_NAME"],
        json["FATHER_NAME"],
        json["RECORD_CREATED_ON"],
        json["BEAT_CONSTABLE_NAME"]);
  }
}
