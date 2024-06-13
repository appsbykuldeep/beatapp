class GetGroupListResponse {
  //@SerializedName("GROUP_NAME")
  String? gROUPNAME;

  //@SerializedName("GROUP_ID")
  String? gROUPID;

  //@SerializedName("GROUP_CREATED_ON")
  String? gROUPCREATEDON;

  //@SerializedName("GROUP_CREATED_BY")
  String? gROUPCREATEDBY;

  //@SerializedName("IS_ADMIN")
  String? iSADMIN;

  //@SerializedName("TOTAL_USERS")
  String? tOTALUSERS;

  GetGroupListResponse(this.gROUPNAME, this.gROUPID, this.gROUPCREATEDON,
      this.gROUPCREATEDBY, this.iSADMIN, this.tOTALUSERS);

  factory GetGroupListResponse.fromJson(json) {
    return GetGroupListResponse(
        json["GROUP_NAME"],
        json["GROUP_ID"].toString(),
        json["GROUP_CREATED_ON"],
        json["GROUP_CREATED_BY"],
        json["IS_ADMIN"],
        json["TOTAL_USERS"].toString());
  }
}
