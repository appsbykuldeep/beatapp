class CharacterVerificationDetailRequest {
  String? CHARACTER_SR_NUM;
  String? PS_CD;

  CharacterVerificationDetailRequest(this.CHARACTER_SR_NUM, this.PS_CD);

  Map<String, dynamic> toJson() =>
      {"CHARACTER_SR_NUM": CHARACTER_SR_NUM, "PS_CD": PS_CD};
}
