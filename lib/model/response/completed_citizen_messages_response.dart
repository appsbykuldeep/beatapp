class CompletedCitizenMessagesResponse {
  //@SerializedName("PERSON_ID")
  String? pERSONID;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("COMPLAINANT NAME")
  String? cOMPLAINANTNAME;

  //@SerializedName("EO_NAME")
  String? eONAME;

  CompletedCitizenMessagesResponse(
      this.pERSONID,
      this.rEGISTEREDDT,
      this.aSSIGNEDDT,
      this.tARGETDT,
      this.cOMPDT,
      this.bEATCONSTABLENAME,
      this.cOMPLAINANTNAME,
      this.eONAME);

  factory CompletedCitizenMessagesResponse.fromJson(Map<String, dynamic> json) {
    return CompletedCitizenMessagesResponse(
        json["PERSON_ID"],
        json["REGISTERED_DT"],
        json["ASSIGNED_DT"],
        json["TARGET_DT"],
        json["COMP_DT"],
        json["BEAT_CONSTABLE_NAME"],
        json["COMPLAINANT"],
        json["EO_NAME"]);
  }
}
