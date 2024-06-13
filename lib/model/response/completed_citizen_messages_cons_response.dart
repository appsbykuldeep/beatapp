class CompletedCitizenMessagesConsResponse {
  //@SerializedName("PERSON_ID")
  String? pERSONID;

  //@SerializedName("NAME")
  String? name;

  //@SerializedName("REG_DT")
  String? rEGDT;

  //@SerializedName("ASSIGNED_ON")
  String? aSSIGNEDON;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("EO_NAME")
  String? eONAME;

  CompletedCitizenMessagesConsResponse(this.pERSONID, this.name, this.rEGDT,
      this.aSSIGNEDON, this.tARGETDT, this.cOMPDT, this.eONAME);

  factory CompletedCitizenMessagesConsResponse.fromJson(
      Map<String, dynamic> json) {
    return CompletedCitizenMessagesConsResponse(
        json["PERSON_ID"],
        json["NAME"],
        json["REG_DT"],
        json["ASSIGNED_ON"],
        json["TARGET_DT"],
        json["COMP_DT"],
        json["EO_NAME"]);
  }
}
