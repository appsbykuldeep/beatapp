class EmployeeVerificationDetailRequest {
  String? EMPLOYEE_SR_NUM;
  String? PS_CD;

  EmployeeVerificationDetailRequest(this.EMPLOYEE_SR_NUM, this.PS_CD);

  Map<String, dynamic> toJson() =>
      {"EMPLOYEE_SR_NUM": EMPLOYEE_SR_NUM, "PS_CD": PS_CD};
}
