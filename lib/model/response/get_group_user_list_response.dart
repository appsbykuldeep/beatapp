class GetGroupUserListResponse {
  bool? isSelected;

  //@SerializedName("USER_ID")
  String? uSERID;

  //@SerializedName("USER_NAME")
  String? uSERNAME;

  //@SerializedName("PS")
  String? pS;

  //@SerializedName("DISTRICT")
  String? dISTRICT;

  //@SerializedName("ROLE")
  String? rOLE;

  //@SerializedName("PS_CD")
  String? pSCD;

  //@SerializedName("DISTRICT_CD")
  String? dISTRICTCD;

  bool? checked;

  GetGroupUserListResponse(this.uSERID, this.uSERNAME, this.pS, this.dISTRICT,
      this.rOLE, this.pSCD, this.dISTRICTCD);

  factory GetGroupUserListResponse.fromJson(json) {
    return GetGroupUserListResponse(
        json["USER_ID"],
        json["USER_NAME"],
        json["PS"],
        json["DISTRICT"],
        json["ROLE"],
        json["PS_CD"],
        json["DISTRICT_CD"]);
  }
}
