class AlertsReminderRequest {
  String? USER_ROLE;
  String? PS_CD;

  AlertsReminderRequest(this.USER_ROLE, this.PS_CD);

  Map<String, dynamic> toJson() => {"USER_ROLE": USER_ROLE, "PS_CD": PS_CD};
}
