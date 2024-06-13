class SubmitCSSharedInfoVerificationRequest {
  String? PERSONID;
  String? IS_RESOLVED;
  String? LAT;
  String? LONG;
  String? REMARKS;
  String? PHOTO;

  SubmitCSSharedInfoVerificationRequest(this.PERSONID, this.IS_RESOLVED,
      this.LAT, this.LONG, this.REMARKS, this.PHOTO);

  Map<String, dynamic> toJson() => {
        "PERSONID": PERSONID,
        "IS_RESOLVED": IS_RESOLVED,
        "LAT": LAT,
        "LONG": LONG,
        "REMARKS": REMARKS,
        "PHOTO": PHOTO
      };
}
