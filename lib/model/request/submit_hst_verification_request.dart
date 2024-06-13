

class SubmitHSTVerificationRequest {
  String? HST_SR_NUM;
  String? IS_RESOLVED;
  String? LAT;
  String? LONG;
  String? PHOTO;
  String? REMARKS;
  String? PS_CD;
  String? VERIFICATION_STATUS;

  SubmitHSTVerificationRequest(
      this.HST_SR_NUM,
      this.IS_RESOLVED,
      this.LAT,
      this.LONG,
      this.PHOTO,
      this.REMARKS,
      this.PS_CD,
      this.VERIFICATION_STATUS);

  Map<String, dynamic> toJson() => {
        "HST_SR_NUM": HST_SR_NUM,
        "IS_RESOLVED": IS_RESOLVED,
        "LAT": LAT,
        "LONG": LONG,
        "PHOTO": PHOTO,
        "REMARKS": REMARKS,
        "PS_CD": PS_CD,
        "VERIFICATION_STATUS": VERIFICATION_STATUS
      };
}
