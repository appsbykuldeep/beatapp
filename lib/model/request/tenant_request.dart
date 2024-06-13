class TenantRequest {
  String? PS_CD;

  TenantRequest(this.PS_CD);

  Map<String, dynamic> toJson() => {"PS_CD": PS_CD};
}
