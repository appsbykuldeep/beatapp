class EmployeeListRequest {
  String? PS_CD;

  EmployeeListRequest(this.PS_CD);

  Map<String, dynamic> toJson() => {"PS_CD": PS_CD};
}
