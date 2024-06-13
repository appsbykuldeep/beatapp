class GroupUserDetails {
  String? GROUP_USER_SR_NUM;
  String? GROUP_USER_ID;
  String? USER_DISTRICT_CD;
  String? USER_PS_CD;
  String? GROUP_USER_RANK;
  String? GROUP_USER_NAME;
  String? IS_ADMIN;
  String? GROUP_USER_IS_ACTIVE;

  GroupUserDetails(
      this.GROUP_USER_SR_NUM,
      this.GROUP_USER_ID,
      this.USER_DISTRICT_CD,
      this.USER_PS_CD,
      this.GROUP_USER_RANK,
      this.GROUP_USER_NAME,
      this.IS_ADMIN,
      this.GROUP_USER_IS_ACTIVE);

  Map<String, dynamic> toJson() => {
        "GROUP_USER_SR_NUM": GROUP_USER_SR_NUM,
        "GROUP_USER_ID": GROUP_USER_ID,
        "USER_DISTRICT_CD": USER_DISTRICT_CD,
        "USER_PS_CD": USER_PS_CD,
        "GROUP_USER_RANK": GROUP_USER_RANK,
        "GROUP_USER_NAME": GROUP_USER_NAME,
        "IS_ADMIN": IS_ADMIN,
        "GROUP_USER_IS_ACTIVE": GROUP_USER_IS_ACTIVE
      };
}
