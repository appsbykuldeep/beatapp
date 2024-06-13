class AlertsResponseRequest {
  String? MSG_SR_NUM;
  String? PS_CD;
  String? RESPONSE;

  AlertsResponseRequest(this.MSG_SR_NUM, this.PS_CD, this.RESPONSE);

  Map<String, dynamic> toJson() => {
        "MSG_SR_NUM": MSG_SR_NUM,
        "PS_CD": PS_CD,
        "RESPONSE": RESPONSE
      };
}
