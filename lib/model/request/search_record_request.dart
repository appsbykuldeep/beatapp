class SearchRecordRequest {
  String? APPLICATION_REQUEST_NO;
  String? SERVICE_TYPE;

  SearchRecordRequest(this.APPLICATION_REQUEST_NO, this.SERVICE_TYPE);

  Map<String, dynamic> toJson() => {
        "APPLICATION_REQUEST_NO": APPLICATION_REQUEST_NO,
        "SERVICE_TYPE": SERVICE_TYPE
      };
}
