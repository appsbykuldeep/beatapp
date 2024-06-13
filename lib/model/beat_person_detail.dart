class BeatPersonDetail {
  String? SR_NUM;
  String? BEAT_CUG;
  String? BEAT_RANK;
  String? BEAT_NAME;

  BeatPersonDetail(this.SR_NUM, this.BEAT_CUG, this.BEAT_RANK, this.BEAT_NAME);

  factory BeatPersonDetail.fromJson(json) {
    return BeatPersonDetail(
        json["SR_NUM"], json["BEAT_CUG"], json["BEAT_RANK"], json["BEAT_NAME"]);
  }

  Map<String, dynamic> toJson() => {
        "SR_NUM": SR_NUM,
        "BEAT_CUG": BEAT_CUG,
        "BEAT_RANK": BEAT_RANK,
        "BEAT_NAME": BEAT_NAME
      };
}
