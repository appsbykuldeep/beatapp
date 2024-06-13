class BeatConstableListByPSResponse {
  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("CUG")
  String? cUG;

  //@SerializedName("OFFICER_RANK")
  String? oFFICERRANK;

  //@SerializedName("LOGIN_ID")
  String? lOGINID;

  //@SerializedName("RECORD_ADDED_ON")
  String? rECORDADDEDON;

  BeatConstableListByPSResponse(
      this.nAME, this.cUG, this.oFFICERRANK, this.lOGINID, this.rECORDADDEDON);

  factory BeatConstableListByPSResponse.fromJson(Map<String, dynamic> json) {
    return BeatConstableListByPSResponse(json["NAME"], json["CUG"],
        json["OFFICER_RANK"], json["LOGIN_ID"], json["RECORD_ADDED_ON"]);
  }
}
