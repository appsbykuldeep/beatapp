class BeatAreaRequest {
  String? DISTRICT_CD;
  String? PS_CD;
  String? BEAT_CD;
  String? AREA_SR_NUM;

  BeatAreaRequest(this.DISTRICT_CD, this.PS_CD, this.BEAT_CD, this.AREA_SR_NUM);

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": DISTRICT_CD,
        "PS_CD": PS_CD,
        "BEAT_CD": BEAT_CD,
        "AREA_SR_NUM": AREA_SR_NUM
      };
}
