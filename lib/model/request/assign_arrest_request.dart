class AssignArrestRequest {
  //@SerializedName("ACCUSED_SRNO")
  String? accusedSrNo;

  //@SerializedName("FIR_REG_NUM")
  String? firRegNum;

  //@SerializedName("BEAT_CD")
  String? beatCd;

  //@SerializedName("ASSIGN_TO")
  String? assignTo;

  //@SerializedName("DISTRICT_CD")
  String? districtCd;

  //@SerializedName("PS_CD")
  String? psCd;

  //@SerializedName("TARGET_DT")
  String? targetDt;

  AssignArrestRequest(this.accusedSrNo, this.firRegNum, this.beatCd,
      this.assignTo, this.districtCd, this.psCd, this.targetDt);

  Map<String, dynamic> toJson() => {
        "ACCUSED_SRNO": accusedSrNo,
        "FIR_REG_NUM": firRegNum,
        "BEAT_CD": beatCd,
        "ASSIGN_TO": assignTo,
        "DISTRICT_CD": districtCd,
        "PS_CD": psCd,
        "TARGET_DT": targetDt
      };
}
