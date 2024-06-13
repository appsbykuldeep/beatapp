class Table {
  /* //@SerializedName("FIR_REG_NUM")
         String? fIRREGNUM;
        //@SerializedName("FINAL_REP_SRNO")
         String? fINALREPSRNO;
        //@SerializedName("CHARGESHEET_NUM")
         String? cHARGESHEETNUM;*/
  //@SerializedName("FR_DISPATCH_DT")
  String? fRDISPATCHDT;

  //@SerializedName("COURT_CASE_NUM")
  String? cOURTCASENUM;

  //@SerializedName("COURT_NAME")
  String? cOURTNAME;

  //@SerializedName("COURT_TYPE")
  String? cOURTTYPE;

  /*//@SerializedName("REG_DT")
         String? rEGDT;*/
  /* //@SerializedName("IONAME")
         String? iONAME;*/
  //@SerializedName("TYPE")
  String? tYPE;

  //@SerializedName("FINAL_FORM_TYPE")
  String? fINALFORMTYPE;

  Table(this.fRDISPATCHDT, this.cOURTCASENUM, this.cOURTNAME, this.cOURTTYPE,
      this.tYPE, this.fINALFORMTYPE);

  factory Table.fromJson(json) {
    return Table(
        json["FR_DISPATCH_DT"],
        json["COURT_CASE_NUM"],
        json["COURT_NAME"],
        json["COURT_TYPE"],
        json["TYPE"],
        json["FINAL_FORM_TYPE"]);
  }

  static List<Table> fromJsonArray(json) {
    List<Table> lstData = [];
    for (Map<String, dynamic> i in json) {
      var data = Table.fromJson(i);
      lstData.add(data);
    }
    return lstData;
  }
}
