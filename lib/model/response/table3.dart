
class Table3 {
  //@SerializedName("SUMMON_WARRANT")
  String? sUMMONWARRANT;

  //@SerializedName("WARRANT_TYPE")
  String? wARRANTTYPE;

  //@SerializedName("SUMM_WARR_NATURE")
  String? sUMMWARRNATURE;

  //@SerializedName("NOTICE_TYPE")
  String? nOTICETYPE;

  //@SerializedName("ACT_SECTION")
  String? aCTSECTION;

  /*  //@SerializedName("WARR_TYPE_CD")
     Long wARRTYPECD;
    //@SerializedName("ISS_TO_TYPE_CD")
     Long iSSTOTYPECD;
    //@SerializedName("ISS_TO_PERS_CD")
     Long iSSTOPERSCD;
    //@SerializedName("ACCUSED_TYPE_CD")
     Long aCCUSEDTYPECD;
    //@SerializedName("NOTICE_OTH_SRC")
     String? nOTICEOTHSRC;
    //@SerializedName("NOTICE_TYPE_CD")
     Long nOTICETYPECD;*/

  //@SerializedName("TO_BE_FWD_NOT")
  String? tOBEFWDNOT;

  //@SerializedName("RECEIV_PS_DT")
  String? rECEIVPSDT;

  //@SerializedName("ISSUE_DT")
  String? iSSUEDT;

  //@SerializedName("NEXT_HEARING_DT")
  String? nEXTHEARINGDT;

  //@SerializedName("EXEC_DT")
  String? eXECDT;

  //@SerializedName("EXEC_REMARKS")
  String? eXECREMARKS;

  //@SerializedName("EXEC_POL_CD")
  String? eXECPOLCD;

  //@SerializedName("FIR_REG_NUM")
  String? fIRREGNUM;

  //@SerializedName("EXEC_LAST_DT")
  String? eXECLASTDT;

  /*//@SerializedName("SUMM_WARR_NUM")
     String? sUMMWARRNUM;
    //@SerializedName("TO_BE_FWD_NOT1")
     String? tOBEFWDNOT1;*/

  //@SerializedName("REG_DT")
  String? rEGDT;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("SUMMON_STATUS")
  String? sUMMONSTATUS;

  //@SerializedName("SUMMON_NO")
  String? sUMMONNO;

  Table3(
      this.sUMMONWARRANT,
      this.wARRANTTYPE,
      this.sUMMWARRNATURE,
      this.nOTICETYPE,
      this.aCTSECTION,
      this.tOBEFWDNOT,
      this.rECEIVPSDT,
      this.iSSUEDT,
      this.nEXTHEARINGDT,
      this.eXECDT,
      this.eXECREMARKS,
      this.eXECPOLCD,
      this.fIRREGNUM,
      this.eXECLASTDT,
      this.rEGDT,
      this.nAME,
      this.sUMMONSTATUS,
      this.sUMMONNO);

/* //@SerializedName("INVESTIGATION_82_DESCRIPTION")
     String? iNVESTIGATION82DESCRIPTION;
    //@SerializedName("INVESTIGATION_82_DATE")
     Object iNVESTIGATION82DATE;
    //@SerializedName("INVESTIGATION_82_TIME")
     Object iNVESTIGATION82TIME;
    //@SerializedName("INVESTIGATION_83_DESCRIPTION")
     String? iNVESTIGATION83DESCRIPTION;
    //@SerializedName("INVESTIGATION_83_DATE")
     Object iNVESTIGATION83DATE;
    //@SerializedName("INVESTIGATION_83_TIME")
     Object iNVESTIGATION83TIME;
*/

  factory Table3.fromJson(json) {
    return Table3(
        json["SUMMON_WARRANT"],
        json["WARRANT_TYPE"],
        json["SUMM_WARR_NATURE"].toString(),
        json["NOTICE_TYPE"],
        json["ACT_SECTION"],
        json["TO_BE_FWD_NOT"],
        json["RECEIV_PS_DT"],
        json["ISSUE_DT"],
        json["NEXT_HEARING_DT"],
        json["EXEC_DT"],
        json["EXEC_REMARKS"],
        json["EXEC_POL_CD"],
        json["FIR_REG_NUM"],
        json["EXEC_LAST_DT"],
        json["REG_DT"],
        json["NAME"],
        json["SUMMON_STATUS"],
        json["SUMMON_NO"]);
  }

  static List<Table3> fromJsonArray(json) {
    List<Table3> lstData = [];
    for (Map<String, dynamic> i in json) {
      var data = Table3.fromJson(i);
      lstData.add(data);
    }
    return lstData;
  }
}
