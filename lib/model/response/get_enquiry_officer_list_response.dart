class GetEnquiryOfficerListResponse {
  //@SerializedName("PS_STAFF_CD")
  String? pSSTAFFCD;

  //@SerializedName("NAME_RANK")
  String? nAMERANK;

  //@SerializedName("OFFICER_RANK")
  String? oFFICERRANK;

  GetEnquiryOfficerListResponse(
      this.pSSTAFFCD, this.nAMERANK, this.oFFICERRANK);

  factory GetEnquiryOfficerListResponse.fromJson(json) {
    return GetEnquiryOfficerListResponse(
        json["PS_STAFF_CD"], json["NAME_RANK"], json["OFFICER_RANK"]);
  }
}
