class GetBeatConsByBeatCDResponse {
  //@SerializedName("PNO")
  String? pNO;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("OFFICER_RANK")
  String? oFFICERRANK;

  GetBeatConsByBeatCDResponse(
      this.pNO, this.bEATCONSTABLENAME, this.oFFICERRANK);

  factory GetBeatConsByBeatCDResponse.fromJson(json) {
    return GetBeatConsByBeatCDResponse(
        json["BEAT_CD"], json["BEAT_NAME"], json["PS_CD"]);
  }
}
