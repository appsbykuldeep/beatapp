class GetBeatConsByBeatCDRequest {
  String? BEAT_CD;

  GetBeatConsByBeatCDRequest(this.BEAT_CD);

  Map<String, dynamic> toJson() => {"BEAT_CD": BEAT_CD};
}
