class CharacterVerificationUpdateRequest {
  //@SerializedName("CHARACTER_SR_NUM")
  String? srNum;

  //@SerializedName("IS_RESOLVED")
  String? isResolved;

  //@SerializedName("LAT")
  String? lat;

  //@SerializedName("LONG")
  String? lng;

  //@SerializedName("IS_CRIMINAL_RECORD")
  String? isCriminalRecord;

  //@SerializedName("IS_INVOLVE_IN_CRIME")
  String? isInvolvedInCrime;

  //@SerializedName("REMARKS")
  String? remarks;

  //@SerializedName("PHOTO")
  String? photo;

  //@SerializedName("CHAR_DESCRIPTION")
  String? charDescription;

  //@SerializedName("PS_CD")
  String? psCd;

  CharacterVerificationUpdateRequest(
      this.srNum,
      this.isResolved,
      this.lat,
      this.lng,
      this.isCriminalRecord,
      this.isInvolvedInCrime,
      this.remarks,
      this.photo,
      this.charDescription,
      this.psCd);

  Map<String, dynamic> toJson() => {
        "CHARACTER_SR_NUM": srNum,
        "IS_RESOLVED": isResolved,
        "LAT": lat,
        "LONG": lng,
        "IS_CRIMINAL_RECORD": isCriminalRecord,
        "IS_INVOLVE_IN_CRIME": isInvolvedInCrime,
        "REMARKS": remarks,
        "PHOTO": photo,
        "CHAR_DESCRIPTION": charDescription,
        "PS_CD": psCd
      };
}
