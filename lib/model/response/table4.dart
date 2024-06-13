class Table4 {
  //@SerializedName("EXECUTION_PS")
  String? eXECUTIONPS;

  //@SerializedName("EXECUTION_DISTRICT")
  String? eXECUTIONDISTRICT;

  //@SerializedName("EXEC_DT")
  String? eXECDT;

  //@SerializedName("EXEC_REMARKS")
  String? eXECREMARKS;

  //@SerializedName("EXEC_LAST_DT")
  String? eXECLASTDT;

  Table4(this.eXECUTIONPS, this.eXECUTIONDISTRICT, this.eXECDT,
      this.eXECREMARKS, this.eXECLASTDT);

  factory Table4.fromJson(json) {
    return Table4(json["EXECUTION_PS"], json["EXECUTION_DISTRICT"],
        json["EXEC_DT"], json["EXEC_REMARKS"], json["EXEC_LAST_DT"]);
  }

  static List<Table4> fromJsonArray(json) {
    List<Table4> lstData = [];
    for (Map<String, dynamic> i in json) {
      var data = Table4.fromJson(i);
      lstData.add(data);
    }
    return lstData;
  }
}
