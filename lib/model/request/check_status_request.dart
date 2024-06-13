class CheckStatusRequest {
  String? PS_CD;
  String? BEAT_CD;
  String? BEAT_CUG;

  CheckStatusRequest(this.PS_CD, this.BEAT_CD, this.BEAT_CUG);

  Map<String, dynamic> toJson() =>
      {"PS_CD": PS_CD, "BEAT_CD": BEAT_CD, "BEAT_CUG": BEAT_CUG};
}
