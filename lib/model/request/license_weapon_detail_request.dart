class LicenseWeaponDetailRequest {
  String? WEAPON_SR_NUM;

  LicenseWeaponDetailRequest(this.WEAPON_SR_NUM);

  Map<String, dynamic> toJson() => {"WEAPON_SR_NUM": WEAPON_SR_NUM};
}
