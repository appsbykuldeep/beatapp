class ApiResponse {
  ApiResponse({
    this.statusCode = 0,
    this.haveError = false,
    this.errorMsj = '',
    this.resultStatus = false,
    this.internetAvailable = true,
    this.resultMsj = "",
    this.resultData,
  });

  int statusCode;
  bool haveError;
  String errorMsj;
  bool resultStatus;
  bool internetAvailable;
  String resultMsj;
  dynamic resultData;

  // factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
  //       statusCode: json["StatusCode"] ?? 0,
  //       haveError: json["HaveError"] ?? '',
  //       errorMsj: json["ErrorMsj"] ?? '',
  //       resultStatus: (json["resultStatus"] ?? "").toString() == "true",
  //       resultMsj: json["resultMessage"] ?? '',
  //       resultData: json["resultData"] ?? "",
  //     );
}
