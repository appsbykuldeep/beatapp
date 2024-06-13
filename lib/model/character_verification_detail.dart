class CharacterVerificationDetail {
  //@SerializedName("COMPLAINANT_NAME")
  String? complainantName;

  //@SerializedName("RELATIVE_NAME")
  String? relativeName;

  //@SerializedName("GENDER")
  String? gender;

  //@SerializedName("RELATION_TYPE")
  String? relation;

  //@SerializedName("AGE")
  String? age;

  //@SerializedName("DOB")
  String? dob;

  //@SerializedName("MOBILE")
  String? mobile;

  //@SerializedName("EMAIL")
  String? email;

  //@SerializedName("CERTIFICATE_PURPOSE")
  String? purpose;

  //@SerializedName("ANY_CRIMINAL_RECORD")
  String? criminalRecord;

  //@SerializedName("PRESENT_ADDRESS")
  String? presentAddress;

  //@SerializedName("PERMANENT_ADDRESS")
  String? permanentAddress;

  CharacterVerificationDetail(
      this.complainantName,
      this.relativeName,
      this.gender,
      this.relation,
      this.age,
      this.dob,
      this.mobile,
      this.email,
      this.purpose,
      this.criminalRecord,
      this.presentAddress,
      this.permanentAddress);

  factory CharacterVerificationDetail.fromJson(json) {
    return CharacterVerificationDetail(
        json["COMPLAINANT_NAME"],
        json["RELATIVE_NAME"],
        json["GENDER"],
        json["RELATION_TYPE"],
        json["AGE"].toString(),
        json["DOB"],
        json["MOBILE"],
        json["EMAIL"],
        json["CERTIFICATE_PURPOSE"],
        json["ANY_CRIMINAL_RECORD"],
        json["PRESENT_ADDRESS"],
        json["PERMANENT_ADDRESS"]);
  }

  factory CharacterVerificationDetail.emptyData() {
    return CharacterVerificationDetail(
        null, null, null, null, null, null, null, null, null, null, null, null);
  }
}
