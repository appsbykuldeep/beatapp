class HSTDetailRequest {
  String? HST_SR_NUM;
  String? REMARKS;
  String? WEAPON_SR_NUM;

  HSTDetailRequest(this.HST_SR_NUM, this.REMARKS, this.WEAPON_SR_NUM);

  Map<String, dynamic> toJson() => {
        "HST_SR_NUM": HST_SR_NUM,
        "REMARKS": REMARKS,
        "WEAPON_SR_NUM": WEAPON_SR_NUM
      };
}
