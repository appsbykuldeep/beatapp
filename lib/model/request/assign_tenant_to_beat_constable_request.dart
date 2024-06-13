class AssignTenantToBeatConstableRequest {
  String? DISTRICT_CD;
  String? PS_CD;
  String? BEAT_CD;
  String? ASSIGN_TO;
  String? TARGET_DT;
  String? TENANT_SR_NUM;
  String? EO_PS_STAFF_CD;
  String? DESCRIPTION;

  AssignTenantToBeatConstableRequest(
      this.DISTRICT_CD,
      this.PS_CD,
      this.BEAT_CD,
      this.ASSIGN_TO,
      this.TARGET_DT,
      this.TENANT_SR_NUM,
      this.EO_PS_STAFF_CD,
      this.DESCRIPTION);

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": DISTRICT_CD,
        "PS_CD": PS_CD,
        "BEAT_CD": BEAT_CD,
        "ASSIGN_TO": ASSIGN_TO,
        "TARGET_DT": TARGET_DT,
        "TENANT_SR_NUM": TENANT_SR_NUM,
        "EO_PS_STAFF_CD": EO_PS_STAFF_CD,
        "DESCRIPTION": DESCRIPTION
      };
}
