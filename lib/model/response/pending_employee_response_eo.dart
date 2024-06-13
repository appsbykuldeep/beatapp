class PendingEmployeeResponseEo {
  //@SerializedName("EMPLOYEE_SR_NUM")
  String? eMPLOYEESRNUM;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("TARGET_DT")
  String? tARGETDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("EMPLOYEE_NAME")
  String? eMPLOYEENAME;

  //@SerializedName("REQUESTING_AGENCY_NAME")
  String? rEQUESTINGAGENCYNAME;

  //@SerializedName("EO_NAME")
  String? eONAME;

  PendingEmployeeResponseEo(
      this.eMPLOYEESRNUM,
      this.rEGISTEREDDT,
      this.aSSIGNEDDT,
      this.tARGETDT,
      this.bEATCONSTABLENAME,
      this.eMPLOYEENAME,
      this.rEQUESTINGAGENCYNAME,
      this.eONAME);

  factory PendingEmployeeResponseEo.fromJson(json) {
    return PendingEmployeeResponseEo(
        json["EMPLOYEE_SR_NUM"],
        json["REGISTERED_DT"],
        json["ASSIGNED_DT"],
        json["TARGET_DT"],
        json["BEAT_CONSTABLE_NAME"],
        json["EMPLOYEE_NAME"],
        json["REQUESTING_AGENCY_NAME"],
        json["EO_NAME"]);
  }
}
