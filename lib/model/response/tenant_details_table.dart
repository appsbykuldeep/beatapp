class TenantDetails_Table {
  //@SerializedName("TENANT_SR_NUM")
  String? tENANTSRNUM;

  //@SerializedName("OWNER_NAME")
  String? oWNERNAME;

  //@SerializedName("OWNER_EMAIL")
  String? oWNEREMAIL;

  //@SerializedName("OWNER_MOBILE")
  String? oWNERMOBILE;

  //@SerializedName("OCCUPATION")
  String? oCCUPATION;

  //@SerializedName("OWNER_ADDRESS")
  String? oWNERADDRESS;

  //@SerializedName("TENANT_NAME")
  String? tENANTNAME;

  //@SerializedName("GENDER")
  String? gender;

  //@SerializedName("TENANT_MOBILE")
  String? tENANTMOBILE;

  //@SerializedName("TENANT_EMAIL")
  String? tENANTEMAIL;

  //@SerializedName("RELATION_TYPE")
  String? rELATIONTYPE;

  //@SerializedName("RELATIVE_NAME")
  String? rELATIVENAME;

  //@SerializedName("AGE")
  String? aGE;

  //@SerializedName("TENANCY_PURPOSE")
  String? tENANCYPURPOSE;

  //@SerializedName("OCCUPATION1")
  String? oCCUPATION1;

  //@SerializedName("TENANT_PERMANENT_ADDRESS")
  String? tENANTPERMANENTADDRESS;

  //@SerializedName("TENANT_PRESENT_ADDRESS")
  String? tENANTPRESENTADDRESS;

  //@SerializedName("TENANT_PREVIOUS_ADDRESS")
  String? tENANTPREVIOUSADDRESS;

  TenantDetails_Table(
      this.tENANTSRNUM,
      this.oWNERNAME,
      this.oWNEREMAIL,
      this.oWNERMOBILE,
      this.oCCUPATION,
      this.oWNERADDRESS,
      this.tENANTNAME,
      this.gender,
      this.tENANTMOBILE,
      this.tENANTEMAIL,
      this.rELATIONTYPE,
      this.rELATIVENAME,
      this.aGE,
      this.tENANCYPURPOSE,
      this.oCCUPATION1,
      this.tENANTPERMANENTADDRESS,
      this.tENANTPRESENTADDRESS,
      this.tENANTPREVIOUSADDRESS);

  factory TenantDetails_Table.fromJson(json) {
    return TenantDetails_Table(
        json["TENANT_SR_NUM"],
        json["OWNER_NAME"],
        json["OWNER_EMAIL"],
        json["OWNER_MOBILE"],
        json["OCCUPATION"],
        json["OWNER_ADDRESS"],
        json["TENANT_NAME"],
        json["GENDER"],
        json["TENANT_MOBILE"],
        json["TENANT_EMAIL"],
        json["RELATION_TYPE"],
        json["RELATIVE_NAME"],
        json["AGE"],
        json["TENANCY_PURPOSE"],
        json["OCCUPATION1"],
        json["TENANT_PERMANENT_ADDRESS"],
        json["TENANT_PRESENT_ADDRESS"],
        json["TENANT_PREVIOUS_ADDRESS"]);
  }
}
