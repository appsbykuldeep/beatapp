class DomesticDetail_Table {
  //@SerializedName("DOMESTIC_SR_NUM")
  String? dOMESTICSRNUM;

  //@SerializedName("SERVANT_SR_NUM")
  String? sERVANTSRNUM;

  //@SerializedName("APPLICATION_DT")
  String? aPPLICATIONDT;

  //@SerializedName("REQUESTER_NAME")
  String? rEQUESTERNAME;

  //@SerializedName("RELATIONTYPE")
  String? rELATIONTYPE;

  //@SerializedName("RELATIVE_NAME")
  String? rELATIVENAME;

  //@SerializedName("PLACE_OF_BIRTH")
  String? pLACEOFBIRTH;

  //@SerializedName("AGE")
  String? aGE;

  //@SerializedName("ALIASES")
  String? aLIASES;

  //@SerializedName("ANY_CRIMINAL_RECORD")
  String? aNYCRIMINALRECORD;

  //@SerializedName("CRIME_DETAILS")
  String? cRIMEDETAILS;

  //@SerializedName("APPLICANT_MOBILE")
  String? aPPLICANTMOBILE;

  //@SerializedName("SERVANT_PRESENT_ADDRESS")
  String? sERVANTPRESENTADDRESS;

  //@SerializedName("SERVANT_PERMANENT_ADDRESS")
  String? sERVANTPERMANENTADDRESS;

  //@SerializedName("RELATIVE_MOBILE")
  String? rELATIVEMOBILE;

  //@SerializedName("RELATIVE_NAME1")
  String? rELATIVENAME1;

  //@SerializedName("RELATIVE_ADDRESS")
  String? rELATIVEADDRESS;

  //@SerializedName("HAS_PREV_WORKED")
  String? hASPREVWORKED;

  //@SerializedName("PREVIOUS_EMPLOYER_MOBILE")
  String? pREVIOUSEMPLOYERMOBILE;

  //@SerializedName("PREVIOUS_EMPLOYER_ADDRESS")
  String? pREVIOUSEMPLOYERADDRESS;

  //@SerializedName("PREV_EMPLOYR_NAME")
  String? pREVEMPLOYRNAME;

  //@SerializedName("PREV_EMPLYR_FRM_DT")
  String? pREVEMPLYRFRMDT;

  //@SerializedName("INTRODUCER_NAME")
  String? iNTRODUCERNAME;

  //@SerializedName("INTRODUCER_MOBILE")
  String? iNTRODUCERMOBILE;

  //@SerializedName("INTRODUCER_TELEPHONE")
  String? iNTRODUCERTELEPHONE;

  //@SerializedName("INTRODUCER_ADDRESS")
  String? iNTRODUCERADDRESS;

  DomesticDetail_Table(
      this.dOMESTICSRNUM,
      this.sERVANTSRNUM,
      this.aPPLICATIONDT,
      this.rEQUESTERNAME,
      this.rELATIONTYPE,
      this.rELATIVENAME,
      this.pLACEOFBIRTH,
      this.aGE,
      this.aLIASES,
      this.aNYCRIMINALRECORD,
      this.cRIMEDETAILS,
      this.aPPLICANTMOBILE,
      this.sERVANTPRESENTADDRESS,
      this.sERVANTPERMANENTADDRESS,
      this.rELATIVEMOBILE,
      this.rELATIVENAME1,
      this.rELATIVEADDRESS,
      this.hASPREVWORKED,
      this.pREVIOUSEMPLOYERMOBILE,
      this.pREVIOUSEMPLOYERADDRESS,
      this.pREVEMPLOYRNAME,
      this.pREVEMPLYRFRMDT,
      this.iNTRODUCERNAME,
      this.iNTRODUCERMOBILE,
      this.iNTRODUCERTELEPHONE,
      this.iNTRODUCERADDRESS);

  factory DomesticDetail_Table.fromJson(json) {
    return DomesticDetail_Table(
        json["DOMESTIC_SR_NUM"],
        json["SERVANT_SR_NUM"],
        json["APPLICATION_DT"],
        json["REQUESTER_NAME"],
        json["RELATIONTYPE"],
        json["RELATIVE_NAME"],
        json["PLACE_OF_BIRTH"],
        json["AGE"],
        json["ALIASES"],
        json["ANY_CRIMINAL_RECORD"],
        json["CRIME_DETAILS"],
        json["APPLICANT_MOBILE"],
        json["SERVANT_PRESENT_ADDRESS"],
        json["SERVANT_PERMANENT_ADDRESS"],
        json["RELATIVE_MOBILE"],
        json["RELATIVE_NAME1"],
        json["RELATIVE_ADDRESS"],
        json["HAS_PREV_WORKED"],
        json["PREVIOUS_EMPLOYER_MOBILE"],
        json["PREVIOUS_EMPLOYER_ADDRESS"],
        json["PREV_EMPLOYR_NAME"],
        json["PREV_EMPLYR_FRM_DT"],
        json["INTRODUCER_NAME"],
        json["INTRODUCER_MOBILE"],
        json["INTRODUCER_TELEPHONE"],
        json["INTRODUCER_ADDRESS"]);
  }

  factory DomesticDetail_Table.emptyData() {
    return DomesticDetail_Table(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null);
  }
}
