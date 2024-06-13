import 'edit_group_user_details.dart';

class EditGroupRequest {
  String? GROUP_ID;
  String? GROUP_NAME;
  List<EditGroupUserDetails>? GROUP_USERS_DETAILS;

  EditGroupRequest(this.GROUP_ID, this.GROUP_NAME, this.GROUP_USERS_DETAILS);

  Map<String, dynamic> toJson() => {
        "GROUP_ID": GROUP_ID,
        "GROUP_NAME": GROUP_NAME,
        "GROUP_USERS_DETAILS": GROUP_USERS_DETAILS
      };
}
