class GetVersionResponse {


  //@SerializedName("RELEASE_VERSION")
  String? RELEASE_VERSION;

  //@SerializedName("DOWNTIME_CD")
  String? DOWNTIME_CD;

  //@SerializedName("DOWNTIME_INFO")
  String? DOWNTIME_INFO;

  GetVersionResponse(
      this.RELEASE_VERSION, this.DOWNTIME_CD, this.DOWNTIME_INFO);

  factory GetVersionResponse.fromJson(Map<String, dynamic> json) {
    return GetVersionResponse(
      json['RELEASE_VERSION'].toString(),
      json['DOWNTIME_CD'].toString(),
      json['DOWNTIME_INFO'].toString(),
    );
  }
}
