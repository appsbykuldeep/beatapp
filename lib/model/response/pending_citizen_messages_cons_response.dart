class PendingCitizenMessagesConsResponse {
  //@SerializedName("PERSON_ID")
  String? pERSONID;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("REG_DT")
  String? rEGDT;

  //@SerializedName("ASSIGNED_ON")
  String? aSSIGNEDON;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("EO_NAME")
  String? eONAME;

  PendingCitizenMessagesConsResponse(this.pERSONID, this.nAME, this.rEGDT,
      this.aSSIGNEDON, this.tARGETDT, this.eONAME);

  factory PendingCitizenMessagesConsResponse.fromJson(json) {
    return PendingCitizenMessagesConsResponse(
        json["PERSON_ID"],
        json["NAME"],
        json["REG_DT"],
        json["ASSIGNED_ON"],
        json["TARGET_DT"],
        json["EO_NAME"]);
  }
}
