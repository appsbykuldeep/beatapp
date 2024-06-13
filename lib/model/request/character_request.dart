class CharacterRequest {
  String? DISTRICT_CD;

  CharacterRequest(this.DISTRICT_CD);

  Map<String, dynamic> toJson() => {"DISTRICT_CD": DISTRICT_CD};
}
