class AlertsReminderResponse {
  //@SerializedName("MSG_SR_NUM")

  String? mSGSRNUM;

  //@SerializedName("IS_RESPONSE_REQUIRED")

  String? iSRESPONSEREQUIRED;

  //@SerializedName("MESSAGE_LINK")

  String? mESSAGELINK;

  //@SerializedName("TEXT_MESSAGE")

  String? tEXTMESSAGE;

  AlertsReminderResponse(this.mSGSRNUM, this.iSRESPONSEREQUIRED,
      this.mESSAGELINK, this.tEXTMESSAGE);

  factory AlertsReminderResponse.fromJson(Map<String, dynamic> json) {
    return AlertsReminderResponse(
        json["MSG_SR_NUM"],
        json["IS_RESPONSE_REQUIRED"],
        json["MESSAGE_LINK"],
        json["TEXT_MESSAGE"]);
  }
}
