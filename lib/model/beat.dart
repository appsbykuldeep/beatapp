class Beat {
  //@SerializedName("BEAT_CD")
  String? beatCD;

  //@SerializedName("BEAT_NAME")
  String? beatName;

  //@SerializedName("PS_CD")
  String? psCD;

  @override
  String toString() {
    return beatName!;
  }

  Beat(this.beatCD, this.beatName, this.psCD);

  factory Beat.fromJson(json) {
    return Beat(json["BEAT_CD"], json["BEAT_NAME"], json["PS_CD"]);
  }
}
