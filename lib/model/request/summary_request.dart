class SummaryRequest {
  String? DISTRICT_CD;
  String? PS_CD;

  SummaryRequest(this.DISTRICT_CD, this.PS_CD);

  Map<String, dynamic> toJson() =>
      {"DISTRICT_CD": DISTRICT_CD, "PS_CD": PS_CD};
}
