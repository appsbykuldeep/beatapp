class RemoveBeatAreaRequest {
  String? AREA_SR_NUM;

  RemoveBeatAreaRequest(this.AREA_SR_NUM);

  Map<String, dynamic> toJson() => {"AREA_SR_NUM": AREA_SR_NUM};
}
