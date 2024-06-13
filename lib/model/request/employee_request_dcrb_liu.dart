class EmployeeRequestDcrbLiu {
  String? DISTRICT_CD;

  EmployeeRequestDcrbLiu(this.DISTRICT_CD);

  Map<String, dynamic> toJson() => {
    "DISTRICT_CD":DISTRICT_CD
  };
}
