class PendingDomesticResponseEo {
  //@SerializedName("DOMESTIC_SR_NUM")
  String? dOMESTICSRNUM;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("APPLICANTNAME")
  String? aPPLICANTNAME;

  PendingDomesticResponseEo(this.dOMESTICSRNUM, this.rEGISTEREDDT,
      this.aSSIGNEDDT, this.bEATCONSTABLENAME, this.aPPLICANTNAME);

  factory PendingDomesticResponseEo.fromJson(json) {
    return PendingDomesticResponseEo(
        json["DOMESTIC_SR_NUM"],
        json["REGISTERED_DT"],
        json["ASSIGNED_DT"],
        json["BEAT_CONSTABLE_NAME"],
        json["APPLICANTNAME"]);
  }
}
