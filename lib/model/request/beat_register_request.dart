class BeatRegisterRequest {
  String? PS_CD;
  String? DISTRICT_CD;

  BeatRegisterRequest(this.PS_CD, this.DISTRICT_CD);

  Map<String, dynamic> toJson() => {"PS_CD": PS_CD, "DISTRICT_CD": DISTRICT_CD};
}
