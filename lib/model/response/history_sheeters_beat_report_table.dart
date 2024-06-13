class HistorySheetersBeatReport_Table {
  //@SerializedName("FILL_DT")
  String? fILLDT;

  //@SerializedName("REMARKS")
  String? rEMARKS;

  //@SerializedName("IS_RESOLVED")
  String? iSRESOLVED;

  //@SerializedName("PHOTO")
  String? pHOTO;

  //@SerializedName("VARIFICATION_STATUS")
  String? vARIFICATIONSTATUS;

  //@SerializedName("LAT")
  String? lAT;

  //@SerializedName("LONG")
  String? lONG;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  //@SerializedName("HISTORY_SHEET_NO")
  String? HISTORY_SHEET_NO;

  //@SerializedName("DATE_OF_OPENING")
  String? DATE_OF_OPENING;

  //@SerializedName("NIGRANI_BAND_DATE")
  String? NIGRANI_BAND_DATE;

  //@SerializedName("SP_HST_NO_REMARKS")
  String? SP_HST_NO_REMARKS;

//@SerializedName("SP_APPROVED_STATUS")
  String? SP_APPROVED_STATUS;

  String? ROUTINE_VERIFICATION_STATUS;
  String? ROUTINE_VERIFICATION_DATE;
  String? ROUTINE_VERIFICATION_DAYS;

  HistorySheetersBeatReport_Table(
      this.fILLDT,
      this.rEMARKS,
      this.iSRESOLVED,
      this.pHOTO,
      this.vARIFICATIONSTATUS,
      this.lAT,
      this.lONG,
      this.bEATCONSTABLENAME,
      this.HISTORY_SHEET_NO,
      this.DATE_OF_OPENING,
      this.NIGRANI_BAND_DATE,
      this.SP_HST_NO_REMARKS,
      this.SP_APPROVED_STATUS,
      this.ROUTINE_VERIFICATION_STATUS,
      this.ROUTINE_VERIFICATION_DATE,
      this.ROUTINE_VERIFICATION_DAYS
      );

  factory HistorySheetersBeatReport_Table.fromJson(json) {
    return HistorySheetersBeatReport_Table(
        json["FILL_DT"],
        json["REMARKS"],
        json["IS_RESOLVED"],
        json["PHOTO"],
        json["VARIFICATION_STATUS"],
        json["LAT"],
        json["LONG"],
        json["BEAT_CONSTABLE_NAME"],
        json["HISTORY_SHEET_NO"],
        json["DATE_OF_OPENING"],
        json["NIGRANI_BAND_DATE"],
        json["SP_HST_NO_REMARKS"],
        json["SP_APPROVED_STATUS"],
        json["ROUTINE_VERIFICATION_STATUS"],
        json["ROUTINE_VERIFICATION_DATE"],
        json["ROUTINE_VERIFICATION_DAYS"].toString()
    );
  }
}
