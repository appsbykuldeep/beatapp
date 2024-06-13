class GetPendingSummon {
  String? DISTRICT_CD;
  String? PS_CD;
  String? OFFICE_CD;

  GetPendingSummon(this.DISTRICT_CD, this.PS_CD, this.OFFICE_CD);

  factory GetPendingSummon.fromJson(json) {
    return GetPendingSummon(
        json["DISTRICT_CD"], json["PS_CD"], json["OFFICE_CD"]);
  }
}
