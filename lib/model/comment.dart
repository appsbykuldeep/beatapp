class Comment {
  //@SerializedName("APP_USER_NAME")
  String? appUserName;

  //@SerializedName("APP_USER_RANK")
  String? appUserRank;

  //@SerializedName("FILL_DT")
  String? fillDt;

  //@SerializedName("REMARKS")
  String? remarks;

  //@SerializedName("LATITUDE")
  String? latitude;

  //@SerializedName("LONGITUDE")
  String? longitude;

  Comment(this.appUserName, this.appUserRank, this.fillDt, this.remarks,
      this.latitude, this.longitude);

  factory Comment.fromJson(json) {
    return Comment(json["APP_USER_NAME"], json["APP_USER_RANK"],
        json["FILL_DT"], json["REMARKS"], json["LATITUDE"], json["LONGITUDE"]);
  }
}
