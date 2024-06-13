class GetBeatNames {
  String? BEAT_CD;
  String? BEAT_NAME;
  String? PS_CD;

  GetBeatNames(this.BEAT_CD, this.BEAT_NAME, this.PS_CD);

  factory GetBeatNames.fromJson(json) {
    return GetBeatNames(json["BEAT_CD"], json["BEAT_NAME"], json["PS_CD"]);
  }
}
