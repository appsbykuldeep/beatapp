class EnquiryOfficer {
  //@SerializedName("PS_STAFF_CD")
  String? psStaffCd;

  //@SerializedName("NAME_RANK")
  String? nameRank;

  //@SerializedName("OFFICER_RANK")
  String? eoOfficerRank;

  EnquiryOfficer(this.psStaffCd, this.nameRank, this.eoOfficerRank);

  @override
  String toString() {
    return nameRank!;
  }

  factory EnquiryOfficer.fromJson(json) {
    return EnquiryOfficer(
        json["PS_STAFF_CD"].toString(), json["NAME_RANK"], json["OFFICER_RANK"]);
  }
}
