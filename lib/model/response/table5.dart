class Table5 {
  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("LAT")
  String? lAT;

  //@SerializedName("LONG")
  String? lONG;

  //@SerializedName("DELEIVERED_TO_NAME")
  String? dELEIVEREDTONAME;

  //@SerializedName("PHOTO")
  String? pHOTO;

  //@SerializedName("REMARKS")
  String? rEMARKS;

  //@SerializedName("IS_DELIVERED")
  String? iSDELIVERED;

  //@SerializedName("COMPLETED_DT")
  String? cOMPLETEDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("EXECUTION_TYPE")
  String? eXECUTIONTYPE;

  //@SerializedName("ENQ_DT")
  String? eNQ_DT;

  Table5(
      this.bEATCONSTABLENAME,
      this.lAT,
      this.lONG,
      this.dELEIVEREDTONAME,
      this.pHOTO,
      this.rEMARKS,
      this.iSDELIVERED,
      this.cOMPLETEDDT,
      this.aSSIGNEDDT,
      this.eXECUTIONTYPE,
      this.eNQ_DT);

  factory Table5.fromJson(json) {
    return Table5(
        json["BEAT_CONSTABLE_NAME"],
        json["LAT"],
        json["LONG"],
        json["DELEIVERED_TO_NAME"],
        json["PHOTO"],
        json["REMARKS"],
        json["IS_DELIVERED"],
        json["COMPLETED_DT"],
        json["ASSIGNED_DT"],
        json["EXECUTION_TYPE"],
        json["ENQ_DT"]);
  }

  static List<Table5> fromJsonArray(json) {
    List<Table5> lstData = [];
    for (Map<String, dynamic> i in json) {
      var data = Table5.fromJson(i);
      lstData.add(data);
    }
    return lstData;
  }
}
