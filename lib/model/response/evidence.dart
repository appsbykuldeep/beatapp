class Evidence {
  //@SerializedName("EVIDENCE_TYPE")
  String? evidenceType;

  //@SerializedName("EVIDENCE_COLLECED_AT")
  String? evidenceCollecedAt;

  //@SerializedName("EVIDENCE_COLLECED_BY")
  String? evidenceCollecedBy;

  //@SerializedName("EVIDENCE_COLLECED_ON")
  String? evidenceCollecedOn;

  //@SerializedName("PROP_RECOVRD_DET")
  String? propRecovrdDet;

  //@SerializedName("EVIDENCE_COLLECED_DESC")
  String? evidenceCollecedDesc;

  //@SerializedName("CD_EVIDENCE_SRNO")
  String? cdEvidenceSrno;

  Evidence(
      this.evidenceType,
      this.evidenceCollecedAt,
      this.evidenceCollecedBy,
      this.evidenceCollecedOn,
      this.propRecovrdDet,
      this.evidenceCollecedDesc,
      this.cdEvidenceSrno);

  factory Evidence.fromJson(json) {
    return Evidence(
        json["EVIDENCE_TYPE"],
        json["EVIDENCE_COLLECED_AT"],
        json["EVIDENCE_COLLECED_BY"],
        json["EVIDENCE_COLLECED_ON"],
        json["PROP_RECOVRD_DET"],
        json["EVIDENCE_COLLECED_DESC"],
        json["CD_EVIDENCE_SRNO"]);
  }
}
