class GetUnassignedSummon {
  String? PS_STAFF_CD;
  String? OFFICE_CD;
  String? PS_CD;

  GetUnassignedSummon(this.PS_STAFF_CD, this.OFFICE_CD, this.PS_CD);

// String? userName;

  factory GetUnassignedSummon.fromJson(json) {
    return GetUnassignedSummon(
        json["PS_STAFF_CD"], json["OFFICE_CD"], json["PS_CD"]);
  }
}
