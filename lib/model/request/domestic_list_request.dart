class DomesticListRequest {
  String? PS_CD;

  DomesticListRequest(this.PS_CD);

  Map<String, dynamic> toJson() => {"PS_CD": PS_CD};
}
