class TenantVerificationDetailRequest {
  String? TENANT_SR_NUM;
  String? PS_CD;

  TenantVerificationDetailRequest(this.TENANT_SR_NUM, this.PS_CD);

  Map<String, dynamic> toJson() =>
      {"TENANT_SR_NUM": TENANT_SR_NUM, "PS_CD": PS_CD};
}
