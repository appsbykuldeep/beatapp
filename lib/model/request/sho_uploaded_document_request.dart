class SHOUploadedDocumentRequest {
  String? PS_CD;
  String? SERVICE_TYPE;
  String? APPLICATION_SR_NUM;

  SHOUploadedDocumentRequest(
      this.PS_CD, this.SERVICE_TYPE, this.APPLICATION_SR_NUM);

  Map<String, dynamic> toJson() => {
        "PS_CD": PS_CD,
        "SERVICE_TYPE": SERVICE_TYPE,
        "APPLICATION_SR_NUM": APPLICATION_SR_NUM
      };
}
