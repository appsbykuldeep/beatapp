class ViewBeatAssignmentRequest {
  String? BEAT_CUG;
  String? PS_CD;

  ViewBeatAssignmentRequest(this.BEAT_CUG, this.PS_CD);

  Map<String, dynamic> toJson() =>
      {"BEAT_CUG": BEAT_CUG, "PS_CD": PS_CD};
}
