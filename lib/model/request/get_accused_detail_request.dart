class GetAccusedDetailRequest {
  //@SerializedName("PS_CD")
  String? psCd;

  //@SerializedName("ACCUSED_SRNO")
  String? accusedSrNo;

  GetAccusedDetailRequest(this.psCd, this.accusedSrNo);

  Map<String, dynamic> toJson() =>
      {"PS_CD": psCd, "ACCUSED_SRNO": accusedSrNo};
}
