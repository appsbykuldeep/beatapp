class EmployeeVerificationDetail {
  //@SerializedName("APPLICATION_DT")
  String? aPPLICATIONDT;

  //@SerializedName("CURR_EMPLYR_LANDLINE")
  String? cURREMPLYRLANDLINE;

  //@SerializedName("CURR_EMPLYR_MOBILE")
  String? cURREMPLYRMOBILE;

  //@SerializedName("CURR_EMPLYR_NAME")
  String? cURREMPLYRNAME;

  //@SerializedName("CURR_EMPLYR_ROLE")
  String? cURREMPLYRROLE;

  //@SerializedName("EMPLOYEE_SR_NUM")
  String? eMPLOYEESRNUM;

  //@SerializedName("PREV_EMPLYR_FRM_DT")
  String? pREVEMPLYRFRMDT;

  //@SerializedName("PREV_EMPLYR_LANDLINE")
  String? pREVEMPLYRLANDLINE;

  //@SerializedName("PREV_EMPLYR_MOBILE")
  String? pREVEMPLYRMOBILE;

  //@SerializedName("PREV_EMPLYR_NAME")
  String? pREVEMPLYRNAME;

  //@SerializedName("PREV_EMPLYR_ROLE")
  String? pREVEMPLYRROLE;

  //@SerializedName("PREV_EMPLYR_TO_DT")
  String? pREVEMPLYRTODT;

  //@SerializedName("REQUESTING_AGENCY_EMAIL")
  String? rEQUESTINGAGENCYEMAIL;

  //@SerializedName("REQUESTING_AGENCY_NAME")
  String? rEQUESTINGAGENCYNAME;

  //@SerializedName("EMPLOYEE_PERMANENT_ADDRESS")
  String? eMPLOYEEPERMANENTADDRESS;

  //@SerializedName("EMPLOYEE_PRESENT_ADDRESS")
  String? eMPLOYEEPRESENTADDRESS;

  //@SerializedName("EMPLOYEE_PREVIOUS_ADDRESS")
  String? eMPLOYEEPREVIOUSADDRESS;

  //@SerializedName("AGE")
  String? aGE;

  //@SerializedName("EMPLOYEE_NAME")
  String? eMPLOYEENAME;

  //@SerializedName("RELATIONTYPE")
  String? rELATIONTYPE;

  //@SerializedName("RELATIVE_NAME")
  String? rELATIVENAME;

  //@SerializedName("PREVIOUS_EMPLOYER_ADDRESS")
  String? pREVIOUSEMPLOYERADDRESS;

  //@SerializedName("CURRENT_EMPLOYER_ADDRESS")
  String? cURRENTEMPLOYERADDRESS;

  EmployeeVerificationDetail(
      this.aPPLICATIONDT,
      this.cURREMPLYRLANDLINE,
      this.cURREMPLYRMOBILE,
      this.cURREMPLYRNAME,
      this.cURREMPLYRROLE,
      this.eMPLOYEESRNUM,
      this.pREVEMPLYRFRMDT,
      this.pREVEMPLYRLANDLINE,
      this.pREVEMPLYRMOBILE,
      this.pREVEMPLYRNAME,
      this.pREVEMPLYRROLE,
      this.pREVEMPLYRTODT,
      this.rEQUESTINGAGENCYEMAIL,
      this.rEQUESTINGAGENCYNAME,
      this.eMPLOYEEPERMANENTADDRESS,
      this.eMPLOYEEPRESENTADDRESS,
      this.eMPLOYEEPREVIOUSADDRESS,
      this.aGE,
      this.eMPLOYEENAME,
      this.rELATIONTYPE,
      this.rELATIVENAME,
      this.pREVIOUSEMPLOYERADDRESS,
      this.cURRENTEMPLOYERADDRESS);

  factory EmployeeVerificationDetail.fromJson(json) {
    return EmployeeVerificationDetail(
        json["APPLICATION_DT"].toString(),
        json["CURR_EMPLYR_LANDLINE"].toString(),
        json["CURR_EMPLYR_MOBILE"].toString(),
        json["CURR_EMPLYR_NAME"].toString(),
        json["CURR_EMPLYR_ROLE"].toString(),
        json["EMPLOYEE_SR_NUM"].toString(),
        json["PREV_EMPLYR_FRM_DT"].toString(),
        json["PREV_EMPLYR_LANDLINE"].toString(),
        json["PREV_EMPLYR_MOBILE"].toString(),
        json["PREV_EMPLYR_NAME"].toString(),
        json["PREV_EMPLYR_ROLE"].toString(),
        json["PREV_EMPLYR_TO_DT"].toString(),
        json["REQUESTING_AGENCY_EMAIL"].toString(),
        json["REQUESTING_AGENCY_NAME"].toString(),
        json["EMPLOYEE_PERMANENT_ADDRESS"].toString(),
        json["EMPLOYEE_PRESENT_ADDRESS"].toString(),
        json["EMPLOYEE_PREVIOUS_ADDRESS"].toString(),
        json["AGE"].toString(),
        json["EMPLOYEE_NAME"].toString(),
        json["RELATIONTYPE"].toString(),
        json["RELATIVE_NAME"].toString(),
        json["PREVIOUS_EMPLOYER_ADDRESS"].toString(),
        json["CURRENT_EMPLOYER_ADDRESS"].toString());
  }
}
