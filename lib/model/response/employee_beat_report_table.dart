class EmployeeBeatReport_Table {
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

  EmployeeBeatReport_Table(
      this.bEATCONSTABLENAME,
      this.iSRESOLVED,
      this.iSACCEPTED,
      this.aSSIGNEDDT,
      this.eNQFILLEDDT,
      this.tARGETDT,
      this.iSCRIMINALRECORD,
      this.lAT,
      this.lONG,
      this.pHOTO,
      this.rEMARKS,
      this.eONAME,
      this.eOREMARKS,
      this.eOREMARKSDT,
      this.sHOREMARKS,
      this.sHOREMARKSDT,
      this.sHOACTION);

  factory EmployeeBeatReport_Table.fromJson(json) {
    return EmployeeBeatReport_Table(
        json["BEAT_CONSTABLE_NAME"],
        json["IS_RESOLVED"],
        json["IS_ACCEPTED"],
        json["ASSIGNED_DT"],
        json["ENQ_FILLED_DT"],
        json["TARGET_DT"],
        json["IS_CRIMINAL_RECORD"],
        json["LAT"],
        json["LONG"],
        json["PHOTO"],
        json["REMARKS"],
        json["EO_NAME"],
        json["EO_REMARKS"],
        json["EO_REMARKS_DT"],
        json["SHO_REMARKS"],
        json["SHO_REMARKS_DT"],
        json["SHO_ACTION"]);
  }
}
