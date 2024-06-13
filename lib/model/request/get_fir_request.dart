class GetFirRequest {
  String? FIR_REG_NUM;
  String? DATEOFREGISTRATIONFROM;
  String? DATEOFREGISTRATIONTO;
  String? PS_CD;
  String? DS_CD;
  String? PERSONCD;

  // String? ROLE;
  String? OFFICECD;
  String? LANGCD;

  GetFirRequest(
      this.FIR_REG_NUM,
      this.DATEOFREGISTRATIONFROM,
      this.DATEOFREGISTRATIONTO,
      this.PS_CD,
      this.DS_CD,
      this.PERSONCD,
      this.OFFICECD,
      this.LANGCD);

  Map<String, dynamic> toJson() => {
        "FIR_REG_NUM": FIR_REG_NUM,
        "DATEOFREGISTRATIONFROM": DATEOFREGISTRATIONFROM,
        "DATEOFREGISTRATIONTO": DATEOFREGISTRATIONTO,
        "PS_CD": PS_CD,
        "DS_CD": DS_CD,
        "PERSONCD": PERSONCD
      };
}
