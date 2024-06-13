class ViewCaseDiaryListResponse {
  //@SerializedName("CASE_DIARY_NUM")
  String? caseDiaryNum;

  //@SerializedName("RECORD_CREATED_BY")
  String? recordCreatedBy;

  //@SerializedName("FIR_REG_NUM_YEAR")
  String? firRegNumYear;

  //@SerializedName("CASE_DIARY_SUPP_NUM")
  String? caseDiarySuppNum;

  //@SerializedName("FIR_REG_NUM")
  String? firRegNum;

  //@SerializedName("CASE_DIARY_SRNO")
  String? caseDiarySrno;

  //@SerializedName("CASE_DIARY_PREP_DT")
  String? caseDiaryPrepDt;

  //@SerializedName("INSTRUCT_COMM")
  String? instructComm;

  //@SerializedName("PS")
  String? ps;

  //@SerializedName("IS_FIR_BLOCK")
  String? isFirBlock;

  ViewCaseDiaryListResponse(
      this.caseDiaryNum,
      this.recordCreatedBy,
      this.firRegNumYear,
      this.caseDiarySuppNum,
      this.firRegNum,
      this.caseDiarySrno,
      this.caseDiaryPrepDt,
      this.instructComm,
      this.ps,
      this.isFirBlock);

  factory ViewCaseDiaryListResponse.fromJson(json) {
    return ViewCaseDiaryListResponse(
        json["CASE_DIARY_NUM"],
        json["RECORD_CREATED_BY"],
        json["FIR_REG_NUM_YEAR"],
        json["CASE_DIARY_SUPP_NUM"],
        json["FIR_REG_NUM"],
        json["CASE_DIARY_SRNO"],
        json["CASE_DIARY_PREP_DT"],
        json["INSTRUCT_COMM"],
        json["PS"],
        json["IS_FIR_BLOCK"]);
  }
}
