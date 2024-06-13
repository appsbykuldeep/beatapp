class VillageStreetAndBeatRequest {
  String? DISTRICT_CD;
  String? PS_CD;
  String? IS_VILLAGE;
  String? REGIONAL_NAME;
  String? ENGLISH_NAME;
  String? VILL_STR_SR_NUM;
  String? BEAT_NAME_HINDI;
  String? BEAT_NAME_ENGLISH;
  String? BEAT_CD;

  VillageStreetAndBeatRequest();

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": DISTRICT_CD,
        "PS_CD": PS_CD,
        "IS_VILLAGE": IS_VILLAGE,
        "REGIONAL_NAME": REGIONAL_NAME,
        "ENGLISH_NAME": ENGLISH_NAME,
        "VILL_STR_SR_NUM": VILL_STR_SR_NUM,
        "BEAT_NAME_HINDI": BEAT_NAME_HINDI,
        "BEAT_NAME_ENGLISH": BEAT_NAME_ENGLISH,
        "BEAT_CD": BEAT_CD
      };

  Map<String, dynamic> toSaveVillJson() => {
    "DISTRICT_CD": DISTRICT_CD,
    "PS_CD": PS_CD,
    "IS_VILLAGE": IS_VILLAGE,
    "REGIONAL_NAME": REGIONAL_NAME,
    "ENGLISH_NAME": ENGLISH_NAME,
  };
}
