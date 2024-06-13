class GetUserListRequest {
  String? DISTRICT_CD;
  String? USER_TYPE;

  GetUserListRequest(this.DISTRICT_CD, this.USER_TYPE);

  Map<String, dynamic> toJson() =>
      {"DISTRICT_CD": DISTRICT_CD, "USER_TYPE": USER_TYPE};
}
