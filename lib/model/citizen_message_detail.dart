class CitizenMessageDetail {
  //@SerializedName("NAME")
  String? name;

  //@SerializedName("RECORD_DATETIME")
  String? dateTime;

  //@SerializedName("MOBILE_NO")
  String? mobileNo;

  //@SerializedName("ADDRESS")
  String? address;

  //@SerializedName("PERSON_TYPE")
  String? personType;

  //@SerializedName("DESCRIPTION")
  String? description;

  //@SerializedName("SUSPECTNAME")
  String? suspectName;

  //@SerializedName("OCCPLACE")
  String? occurAt;

  //@SerializedName("IMAGE")
  String? image;

  //@SerializedName("AUDIO_FILE")
  String? audioFile;

  //@SerializedName("IS_HENIOUS")
  String? isHeinous;

  CitizenMessageDetail(
      this.name,
      this.dateTime,
      this.mobileNo,
      this.address,
      this.personType,
      this.description,
      this.suspectName,
      this.occurAt,
      this.image,
      this.audioFile,
      this.isHeinous);

  factory CitizenMessageDetail.fromJson(json) {
    return CitizenMessageDetail(
        json["NAME"],
        json["RECORD_DATETIME"],
        json["MOBILE_NO"],
        json["ADDRESS"],
        json["PERSON_TYPE"],
        json["DESCRIPTION"],
        json["SUSPECTNAME"],
        json["OCCPLACE"],
        json["IMAGE"],
        json["AUDIO_FILE"],
        json["IS_HENIOUS"]);
  }
}
