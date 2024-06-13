class Table1 {
  //@SerializedName("ADDRESS")
  String? aDDRESS;

  //@SerializedName("ADDRESSTYPE")
  String? aDDRESSTYPE;

  //@SerializedName("STATE")
  String? sTATE;

  //@SerializedName("POLICESTATION")
  String? pOLICESTATION;

  //@SerializedName("DISTRICT")
  String? dISTRICT;

  //@SerializedName("PINCODE")
  String? pINCODE;

  Table1(this.aDDRESS, this.aDDRESSTYPE, this.sTATE, this.pOLICESTATION,
      this.dISTRICT, this.pINCODE);

  factory Table1.fromJson(json) {
    String address = json["ADDRESS"];
    String ADDRESSTYPE = json["ADDRESSTYPE"];
    String STATE = json["STATE"];
    String POLICESTATION = json["POLICESTATION"];
    String DISTRICT = json["DISTRICT"];
    String PINCODE = json["PINCODE"];
    return Table1(
        address, ADDRESSTYPE, STATE, POLICESTATION, DISTRICT, PINCODE);
  }

  static List<Table1> fromJsonArray(json) {
    List<Table1> lstData = [];
    for (Map<String, dynamic> i in json) {
      var data = Table1.fromJson(i);
      lstData.add(data);
    }
    return lstData;
  }
}
