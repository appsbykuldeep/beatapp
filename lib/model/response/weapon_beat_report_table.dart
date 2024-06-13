class WeaponBeatReport_Table {
  /* //@SerializedName("VILLAGE_NAME")
     String? vILLAGENAME;
    //@SerializedName("BEAT_NAME")
    
     String? bEATNAME;*/
  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("FILL_DT")
  String? fILLDT;

  //@SerializedName("REMARKS")
  String? rEMARKS;

  //@SerializedName("IS_RESOLVED")
  String? iSRESOLVED;

  //@SerializedName("PHOTO")
  String? pHOTO;

  //@SerializedName("VARIFICATION_STATUS")
  String? vARIFICATIONSTATUS;

  //@SerializedName("LAT")
  String? lAT;

  //@SerializedName("LONG")
  String? lONG;

  WeaponBeatReport_Table(
      this.bEATCONSTABLENAME,
      this.fILLDT,
      this.rEMARKS,
      this.iSRESOLVED,
      this.pHOTO,
      this.vARIFICATIONSTATUS,
      this.lAT,
      this.lONG);

  factory WeaponBeatReport_Table.fromJson(json) {
    return WeaponBeatReport_Table(
        json["BEAT_CONSTABLE_NAME"],
        json["FILL_DT"],
        json["REMARKS"],
        json["IS_RESOLVED"],
        json["PHOTO"],
        json["VARIFICATION_STATUS"],
        json["LAT"],
        json["LONG"]);
  }
}
