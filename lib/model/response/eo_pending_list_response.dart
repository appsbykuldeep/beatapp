class EoPendingListResponse {
  //@SerializedName("SERVICE_TYPE")
  String? sERVICETYPE;

  //@SerializedName("SERVICE_NAME")
  String? sERVICENAME;

  //@SerializedName("APPLICATION_SR_NUM")
  String? aPPLICATIONSRNUM;

  //@SerializedName("REQUESTER_NAME")
  String? rEQUESTERNAME;

  //@SerializedName("APPLICATION_DT")
  String? aPPLICATIONDT;

  //@SerializedName("COMPL_DT")
  String? cOMPLDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  EoPendingListResponse(
      this.sERVICETYPE,
      this.sERVICENAME,
      this.aPPLICATIONSRNUM,
      this.rEQUESTERNAME,
      this.aPPLICATIONDT,
      this.cOMPLDT,
      this.bEATCONSTABLENAME);

  factory EoPendingListResponse.fromJson(json) {
    return EoPendingListResponse(
        json["SERVICE_TYPE"],
        json["SERVICE_NAME"],
        json["APPLICATION_SR_NUM"],
        json["REQUESTER_NAME"],
        json["APPLICATION_DT"],
        json["COMPL_DT"],
        json["BEAT_CONSTABLE_NAME"]);
  }
}
