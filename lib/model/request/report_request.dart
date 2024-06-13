class ReportRequest {
  String? PS_CD;

  ReportRequest(this.PS_CD);

  Map<String, dynamic> toJson() => {
    "PS_CD":PS_CD
  };
}
