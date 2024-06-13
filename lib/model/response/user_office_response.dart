class UserOfficeResponse {
  //@SerializedName("OFFICETYPE")
  String? officeType;

  //@SerializedName("OFFICENAME")
  String? officeName;

  //@SerializedName("OFFICECODE")
  String? officeCode;

  //@SerializedName("ROLECD")
  String? roleCd;

  //@SerializedName("ROLE")
  String? role;

  //@SerializedName("BASEOFFICECD")
  String? baseOfficeCd;

  //@SerializedName("DISTRICT_CD")
  String? districtCd;

  bool isSelected = false;

  UserOfficeResponse(this.officeType, this.officeName, this.officeCode,
      this.roleCd, this.role, this.baseOfficeCd, this.districtCd);

  factory UserOfficeResponse.fromJson(json) {
    return UserOfficeResponse(
        json['OFFICETYPE'].toString(),
        json['OFFICENAME'].toString(),
        json['OFFICECODE'].toString(),
        json['ROLECD'].toString(),
        json['ROLE'].toString(),
        json['BASEOFFICECD'].toString(),
        json['DISTRICT_CD'].toString());
  }
}
