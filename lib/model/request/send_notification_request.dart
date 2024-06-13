class SendNotificationRequest {
  //@SerializedName("GROUP_ID")
  String? groupId;

  //@SerializedName("NOTIFICATION_TEXT")
  String? notificationText;

  SendNotificationRequest(this.groupId, this.notificationText);

  Map<String, dynamic> toJson() =>
      {"GROUP_ID": groupId, "NOTIFICATION_TEXT": notificationText};
}
