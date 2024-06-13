class BeatConstable {
  //@SerializedName("PNO")
  String? pNO;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? beatConstableName;

  //@SerializedName("OFFICER_RANK")
  String? officerRank;

  BeatConstable(this.pNO, this.beatConstableName, this.officerRank);

  factory BeatConstable.fromJson(json) {
    return BeatConstable(
        json["PNO"].toString(), json["BEAT_CONSTABLE_NAME"], json["OFFICER_RANK"]);
  }

  @override
  String toString() {
    return beatConstableName!;
  }
}
