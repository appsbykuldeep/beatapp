class SummonAssignToOfficerRequest {
  String? SUMM_WARR_NUM;
  String? SUMM_ASSIGN_TO;
  String? DISTRICT_CD;
  String? PS_CD;
  String? BEAT_CD;
  String? TARGET_DT;

  SummonAssignToOfficerRequest();

  Map<String, dynamic> toJson() => {
        "SUMM_WARR_NUM": SUMM_WARR_NUM,
        "SUMM_ASSIGN_TO": SUMM_ASSIGN_TO,
        "DISTRICT_CD": DISTRICT_CD,
        "PS_CD": PS_CD,
        "BEAT_CD": BEAT_CD,
        "TARGET_DT": TARGET_DT
      };
}
