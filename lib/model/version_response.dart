// To parse this JSON data, do
//
//     final versionResponse = versionResponseFromJson(jsonString);

import 'dart:convert';

List<VersionResponse> versionResponseFromJson(String str) => List<VersionResponse>.from(json.decode(str).map((x) => VersionResponse.fromJson(x)));

String versionResponseToJson(List<VersionResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VersionResponse {
  String releaseVersion;
  String downtimeInfo;
  int downtimeCd;

  VersionResponse({
    required this.releaseVersion,
    required this.downtimeInfo,
    required this.downtimeCd,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) => VersionResponse(
    releaseVersion: json["RELEASE_VERSION"],
    downtimeInfo: json["DOWNTIME_INFO"],
    downtimeCd: json["DOWNTIME_CD"],
  );

  Map<String, dynamic> toJson() => {
    "RELEASE_VERSION": releaseVersion,
    "DOWNTIME_INFO": downtimeInfo,
    "DOWNTIME_CD": downtimeCd,
  };
}
