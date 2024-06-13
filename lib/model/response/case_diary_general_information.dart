class CaseDiaryGeneralInformation {
  //@SerializedName("CASE_DIARY_PREP_DT")
  String? caseDiaryPrepDt;

  //@SerializedName("INV_START_DT")
  String? invStartDt;

  //@SerializedName("INV_END_DT")
  String? invEndDt;

  //@SerializedName("INV_PLC_VISITED")
  String? invPlcVisited;

  //@SerializedName("INV_BRIEF_DESC")
  String? invBriefDesc;

  //@SerializedName("CASE_DIARY_ACTION")
  String? caseDiaryAction;

  //@SerializedName("ACTION_TAKEN_DESC")
  String? actionTakenDesc;

  //@SerializedName("ACTION_TAKEN_DT")
  String? actionTakenDt;

  //@SerializedName("CASE_DIARY_REMARKS")
  String? caseDiaryRemarks;

  //@SerializedName("INV_OTHER_INFO")
  String? invOtherInfo;

  //@SerializedName("CASE_STATUS")
  String? caseStatus;

  //@SerializedName("OTHER_ACTION_DESC")
  String? otherActionDesc;

  CaseDiaryGeneralInformation(
      this.caseDiaryPrepDt,
      this.invStartDt,
      this.invEndDt,
      this.invPlcVisited,
      this.invBriefDesc,
      this.caseDiaryAction,
      this.actionTakenDesc,
      this.actionTakenDt,
      this.caseDiaryRemarks,
      this.invOtherInfo,
      this.caseStatus,
      this.otherActionDesc);

  factory CaseDiaryGeneralInformation.fromJson(Map<String, dynamic> json) {
    return CaseDiaryGeneralInformation(
        json["CASE_DIARY_PREP_DT"],
        json["INV_START_DT"],
        json["INV_END_DT"],
        json["INV_PLC_VISITED"],
        json["INV_BRIEF_DESC"],
        json["CASE_DIARY_ACTION"],
        json["ACTION_TAKEN_DESC"],
        json["ACTION_TAKEN_DT"],
        json["CASE_DIARY_REMARKS"],
        json["INV_OTHER_INFO"],
        json["CASE_STATUS"],
        json["OTHER_ACTION_DESC"]);
  }
}
