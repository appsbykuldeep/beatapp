class CaseDiaryDetailRequest {
  String? FIR_REG_NUM;
  String? LANGCD;
  String? CASE_DIARY_SRNO;

  CaseDiaryDetailRequest(this.FIR_REG_NUM, this.LANGCD, this.CASE_DIARY_SRNO);

  Map<String, dynamic> toJson() => {
        "FIR_REG_NUM": FIR_REG_NUM,
        "LANGCD": LANGCD,
        "CASE_DIARY_SRNO": CASE_DIARY_SRNO
      };
}
