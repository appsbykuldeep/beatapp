class CitizenMessagesRequest {
  //@SerializedName("DISTRICT_CD")
  String? districtCd;

  //@SerializedName("PS_CD")
  String? psCd;

  CitizenMessagesRequest(this.districtCd, this.psCd);

  Map<String, dynamic> toJson() => {"DISTRICT_CD": districtCd, "PS_CD": psCd};
}
