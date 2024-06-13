class CitizenMessagesDetailRequest {
  String? PERSONID;

  CitizenMessagesDetailRequest(this.PERSONID);

  Map<String, dynamic> toJson() => {"PERSONID": PERSONID};
}
