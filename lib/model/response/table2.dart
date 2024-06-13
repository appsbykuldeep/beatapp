class Table2 {
  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("RELATIVE_NAME")
  String? rELATIVENAME;

  //@SerializedName("RELATION_TYPE")
  String? rELATIONTYPE;

  Table2(this.nAME, this.rELATIVENAME, this.rELATIONTYPE);

/* //@SerializedName("RELATION_TYPE_CD")
     Integer rELATIONTYPECD;*/

  factory Table2.fromJson(json) {
    return Table2(json["NAME"], json["RELATIVE_NAME"], json["RELATION_TYPE"]);
  }


  static List<Table2> fromJsonArray(json) {
    List<Table2> lstData = [];
    for (Map<String, dynamic> i in json) {
      var data = Table2.fromJson(i);
      lstData.add(data);
    }
    return lstData;
  }
}
