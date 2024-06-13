class GetPendingSummonsBeat {
  String? PS_CD;
  String? OFFICE_CD;

  GetPendingSummonsBeat(this.PS_CD, this.OFFICE_CD);

  factory GetPendingSummonsBeat.fromJson(json) {
    return GetPendingSummonsBeat(json["PS_CD"], json["OFFICE_CD"]);
  }
}
