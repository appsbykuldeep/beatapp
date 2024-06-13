class CharacterSubmitDcrbLiuActionRequest {
  String? CHARACTER_SR_NUM;
  String? IS_CRIMINAL_RECORD;
  String? DESCRIPTION;
  String? DISTRICT_CD;

  CharacterSubmitDcrbLiuActionRequest(this.CHARACTER_SR_NUM,
      this.IS_CRIMINAL_RECORD, this.DESCRIPTION, this.DISTRICT_CD);

  Map<String, dynamic> toJson() => {
        "CHARACTER_SR_NUM": CHARACTER_SR_NUM,
        "IS_CRIMINAL_RECORD": IS_CRIMINAL_RECORD,
        "DESCRIPTION": DESCRIPTION,
        "DISTRICT_CD": DISTRICT_CD
      };
}
