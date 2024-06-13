import 'group_user_details.dart';

class CreateGroupRequest {
  String? GROUP_NAME;
  String? DISTRICT_CD;
  String? GROUP_CREATED_BY_NAME;
  String? GROUP_CREATED_BY_RANK;
  List<GroupUserDetails>? GROUP_USERS_DETAILS;

  CreateGroupRequest(
      this.GROUP_NAME,
      this.DISTRICT_CD,
      this.GROUP_CREATED_BY_NAME,
      this.GROUP_CREATED_BY_RANK,
      this.GROUP_USERS_DETAILS);

  Map<String, dynamic> toJson() => {
        "GROUP_NAME": GROUP_NAME,
        "DISTRICT_CD": DISTRICT_CD,
        "GROUP_CREATED_BY_NAME": GROUP_CREATED_BY_NAME,
        "GROUP_CREATED_BY_RANK": GROUP_CREATED_BY_RANK,
        "GROUP_USERS_DETAILS": GROUP_USERS_DETAILS
      };
}
