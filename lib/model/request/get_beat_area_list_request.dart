class GetBeatAreaListRequest {
  String? PS_CD;
  String? AREA_SR_NUM;

  GetBeatAreaListRequest(this.PS_CD, this.AREA_SR_NUM);

  Map<String, dynamic> toJson() =>
      {"PS_CD": PS_CD, "AREA_SR_NUM": AREA_SR_NUM};
}
