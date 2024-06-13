class DomesticBeatReport_Table {
  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("IS_RESOLVED")
  String? iSRESOLVED;

  //@SerializedName("IS_ACCEPTED")
  String? iSACCEPTED;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("ENQ_FILLED_DT")
  String? eNQFILLEDDT;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("IS_CRIMINAL_RECORD")
  String? iSCRIMINALRECORD;

  //@SerializedName("LAT")
  String? lAT;

  //@SerializedName("LONG")
  String? lONG;

  //@SerializedName("PHOTO")
  String? pHOTO;

  //@SerializedName("REMARKS")
  String? rEMARKS;

  //@SerializedName("RECORD_CREATED_ON")
  String? rECORDCREATEDON;

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

  //@SerializedName("PREV_EMPLYR_REPORT")
  String? prevEmplyrReport;

  //@SerializedName("NEIGHBOUR_REPORT")
  String? neighbourReport;

  DomesticBeatReport_Table(this.bEATCONSTABLENAME,
      this.iSRESOLVED,
      this.iSACCEPTED,
      this.aSSIGNEDDT,
      this.eNQFILLEDDT,
      this.tARGETDT,
      this.cOMPDT,
      this.iSCRIMINALRECORD,
      this.lAT,
      this.lONG,
      this.pHOTO,
      this.rEMARKS,
      this.rECORDCREATEDON,
      this.eONAME,
      this.eOREMARKS,
      this.eOREMARKSDT,
      this.sHOREMARKS,
      this.sHOREMARKSDT,
      this.sHOACTION,
      this.prevEmplyrReport,
      this.neighbourReport);

  factory DomesticBeatReport_Table.fromJson(json){
    return DomesticBeatReport_Table(
        json["BEAT_CONSTABLE_NAME"],
        json["IS_RESOLVED"],
        json["IS_ACCEPTED"],
        json["ASSIGNED_DT"],
        json["ENQ_FILLED_DT"],
        json["TARGET_DT"],
        json["COMP_DT"],
        json["IS_CRIMINAL_RECORD"],
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
        json["SHO_ACTION"],
        json["PREV_EMPLYR_REPORT"],
        json["NEIGHBOUR_REPORT"]);
  }
}
