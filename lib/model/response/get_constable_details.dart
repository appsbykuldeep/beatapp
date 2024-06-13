class GetConstableDetails {
  String? NAME;
  String? CUG;
  String? OFFICER_RANK;
  String? LOGIN_ID;
  String? PS_CD;

  GetConstableDetails(
      this.NAME, this.CUG, this.OFFICER_RANK, this.LOGIN_ID, this.PS_CD);

  factory GetConstableDetails.fromJson(json) {
    return GetConstableDetails(json["NAME"], json["CUG"], json["OFFICER_RANK"],
        json["LOGIN_ID"], json["PS_CD"]);
  }

  static fromString(String data) {
    List<GetConstableDetails> lst = [];
    var arrdata = data.split(",");
    if (data != "") {
      for (int i = 0; i < arrdata.length; i++) {
        arrdata[i].split("@")[0].split("-")[1];
        lst.add(GetConstableDetails(
            arrdata[i].split("@")[1].split("-")[1],
            arrdata[i].split("@")[0].split("-")[1],
            arrdata[i].split("@")[2].split("-")[1],
            "",
            ""));
      }
    }
    return lst;
  }

  static String fromStringToString(String data) {
    String strdata = "";
    var arrdata = data.split(",");
    if (data != "") {
      for (int i = 0; i < arrdata.length; i++) {
        arrdata[i].split("@")[0].split("-")[1];
        GetConstableDetails csd = GetConstableDetails(
            arrdata[i].split("@")[1].split("-")[1],
            arrdata[i].split("@")[0].split("-")[1],
            arrdata[i].split("@")[2].split("-")[1],
            "",
            "");
        strdata += "${csd.NAME ?? ""} - ${csd.CUG ?? ""} - ${csd.OFFICER_RANK ?? ""}\r\n";
      }
    }
    return strdata;
  }
}
