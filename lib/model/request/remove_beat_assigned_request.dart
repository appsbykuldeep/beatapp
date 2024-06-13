class RemoveBeatAssignedRequest {
  String? BEAT_CD;
  String? BEAT_CUG;

  RemoveBeatAssignedRequest(this.BEAT_CD, this.BEAT_CUG);

  Map<String, dynamic> toJson() =>
      {"BEAT_CD": BEAT_CD, "BEAT_CUG": BEAT_CUG};
}
