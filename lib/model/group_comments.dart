class GroupComments {
  //@SerializedName("SENT_BY_ID")
  String? sentById;

  //@SerializedName("SENT_BY_NAME")
  String? sentByName;

  //@SerializedName("SENT_BY_RANK")
  String? sentByRank;

  //@SerializedName("SENT_ON")
  String? sentOn;

  //@SerializedName("NOTIFICATION_TEXT")
  String? notificationText;

  GroupComments(this.sentById, this.sentByName, this.sentByRank, this.sentOn,
      this.notificationText);

  factory GroupComments.fromJson(json) {
    return GroupComments(json["SENT_BY_ID"].toString(), json["SENT_BY_NAME"],
        json["SENT_BY_RANK"], json["SENT_ON"], json["NOTIFICATION_TEXT"]);
  }
}
