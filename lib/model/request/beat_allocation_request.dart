class BeatAllocationRequest {
  String? PS_CD;

  BeatAllocationRequest(this.PS_CD);
  Map<String, dynamic> toJson() => {
    "PS_CD":PS_CD
  };
}
