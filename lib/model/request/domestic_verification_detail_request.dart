class DomesticVerificationDetailRequest {
  String? DOMESTIC_SR_NUM;
  String? PS_CD;

  DomesticVerificationDetailRequest(this.DOMESTIC_SR_NUM, this.PS_CD);

  Map<String, dynamic> toJson() =>
      {"DOMESTIC_SR_NUM": DOMESTIC_SR_NUM, "PS_CD": PS_CD};
}
