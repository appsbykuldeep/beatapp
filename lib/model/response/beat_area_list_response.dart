class BeatAreaListResponse {
  //@SerializedName("BEAT_NAME")
  String? bEATNAME;

  //@SerializedName("AREA_SR_NUM")
  String? aREASRNUM;

  //@SerializedName("AREA_NAME")
  String? aREANAME;

  //@SerializedName("CREATED_DATE")
  String? cREATEDDATE;

  BeatAreaListResponse(
      this.bEATNAME, this.aREASRNUM, this.aREANAME, this.cREATEDDATE);

  factory BeatAreaListResponse.fromJson(Map<String, dynamic> json) {
    return BeatAreaListResponse(
        json["BEAT_NAME"],
        json["AREA_SR_NUM"].toString(),
        json["AREA_NAME"],
        json["CREATED_DATE"]);
  }
}
