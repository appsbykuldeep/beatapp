
class SubmitEmployeeVerificationRequest {
  String? EMPLOYEE_SR_NUM;
  String? IS_RESOLVED;
  String? LAT;
  String? LONG;
  String? IS_CRIMINAL_RECORD;
  String? IS_ACCEPTED;
  String? PHOTO;
  String? REMARKS;
  String? PS_CD;

  SubmitEmployeeVerificationRequest(
      this.EMPLOYEE_SR_NUM,
      this.IS_RESOLVED,
      this.LAT,
      this.LONG,
      this.IS_CRIMINAL_RECORD,
      this.IS_ACCEPTED,
      this.PHOTO,
      this.REMARKS,
      this.PS_CD);

  Map<String, dynamic> toJson() => {
        "EMPLOYEE_SR_NUM": EMPLOYEE_SR_NUM,
        "IS_RESOLVED": IS_RESOLVED,
        "LAT": LAT,
        "LONG": LONG,
        "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD,
        "IS_ACCEPTED": IS_ACCEPTED,
        "PHOTO": PHOTO,
        "REMARKS": REMARKS,
        "PS_CD": PS_CD
      };
}
