class GetFirListResponse {
  //@SerializedName("FIR_REG_NUM")//@Expose
  String? firRegNum;

  //@SerializedName("REG_DT")//@Expose
  String? regDt;

  //@SerializedName("SRNO")//@Expose
  String? srno;

  //@SerializedName("ORG_NUMBER")
  String? orgNumber;

  //@SerializedName("IS_FIR_BLOCK")
  String? isFirBlock;

  GetFirListResponse(
      this.firRegNum, this.regDt, this.srno, this.orgNumber, this.isFirBlock);

  factory GetFirListResponse.fromJson(json) {
    return GetFirListResponse(json["FIR_REG_NUM"], json["REG_DT"], json["SRNO"],
        json["ORG_NUMBER"], json["IS_FIR_BLOCK"]);
  }
}
