class SaveCsCommentRequest {
  //@SerializedName("PS_CD")
  String? psCd;

  //@SerializedName("APP_USER_NAME")
  String? userName;

  //@SerializedName("APP_USER_RANK")
  String? rank;

  //@SerializedName("REMARKS")
  String? remark;

  //@SerializedName("PERSONID")
  String? personId;

  //@SerializedName("LAT")
  String? lat;

  //@SerializedName("LONG")
  String? lng;

  SaveCsCommentRequest(this.psCd, this.userName, this.rank, this.remark,
      this.personId, this.lat, this.lng);

  Map<String, dynamic> toJson() => {
        "PS_CD": psCd,
        "APP_USER_NAME": userName,
        "APP_USER_RANK": rank,
        "REMARKS": remark,
        "PERSONID": personId,
        "LAT": lat,
        "LONG": lng
      };
}
