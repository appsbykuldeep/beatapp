class CompletedTenantResponseEo {
  //@SerializedName("TENANT_SR_NUM")
  String? tENANTSRNUM;

  //@SerializedName("COMPLETED_DT")
  String? cOMPLETEDDT;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("EO_NAME")
  String? eONAME;

  CompletedTenantResponseEo(this.tENANTSRNUM, this.cOMPLETEDDT,
      this.rEGISTEREDDT, this.bEATCONSTABLENAME, this.eONAME);

  factory CompletedTenantResponseEo.fromJson(json) {
    return CompletedTenantResponseEo(
        json["TENANT_SR_NUM"],
        json["COMPLETED_DT"],
        json["REGISTERED_DT"],
        json["BEAT_CONSTABLE_NAME"],
        json["EO_NAME"]);
  }
}
