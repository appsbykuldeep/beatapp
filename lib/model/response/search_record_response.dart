class SearchRecordResponse {
  //@SerializedName("SERVICE_TYPE")
  String? sERVICETYPE;

  //@SerializedName("APPLICATION_SR_NUM")
  String? aPPLICATIONSRNUM;

  //@SerializedName("APPLICATION_DT")
  String? aPPLICATIONDT;

  //@SerializedName("REQUESTER_NAME")
  String? rEQUESTERNAME;

  SearchRecordResponse(this.sERVICETYPE, this.aPPLICATIONSRNUM,
      this.aPPLICATIONDT, this.rEQUESTERNAME);

  factory SearchRecordResponse.fromJson(json){
    return SearchRecordResponse(
        json["SERVICE_TYPE"], json["APPLICATION_SR_NUM"],
        json["APPLICATION_DT"], json["REQUESTER_NAME"]);
  }
}
