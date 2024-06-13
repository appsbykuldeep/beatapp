class CompletedDomesticResponseEo {
  //@SerializedName("DOMESTIC_SR_NUM")
  String? dOMESTICSRNUM;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("COMP_DT")
  String? cOMPDT;

  //@SerializedName("APPLICANTNAME")
  String? aPPLICANTNAME;

  CompletedDomesticResponseEo(this.dOMESTICSRNUM, this.rEGISTEREDDT,
      this.aSSIGNEDDT, this.bEATCONSTABLENAME, this.cOMPDT, this.aPPLICANTNAME);

  factory CompletedDomesticResponseEo.fromJson(Map<String, dynamic> json) {
    return CompletedDomesticResponseEo(json["DOMESTIC_SR_NUM"], json["REGISTERED_DT"],
        json["ASSIGNED_DT"], json["BEAT_CONSTABLE_NAME"], json["COMP_DT"], json["APPLICANTNAME"]);
  }
}
