class CitizenMessagesListRequest {
  String? PS_CD;

  CitizenMessagesListRequest(this.PS_CD);

  Map<String, dynamic> toJson() => {"PS_CD": PS_CD};
}
