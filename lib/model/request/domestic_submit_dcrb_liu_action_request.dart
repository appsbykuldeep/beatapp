class DomesticSubmitDcrbLiuActionRequest {
  String? DOMESTIC_SR_NUM;
  String? IS_CRIMINAL_RECORD;
  String? DESCRIPTION;
  String? DISTRICT_CD;

  DomesticSubmitDcrbLiuActionRequest(this.DOMESTIC_SR_NUM,
      this.IS_CRIMINAL_RECORD, this.DESCRIPTION, this.DISTRICT_CD);

  Map<String, dynamic> toJson() => {
        "DOMESTIC_SR_NUM": DOMESTIC_SR_NUM,
        "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD,
        "DESCRIPTION": DESCRIPTION,
        "DISTRICT_CD": DISTRICT_CD
      };
}
