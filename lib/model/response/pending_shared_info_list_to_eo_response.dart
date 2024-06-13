class PendingSharedInfoListToEoResponse {
  //@SerializedName("PERSON_ID")
  String? pERSONID;
  String beatName;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("REG_DT")
  String? rEGDT;

  //@SerializedName("ASSIGNED_ON")
  String? aSSIGNEDON;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  PendingSharedInfoListToEoResponse(this.pERSONID, this.nAME,this.beatName, this.rEGDT,
      this.aSSIGNEDON, this.tARGETDT, this.cOMPDT, this.bEATCONSTABLENAME);

  factory PendingSharedInfoListToEoResponse.fromJson(json) {
    return PendingSharedInfoListToEoResponse(
        json["PERSON_ID"].toString(),
        json["NAME"],
        json["BEAT_NAME"]??'',
        json["REG_DT"],
        json["ASSIGNED_ON"],
        json["TARGET_DT"],
        json["COMP_DT"],
        json["BEAT_CONSTABLE_NAME"]);
  }
}
