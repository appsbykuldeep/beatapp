class SubmitCSSharedInfoEORequest {
  String? PS_CD;
  String? PERSONID;
  String? REMARKS;
  String? IS_RESOLVED;

  SubmitCSSharedInfoEORequest(
      this.PS_CD, this.PERSONID, this.REMARKS, this.IS_RESOLVED);

  Map<String, dynamic> toJson() => {
        "PS_CD": PS_CD,
        "PERSONID": PERSONID,
        "REMARKS": REMARKS,
        "IS_RESOLVED": IS_RESOLVED
      };
}
