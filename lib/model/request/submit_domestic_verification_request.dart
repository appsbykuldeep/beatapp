class SubmitDomesticVerificationRequest {
  String? DOMESTIC_SR_NUM;
  int? IS_RESOLVED;
  String? LAT;
  String? LONG;
  int? IS_CRIMINAL_RECORD;
  int? IS_ACCEPTED;
  String? PHOTO;
  String? REMARKS;
  String? PS_CD;
  String? NEIGHBOUR_REPORT;
  String? PREV_EMPLYR_REPORT;

  SubmitDomesticVerificationRequest(
      this.DOMESTIC_SR_NUM,
      this.IS_RESOLVED,
      this.LAT,
      this.LONG,
      this.IS_CRIMINAL_RECORD,
      this.IS_ACCEPTED,
      this.PHOTO,
      this.REMARKS,
      this.PS_CD,
      this.NEIGHBOUR_REPORT,
      this.PREV_EMPLYR_REPORT);

  Map<String, dynamic> toJson() => {
        "DOMESTIC_SR_NUM": DOMESTIC_SR_NUM,
        "IS_RESOLVED": IS_RESOLVED,
        "LAT": LAT,
        "LONG": LONG,
        "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD,
        "IS_ACCEPTED": IS_ACCEPTED,
        "PHOTO": PHOTO,
        "REMARKS": REMARKS,
        "PS_CD": PS_CD,
        "NEIGHBOUR_REPORT": NEIGHBOUR_REPORT,
        "PREV_EMPLYR_REPORT": PREV_EMPLYR_REPORT
      };
}
