class FeedbackRequest {
  String? RATING;
  String? DESCRIPTION;

  FeedbackRequest(this.RATING, this.DESCRIPTION);

  Map<String, dynamic> toJson() =>
      {"RATING": RATING, "DESCRIPTION": DESCRIPTION};
}
