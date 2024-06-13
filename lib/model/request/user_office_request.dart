class UserOfficeRequest {
  String? USER_TYPE;

  UserOfficeRequest(this.USER_TYPE);

  Map<String, dynamic> toJson() => {
        "USER_TYPE": USER_TYPE,
      };

}
