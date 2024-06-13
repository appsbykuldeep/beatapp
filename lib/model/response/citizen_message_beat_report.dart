class CitizenMessageBeatReport {
  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("IS_RESOLVED")
  String? iSRESOLVED;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("LAT")
  String? lAT;

  //@SerializedName("LONG")
  String? lONG;

  //@SerializedName("PHOTO")
  String? pHOTO;

  //@SerializedName("REMARKS")
  String? rEMARKS;

  //@SerializedName("RECORD_CREATED_ON")
  String? recordCreatedOn;

  //@SerializedName("EO_NAME")
  String? eONAME;

  //@SerializedName("EO_REMARKS")
  String? eOREMARKS;

  //@SerializedName("EO_REMARKS_DT")
  String? eOREMARKSDT;

  //@SerializedName("SHO_REMARKS")
  String? sHOREMARKS;

  //@SerializedName("SHO_REMARKS_DT")
  String? sHOREMARKSDT;

  //@SerializedName("SHO_ACTION")
  String? sHOACTION;

  CitizenMessageBeatReport(
      this.bEATCONSTABLENAME,
      this.iSRESOLVED,
      this.aSSIGNEDDT,
      this.cOMPDT,
      this.tARGETDT,
      this.lAT,
      this.lONG,
      this.pHOTO,
      this.rEMARKS,
      this.recordCreatedOn,
      this.eONAME,
      this.eOREMARKS,
      this.eOREMARKSDT,
      this.sHOREMARKS,
      this.sHOREMARKSDT,
      this.sHOACTION);

  factory CitizenMessageBeatReport.fromJson(Map<String, dynamic> json) {
    return CitizenMessageBeatReport(
        json["BEAT_CONSTABLE_NAME"],
        json["IS_RESOLVED"],
        json["ASSIGNED_DT"],
        json["COMP_DT"],
        json["TARGET_DT"],
        json["LAT"],
        json["LONG"],
        json["PHOTO"],
        json["REMARKS"],
        json["RECORD_CREATED_ON"],
        json["EO_NAME"],
        json["EO_REMARKS"],
        json["EO_REMARKS_DT"],
        json["SHO_REMARKS"],
        json["SHO_REMARKS_DT"],
        json["SHO_ACTION"]);
  }
}
