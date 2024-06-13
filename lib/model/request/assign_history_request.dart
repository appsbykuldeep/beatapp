class AssignHistoryRequest {
  String? ACCUSED_SRNO;
  String? PS_CD;

  AssignHistoryRequest(this.ACCUSED_SRNO, this.PS_CD);

  Map<String, dynamic> toJson() =>
      {"ACCUSED_SRNO": ACCUSED_SRNO, "PS_CD": PS_CD};
}
