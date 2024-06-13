class PendingTenantResponseEo {
  //@SerializedName("TENANT_SR_NUM")
  String? tENANTSRNUM;

  //@SerializedName("REGISTERED_DT")
  String? rEGISTEREDDT;

  //@SerializedName("ASSIGNED_DT")
  String? aSSIGNEDDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("EO_NAME")
  String? eONAME;

  PendingTenantResponseEo(this.tENANTSRNUM, this.rEGISTEREDDT, this.aSSIGNEDDT,
      this.bEATCONSTABLENAME, this.eONAME);

  factory PendingTenantResponseEo.froJson(json) {
    return PendingTenantResponseEo(json["TENANT_SR_NUM"], json["REGISTERED_DT"],
        json["ASSIGNED_DT"], json["BEAT_CONSTABLE_NAME"], json["EO_NAME"]);
  }
}
