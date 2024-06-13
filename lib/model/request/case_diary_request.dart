class CaseDiaryRequest {
  String? CASE_DIARY_SRNO;

  CaseDiaryRequest(this.CASE_DIARY_SRNO);

  Map<String, dynamic> toJson() => {"CASE_DIARY_SRNO": CASE_DIARY_SRNO};
}
