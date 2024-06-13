

class SubmitWeaponVerificationRequest {
  String? WEAPON_SR_NUM;
  int? IS_RESOLVED;
  String? LAT;
  String? LONG;
  String? PHOTO;
  String? REMARKS;
  String? PS_CD;
  String? VERIFICATION_STATUS;

  SubmitWeaponVerificationRequest(
      this.WEAPON_SR_NUM,
      this.IS_RESOLVED,
      this.LAT,
      this.LONG,
      this.PHOTO,
      this.REMARKS,
      this.PS_CD,
      this.VERIFICATION_STATUS);

  Map<String, dynamic> toJson() => {
        "WEAPON_SR_NUM": WEAPON_SR_NUM,
        "IS_RESOLVED": IS_RESOLVED,
        "LAT": LAT,
        "LONG": LONG,
        "PHOTO": PHOTO,
        "REMARKS": REMARKS,
        "PS_CD": PS_CD,
        "VERIFICATION_STATUS": VERIFICATION_STATUS
      };
}
