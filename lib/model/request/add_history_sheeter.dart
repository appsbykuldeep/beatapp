class AddHistorySheeter {
  String? HIST_SR_NUM;
  String? DISTRICT_CD;
  String? PS_CD;
  String? NAME;
  String? FATHER_NAME;
  String? AGE;
  String? ADDRESS;
  String? MOBILE;
  String? VILL_STR_SR_NUM;
  String? IS_ACTIVE;
  String? BEAT_CD;
  String? REMARKS;
  String? HISTORY_SHEET_NO;
  String? DATE_OF_OPENING;
  String? NIGRANI_BAND_DATE;
  String? FILLED_BY_NAME;
  String? LISCENSE_HOLDER_NAME;
  String? FIRE_ARMS_CD;
  String? FIRE_ARMS_VALIDITY_DATE;
  String? ARMS_MODEL;
  String? ARMS_LISCENSE_NO;
  String? WEAPON_SR_NUM;
  String? IS_APPROVED;
  String? SP_REMARKS;
  String? APPROVAL_TYPE;

  AddHistorySheeter(
      this.HIST_SR_NUM,
      this.DISTRICT_CD,
      this.PS_CD,
      this.NAME,
      this.FATHER_NAME,
      this.AGE,
      this.ADDRESS,
      this.MOBILE,
      this.VILL_STR_SR_NUM,
      this.IS_ACTIVE,
      this.BEAT_CD,
      this.REMARKS,
      this.HISTORY_SHEET_NO,
      this.DATE_OF_OPENING,
      this.NIGRANI_BAND_DATE,
      this.FILLED_BY_NAME,
      this.LISCENSE_HOLDER_NAME,
      this.FIRE_ARMS_CD,
      this.FIRE_ARMS_VALIDITY_DATE,
      this.ARMS_MODEL,
      this.ARMS_LISCENSE_NO,
      this.WEAPON_SR_NUM,
      this.IS_APPROVED,
      this.SP_REMARKS,
      this.APPROVAL_TYPE);

  Map<String, dynamic> toJson() => {
        "HIST_SR_NUM": HIST_SR_NUM,
        "DISTRICT_CD": DISTRICT_CD,
        "PS_CD": PS_CD,
        "NAME": NAME,
        "FATHER_NAME": FATHER_NAME,
        "AGE": AGE,
        "ADDRESS": ADDRESS,
        "MOBILE": MOBILE,
        "VILL_STR_SR_NUM": VILL_STR_SR_NUM,
        "IS_ACTIVE": IS_ACTIVE,
        "BEAT_CD": BEAT_CD,
        "REMARKS": REMARKS,
        "HISTORY_SHEET_NO": HISTORY_SHEET_NO,
        "DATE_OF_OPENING": DATE_OF_OPENING,
        "NIGRANI_BAND_DATE": NIGRANI_BAND_DATE,
        "FILLED_BY_NAME": FILLED_BY_NAME,
        "LISCENSE_HOLDER_NAME": LISCENSE_HOLDER_NAME,
        "FIRE_ARMS_CD": FIRE_ARMS_CD,
        "FIRE_ARMS_VALIDITY_DATE": FIRE_ARMS_VALIDITY_DATE,
        "ARMS_MODEL": ARMS_MODEL,
        "ARMS_LISCENSE_NO": ARMS_LISCENSE_NO,
        "WEAPON_SR_NUM": WEAPON_SR_NUM,
        "IS_APPROVED": IS_APPROVED,
        "SP_REMARKS": SP_REMARKS,
        "APPROVAL_TYPE": APPROVAL_TYPE
      };
}
