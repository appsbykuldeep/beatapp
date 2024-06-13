class SummaryResponse {
  //@SerializedName("REGISTERED_SUMMON")
  String? rEGISTEREDSUMMON;

  //@SerializedName("ASSIGNED_SUMMON")
  String? aSSIGNEDSUMMON;

  //@SerializedName("COMPLETED_SUMMON")
  String? cOMPLETEDSUMMON;

  //@SerializedName("PENDING_ARREST")
  String? pENDINGARREST;

  //@SerializedName("ASSIGNED_ARR")
  String? aSSIGNEDARR;

  //@SerializedName("COMPLETED_ARR")
  String? cOMPLETEDARR;

  //@SerializedName("SHARED_INFO")
  String? sHAREDINFO;

  //@SerializedName("SOOCHNA_INFO")
  String? sOOCHNAINFO;

  //@SerializedName("BEAT_USERS")
  String? bEATUSERS;

  //@SerializedName("DUITY_ASSIGNED")
  String? dUITYASSIGNED;

  //@SerializedName("BEATS")
  String? bEATS;

  //@SerializedName("TOTAL_CS_SHARED_COUNT")
  String? tOTALCSSHAREDCOUNT;

  //@SerializedName("PENDING_CS_SHAREDINFO_COUNT")
  String? pENDINGCSSHAREDINFOCOUNT;

  //@SerializedName("COMPLETED_CS_SHAREDINFO_COUNT")
  String? cOMPLETEDCSSHAREDINFOCOUNT;

  //@SerializedName("TOTAL_CHARCACTER_COUNT")
  String? tOTALCHARCACTERCOUNT;

  //@SerializedName("PENDING_CHAR_COUNT")
  String? pENDINGCHARCOUNT;

  //@SerializedName("COMPLETED_CHAR_COUNT")
  String? cOMPLETEDCHARCOUNT;

  //@SerializedName("TOTAL_TENANT_COUNT")
  String? tOTALTENANTCOUNT;

  //@SerializedName("PENDING_TENANT_COUNT")
  String? pENDINGTENANTCOUNT;

  //@SerializedName("COMPLETED_TENANT_COUNT")
  String? cOMPLETEDTENANTCOUNT;

  //@SerializedName("TOTAL_EMPLOYEE_COUNT")
  String? tOTALEMPLOYEECOUNT;

  //@SerializedName("PENDING_EMPLOYEE_COUNT")
  String? pENDINGEMPLOYEECOUNT;

  //@SerializedName("COMPLETED_EMPLOYEE_COUNT")
  String? cOMPLETEDEMPLOYEECOUNT;

  //@SerializedName("TOTAL_DOMESTIC_COUNT")
  String? tOTALDOMESTICCOUNT;

  //@SerializedName("PENDING_DOMESTIC_COUNT")
  String? pENDINGDOMESTICCOUNT;

  //@SerializedName("COMPLETED_DOMESTIC_COUNT")
  String? cOMPLETEDDOMESTICCOUNT;

  //@SerializedName("VERIFIED_WEAPON_COUNT")
  String? vERIFIEDWEAPONCOUNT;

  //@SerializedName("UNVERIFIED_WEAPON_COUNT")
  String? uNVERIFIEDWEAPONCOUNT;

  //@SerializedName("VERIFIED_HST_COUNT")
  String? vERIFIEDHSTCOUNT;

  //@SerializedName("UNVERIFIED_HST_COUNT")
  String? uNVERIFIEDHSTCOUNT;

  SummaryResponse(
      this.rEGISTEREDSUMMON,
      this.aSSIGNEDSUMMON,
      this.cOMPLETEDSUMMON,
      this.pENDINGARREST,
      this.aSSIGNEDARR,
      this.cOMPLETEDARR,
      this.sHAREDINFO,
      this.sOOCHNAINFO,
      this.bEATUSERS,
      this.dUITYASSIGNED,
      this.bEATS,
      this.tOTALCSSHAREDCOUNT,
      this.pENDINGCSSHAREDINFOCOUNT,
      this.cOMPLETEDCSSHAREDINFOCOUNT,
      this.tOTALCHARCACTERCOUNT,
      this.pENDINGCHARCOUNT,
      this.cOMPLETEDCHARCOUNT,
      this.tOTALTENANTCOUNT,
      this.pENDINGTENANTCOUNT,
      this.cOMPLETEDTENANTCOUNT,
      this.tOTALEMPLOYEECOUNT,
      this.pENDINGEMPLOYEECOUNT,
      this.cOMPLETEDEMPLOYEECOUNT,
      this.tOTALDOMESTICCOUNT,
      this.pENDINGDOMESTICCOUNT,
      this.cOMPLETEDDOMESTICCOUNT,
      this.vERIFIEDWEAPONCOUNT,
      this.uNVERIFIEDWEAPONCOUNT,
      this.vERIFIEDHSTCOUNT,
      this.uNVERIFIEDHSTCOUNT);

  factory SummaryResponse.fromJson(json) {
    return SummaryResponse(
        json["REGISTERED_SUMMON"].toString(),
        json["ASSIGNED_SUMMON"].toString(),
        json["COMPLETED_SUMMON"].toString(),
        json["PENDING_ARREST"].toString(),
        json["ASSIGNED_ARR"].toString(),
        json["COMPLETED_ARR"].toString(),
        json["SHARED_INFO"].toString(),
        json["SOOCHNA_INFO"].toString(),
        json["BEAT_USERS"].toString(),
        json["DUITY_ASSIGNED"].toString(),
        json["BEATS"].toString(),
        json["TOTAL_CS_SHARED_COUNT"].toString(),
        json["PENDING_CS_SHAREDINFO_COUNT"].toString(),
        json["COMPLETED_CS_SHAREDINFO_COUNT"].toString(),
        json["TOTAL_CHARCACTER_COUNT"].toString(),
        json["PENDING_CHAR_COUNT"].toString(),
        json["COMPLETED_CHAR_COUNT"].toString(),
        json["TOTAL_TENANT_COUNT"].toString(),
        json["PENDING_TENANT_COUNT"].toString(),
        json["COMPLETED_TENANT_COUNT"].toString(),
        json["TOTAL_EMPLOYEE_COUNT"].toString(),
        json["PENDING_EMPLOYEE_COUNT"].toString(),
        json["COMPLETED_EMPLOYEE_COUNT"].toString(),
        json["TOTAL_DOMESTIC_COUNT"].toString(),
        json["PENDING_DOMESTIC_COUNT"].toString(),
        json["COMPLETED_DOMESTIC_COUNT"].toString(),
        json["VERIFIED_WEAPON_COUNT"].toString(),
        json["UNVERIFIED_WEAPON_COUNT"].toString(),
        json["VERIFIED_HST_COUNT"].toString(),
        json["UNVERIFIED_HST_COUNT"].toString());
  }
}
