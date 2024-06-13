class BeatAssignmentResponse {
  String? Status;
  String? Message;

  BeatAssignmentResponse(this.Status, this.Message);

  factory BeatAssignmentResponse.fromJson(Map<String, dynamic> json) {
    return BeatAssignmentResponse(json["Status"], json["Message"]);
  }
}
