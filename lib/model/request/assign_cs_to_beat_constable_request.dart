class AssignCSToBeatConstableRequest {
  String? DISTRICT_CD;
  String? PS_CD;
  String? BEAT_CD;
  String? ASSIGN_TO;
  String? TARGET_DT;
  String? PERSONID;
  String? EO_PS_STAFF_CD;
  String? DESCRIPTION;

  AssignCSToBeatConstableRequest(
      this.DISTRICT_CD,
      this.PS_CD,
      this.BEAT_CD,
      this.ASSIGN_TO,
      this.TARGET_DT,
      this.PERSONID,
      this.EO_PS_STAFF_CD,
      this.DESCRIPTION);

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": DISTRICT_CD,
        "PS_CD": PS_CD,
        "BEAT_CD": BEAT_CD,
        "ASSIGN_TO": ASSIGN_TO,
        "TARGET_DT": TARGET_DT,
        "PERSONID": PERSONID,
        "EO_PS_STAFF_CD": EO_PS_STAFF_CD,
        "DESCRIPTION": DESCRIPTION
      };
}
