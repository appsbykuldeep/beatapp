class BeatAllocationListRequest {
  String? SHO_CUG;
  String? PS_CD;

  BeatAllocationListRequest(this.SHO_CUG, this.PS_CD);

  Map<String, dynamic> toJson() => {"SHO_CUG": SHO_CUG, "PS_CD": PS_CD};
}
