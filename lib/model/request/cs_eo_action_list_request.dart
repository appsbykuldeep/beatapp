class CsEoActionListRequest {
  String? PS_CD;
  String? SERVICE_TYPE;

  CsEoActionListRequest(this.PS_CD, this.SERVICE_TYPE);

  Map<String, dynamic> toJson() =>
      {"PS_CD": PS_CD, "SERVICE_TYPE": SERVICE_TYPE};
}
