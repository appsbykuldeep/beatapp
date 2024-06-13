class ConstableRequest {
  String? DISTRICT_CD;
  String? PS_CD;
  String? NAME;
  String? PNO;
  String? MOBILE;
  String? BEAT_RANK;
  String? BEAT_PERSON_SR_NUM;
  String? DELETE_REMARKS;

  ConstableRequest();

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": DISTRICT_CD,
        "PS_CD": PS_CD,
        "NAME": NAME,
        "PNO": PNO,
        "MOBILE": MOBILE,
        "BEAT_RANK": BEAT_RANK,
        "BEAT_PERSON_SR_NUM": BEAT_PERSON_SR_NUM,
        "DELETE_REMARKS": DELETE_REMARKS
      };
}
