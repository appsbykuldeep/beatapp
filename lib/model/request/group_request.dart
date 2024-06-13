class GroupRequest {
  String? GROUP_ID;

  GroupRequest(this.GROUP_ID);

  Map<String, dynamic> toJson() => {
    "GROUP_ID":GROUP_ID
  };
}
