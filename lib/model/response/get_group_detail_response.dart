class GetGroupDetailResponse {
  //@SerializedName("GROUP_USER_SR_NO")
  String? gROUPUSERSRNO;

  //@SerializedName("GROUP_ID")
  String? gROUPID;

  //@SerializedName("GROUP_USER_ID")
  String? gROUPUSERID;

  //@SerializedName("USER_DISTRICT")
  String? uSERDISTRICT;

  //@SerializedName("USER_DISTRICT_CD")
  String? uSERDISTRICTCD;

  //@SerializedName("USER_PS_CD")
  String? uSERPSCD;

  //@SerializedName("USER_PS")
  String? uSERPS;

  //@SerializedName("GROUP_USER_RANK")
  String? gROUPUSERRANK;

  //@SerializedName("GROUP_USER_NAME")
  String? gROUPUSERNAME;

  //@SerializedName("IS_ADMIN")
  String? iSADMIN;

  GetGroupDetailResponse(
      this.gROUPUSERSRNO,
      this.gROUPID,
      this.gROUPUSERID,
      this.uSERDISTRICT,
      this.uSERDISTRICTCD,
      this.uSERPSCD,
      this.uSERPS,
      this.gROUPUSERRANK,
      this.gROUPUSERNAME,
      this.iSADMIN);

  factory GetGroupDetailResponse.fromJson(json) {
    return GetGroupDetailResponse(
        json["GROUP_USER_SR_NO"],
        json["GROUP_ID"],
        json["GROUP_USER_ID"],
        json["USER_DISTRICT"],
        json["USER_DISTRICT_CD"],
        json["USER_PS_CD"],
        json["USER_PS"],
        json["GROUP_USER_RANK"],
        json["GROUP_USER_NAME"],
        json["IS_ADMIN"]);
  }
}
