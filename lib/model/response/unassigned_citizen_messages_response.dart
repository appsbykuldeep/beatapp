class UnassignedCitizenMessagesResponse {
  //@SerializedName("PERSON_ID")
  String? pERSONID;

  //@SerializedName("DISTRICT")
  String? dISTRICT;

  //@SerializedName("PS")
  String? pS;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("MOBILE_NO")
  String? mOBILENO;

  //@SerializedName("SHARE_DT")
  String? sHAREDT;

  //@SerializedName("ASSIGN_STATUS")
  String? aSSIGNSTATUS;

  UnassignedCitizenMessagesResponse(this.pERSONID, this.dISTRICT, this.pS,
      this.nAME, this.mOBILENO, this.sHAREDT, this.aSSIGNSTATUS);

  factory UnassignedCitizenMessagesResponse.fromJson(json) {
    return UnassignedCitizenMessagesResponse(
        json["PERSON_ID"],
        json["DISTRICT"],
        json["PS"],
        json["NAME"],
        json["MOBILE_NO"],
        json["SHARE_DT"],
        json["ASSIGN_STATUS"]);
  }
}
