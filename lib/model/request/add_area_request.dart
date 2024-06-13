class AddAreaRequest {
  String? DISTRICT_CD;
  String? PS_CD;
  String? AREA_NAME;
  String? LAT;
  String? LONG;

  AddAreaRequest(
      this.DISTRICT_CD, this.PS_CD, this.AREA_NAME, this.LAT, this.LONG);

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": DISTRICT_CD,
        "PS_CD": PS_CD,
        "AREA_NAME": AREA_NAME,
        "LAT": LAT,
        "LONG": LONG
      };
}
