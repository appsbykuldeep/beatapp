class SaveCommentRequest {
  //@SerializedName("PS_CD")
  String? psCd;

  //@SerializedName("APP_USER_NAME")
  String? userName;

  //@SerializedName("APP_USER_RANK")
  String? rank;

  //@SerializedName("REMARKS")
  String? remark;

  //@SerializedName("INFO_SR_NUM")
  String? infoSrNum;

  //@SerializedName("SOOCHNA_SR_NUM")
  String? soochnaSrNum;

  //@SerializedName("LATITUDE")
  String? lat;

  //@SerializedName("LONGITUDE")
  String? lng;

  SaveCommentRequest(this.psCd, this.userName, this.rank, this.remark,
      this.infoSrNum, this.soochnaSrNum, this.lat, this.lng);

  Map<String, dynamic> toJson() => {
        "PS_CD": psCd,
        "APP_USER_NAME": userName,
        "APP_USER_RANK": rank,
        "REMARKS": remark,
        "INFO_SR_NUM": infoSrNum,
        "SOOCHNA_SR_NUM": soochnaSrNum,
        "LATITUDE": lat,
        "LONGITUDE": lng
      };

  Map<String, dynamic> toCitizenMsgJson() => {
    "PS_CD": psCd,
    "APP_USER_NAME": userName,
    "APP_USER_RANK": rank,
    "REMARKS": remark,
    "PERSONID":infoSrNum,
    "LATITUDE": lat,
    "LONGITUDE": lng
  };
}
