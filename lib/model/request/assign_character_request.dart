class AssignCharacterRequest {
  //@SerializedName("DISTRICT_CD")
  String? districtCd;

  //@SerializedName("PS_CD")
  String? psCd;

  //@SerializedName("BEAT_CD")
  String? beatCd;

  //@SerializedName("ASSIGN_TO")
  String? assignTo;

  //@SerializedName("TARGET_DT")
  String? targetDt;

  //@SerializedName("CHARACTER_SR_NUM")
  String? srNum;

  //@SerializedName("EO_PS_STAFF_CD")
  String? eoPsStaffCd;

  //@SerializedName("DESCRIPTION")
  String? description;

  AssignCharacterRequest(this.districtCd, this.psCd, this.beatCd, this.assignTo,
      this.targetDt, this.srNum, this.eoPsStaffCd, this.description);

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": districtCd,
        "PS_CD": psCd,
        "BEAT_CD": beatCd,
        "ASSIGN_TO": assignTo,
        "TARGET_DT": targetDt,
        "CHARACTER_SR_NUM": srNum,
        "EO_PS_STAFF_CD": eoPsStaffCd
      };
}
