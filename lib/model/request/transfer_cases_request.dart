class TransferCasesRequest {
  //@SerializedName("TRANS_TYPE")
  String? transType;

  //@SerializedName("FROM_EO_PS_STAFF_CD")
  String? fromEoPsStaffCd;

  //@SerializedName("TO_EO_PS_STAFF_CD")
  String? toEoPsStaffCd;

  //@SerializedName("FROM_CONSTABLE_PNO")
  String? fromConstablePno;

  //@SerializedName("TO_CONSTABLE_PNO")
  String? toConstablePno;

  //@SerializedName("PS_CD")
  String? psCd;

  //@SerializedName("ASSIGN_REMARKS")
  String? assignRemarks;

  TransferCasesRequest(
      this.transType,
      this.fromEoPsStaffCd,
      this.toEoPsStaffCd,
      this.fromConstablePno,
      this.toConstablePno,
      this.psCd,
      this.assignRemarks);

  Map<String, dynamic> toJson() => {
        "TRANS_TYPE": transType,
        "FROM_EO_PS_STAFF_CD": fromEoPsStaffCd,
        "TO_EO_PS_STAFF_CD": toEoPsStaffCd,
        "FROM_CONSTABLE_PNO": fromConstablePno,
        "TO_CONSTABLE_PNO": toConstablePno,
        "PS_CD": psCd,
        "ASSIGN_REMARKS": assignRemarks
      };
}
