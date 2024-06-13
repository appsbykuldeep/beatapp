
class GetRoleBasedDistrictResponse {
  //@SerializedName("DISTRICT_CD")
  String? dISTRICTCD;

  //@SerializedName("DISTRICT")
  String? dISTRICT;

  GetRoleBasedDistrictResponse(this.dISTRICTCD, this.dISTRICT);

  factory GetRoleBasedDistrictResponse.fromJson(json) {
    return GetRoleBasedDistrictResponse(json["DISTRICT_CD"], json["DISTRICT"]);
  }

}
