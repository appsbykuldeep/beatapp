class HistorySheeterDetail_Table {
  //@SerializedName("DISTRICT")
  String? dISTRICT;

  //@SerializedName("PS")
  String? pS;

  //@SerializedName("BEAT_NAME")
  String? bEATNAME;

  //@SerializedName("BEAT_CD")
  String? BEAT_CD;

  //@SerializedName("VILL_STR_SR_NUM")
  String? VILL_STR_SR_NUM;

  //@SerializedName("VILL_STREET_NAME")
  String? vILLSTREETNAME;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("FATHER_NAME")
  String? fATHERNAME;

  //@SerializedName("ADDRESS")
  String? aDDRESS;

  //@SerializedName("AGE")
  String? aGE;

  //@SerializedName("MOBILE")
  String? mOBILE;

  //@SerializedName("REMARKS")
  String? rEMARKS;

  //@SerializedName("IS_ACTIVE")
  String? iSACTIVE;

  //@SerializedName("RECORD_CREATED_ON")
  String? rECORDCREATEDON;

  //@SerializedName("IS_ACTIVE_CODE")
  String? IS_ACTIVE_CODE;

  //@SerializedName("HISTORY_SHEET_NO")
  String? HISTORY_SHEET_NO;

  //@SerializedName("DATE_OF_OPENING")
  String? DATE_OF_OPENING;

  //@SerializedName("NIGRANI_BAND_DATE")
  String? NIGRANI_BAND_DATE;

  //@SerializedName("PENDING_TYPE")
  String? PENDING_TYPE;

//@SerializedName("SP_DEL_APP_REMARKS")
  String? SP_DEL_APP_REMARKS;

//@SerializedName("SP_HST_NO_REMARKS")
  String? SP_HST_NO_REMARKS;

//@SerializedName("SP_APPROVED_STATUS")
  String? SP_APPROVED_STATUS;

  HistorySheeterDetail_Table(
      this.dISTRICT,
      this.pS,
      this.bEATNAME,
      this.BEAT_CD,
      this.VILL_STR_SR_NUM,
      this.vILLSTREETNAME,
      this.nAME,
      this.fATHERNAME,
      this.aDDRESS,
      this.aGE,
      this.mOBILE,
      this.rEMARKS,
      this.iSACTIVE,
      this.rECORDCREATEDON,
      this.IS_ACTIVE_CODE,
      this.HISTORY_SHEET_NO,
      this.DATE_OF_OPENING,
      this.NIGRANI_BAND_DATE,
      this.PENDING_TYPE,
      this.SP_DEL_APP_REMARKS,
      this.SP_HST_NO_REMARKS,
      this.SP_APPROVED_STATUS);

  factory HistorySheeterDetail_Table.fromJson(json) {
    return HistorySheeterDetail_Table(
        json["DISTRICT"],
        json["PS"],
        json["BEAT_NAME"],
        json["BEAT_CD"].toString(),
        json["VILL_STR_SR_NUM"].toString(),
        json["VILL_STREET_NAME"],
        json["NAME"],
        json["FATHER_NAME"],
        json["ADDRESS"],
        json["AGE"].toString(),
        json["MOBILE"],
        json["REMARKS"],
        json["IS_ACTIVE"],
        json["RECORD_CREATED_ON"],
        json["IS_ACTIVE_CODE"],
        json["HISTORY_SHEET_NO"],
        json["DATE_OF_OPENING"],
        json["NIGRANI_BAND_DATE"],
        json["PENDING_TYPE"],
        json["SP_DEL_APP_REMARKS"],
        json["SP_HST_NO_REMARKS"],
        json["SP_APPROVED_STATUS"]);
  }

  factory HistorySheeterDetail_Table.emptyData() {
    return HistorySheeterDetail_Table(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null);
  }
}
