class BeatAllocationResponse {
  String? CUG;
  String? LOGIN_ID;
  String? OFFICER_RANK;
  String? NAME;
  String? PS_CD;
  String? BEAT_NAME;
  String? BEAT_CD;
  String? DISTRICT;
  String? PS;
  String? SHO_CUG;
  String? Beat_Person_Details;
  String? ASSIGNMENT_DT;
  String? ROASTER_SR_NUM;
  String? SHO_DETAIL;
  String? RECORD_ADDED_ON;
  String? CREATED_ON;

  BeatAllocationResponse(
      this.CUG,
      this.LOGIN_ID,
      this.OFFICER_RANK,
      this.NAME,
      this.PS_CD,
      this.BEAT_NAME,
      this.BEAT_CD,
      this.DISTRICT,
      this.PS,
      this.SHO_CUG,
      this.Beat_Person_Details,
      this.ASSIGNMENT_DT,
      this.ROASTER_SR_NUM,
      this.SHO_DETAIL,
      this.RECORD_ADDED_ON,
      this.CREATED_ON);

  factory BeatAllocationResponse.fromJson(Map<String, dynamic> json) {
    return BeatAllocationResponse(
        json["CUG"].toString(),
        json["LOGIN_ID"],
        json["OFFICER_RANK"],
        json["NAME"],
        json["PS_CD"].toString(),
        json["BEAT_NAME"],
        json["BEAT_CD"].toString(),
        json["DISTRICT"],
        json["PS"],
        json["SHO_CUG"].toString(),
        json["Beat_Person_Details"],
        json["ASSIGNMENT_DT"],
        json["ROASTER_SR_NUM"].toString(),
        json["SHO_DETAIL"],
        json["RECORD_ADDED_ON"],
        json["CREATED_ON"]);
  }
}
