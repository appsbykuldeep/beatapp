class InformationDetail_Table {
  //@SerializedName("SHARE_INFO_TYPE")
  String? sHAREINFOTYPE;

  //@SerializedName("RECORD_DATETIME")
  String? rECORDDATETIME;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("DISTRICT")
  String? dISTRICT;

  //@SerializedName("PS")
  String? pS;

  //@SerializedName("ADDRESS")
  String? address;

  //@SerializedName("MOBILE_NO")
  String? mOBILENO;

  //@SerializedName("SUSPECTNAME")
  String? sUSpectNAme;

  //@SerializedName("OCCPLACE")
  String? occPLace;

  //@SerializedName("DESCRIPTION")
  String? dESCRIPTION;

  //@SerializedName("AUDIO_FILE")
  String? aUDIOFILE;

  //@SerializedName("IMAGE")
  String? iMAGE;

  //@SerializedName("LAT_LONG")
  String? lATLONG;

  //@SerializedName("LAT")
  String? lAT;

  //@SerializedName("LONG")
  String? lONG;

  InformationDetail_Table(
      this.sHAREINFOTYPE,
      this.rECORDDATETIME,
      this.nAME,
      this.dISTRICT,
      this.pS,
      this.address,
      this.mOBILENO,
      this.sUSpectNAme,
      this.occPLace,
      this.dESCRIPTION,
      this.aUDIOFILE,
      this.iMAGE,
      this.lATLONG,
      this.lAT,
      this.lONG);

  factory InformationDetail_Table.fromJson(json) {
    return InformationDetail_Table(
        json["SHARE_INFO_TYPE"],
        json["RECORD_DATETIME"],
        json["NAME"],
        json["DISTRICT"],
        json["PS"],
        json["ADDRESS"],
        json["MOBILE_NO"],
        json["SUSPECTNAME"],
        json["OCCPLACE"],
        json["DESCRIPTION"],
        json["AUDIO_FILE"],
        json["IMAGE"],
        json["LAT_LONG"],
        json["LAT"],
        json["LONG"]);
  }

  factory InformationDetail_Table.emptyData() {
    return InformationDetail_Table(null, null, null, null, null, null, null,
        null, null, null, null, null, null, null, null);
  }
}
