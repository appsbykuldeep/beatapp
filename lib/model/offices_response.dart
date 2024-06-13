// To parse this JSON data, do
//
//     final officesResponse = officesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:beatapp/extensions/api_reponse_parser.dart';

List<OfficesResponse> officesResponseFromJson(String str) =>
    List<OfficesResponse>.from(
        json.decode(str).map((x) => OfficesResponse.fromJson(x)));

String officesResponseToJson(List<OfficesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfficesResponse {
  String officetype;
  String officename;
  int officecode;
  int rolecd;
  String role;
  int baseofficecd;
  String districtCd;
  bool isSelected = false;

  OfficesResponse({
    required this.officetype,
    required this.officename,
    required this.officecode,
    required this.rolecd,
    required this.role,
    required this.baseofficecd,
    required this.districtCd,
  });

  factory OfficesResponse.fromJson(Map<String, dynamic> json) =>
      OfficesResponse(
        officetype: json["OFFICETYPE"],
        officename: json["OFFICENAME"],
        officecode: json["OFFICECODE"],
        rolecd: json["ROLECD"],
        role: json["ROLE"],
        baseofficecd: json["BASEOFFICECD"],
        districtCd: ["DISTRICT_CD"].fetchString(json),
      );

  Map<String, dynamic> toJson() => {
        "OFFICETYPE": officetype,
        "OFFICENAME": officename,
        "OFFICECODE": officecode,
        "ROLECD": rolecd,
        "ROLE": role,
        "BASEOFFICECD": baseofficecd,
        "DISTRICT_CD": districtCd,
      };
}
