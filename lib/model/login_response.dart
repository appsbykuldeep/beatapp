// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String accessToken;
  String tokenType;
  int expiresIn;
  String audience;
  String userName;
  String personName;
  String psCd;
  String districtCd;
  String mobile2;
  String personCode;
  String email;
  String roleCd;
  String role;
  String ps;
  String state;
  String district;
  String officeCd;
  String officeTypeDesc;
  String officeTypeCd;
  String mobile1;
  String officeLevelCd;
  String rankCd;
  String officerRank;
  String officeName;
  String userType;
  String issued;
  String expires;

  LoginResponse({
    this.accessToken = '',
    this.tokenType = '',
    this.expiresIn = 0,
    this.audience = '',
    this.userName = '',
    this.personName = '',
    this.psCd = '',
    this.districtCd = '',
    this.mobile2 = '',
    this.personCode = '',
    this.email = '',
    this.roleCd = '',
    this.role = '',
    this.ps = '',
    this.state = '',
    this.district = '',
    this.officeCd = '',
    this.officeTypeDesc = '',
    this.officeTypeCd = '',
    this.mobile1 = '',
    this.officeLevelCd = '',
    this.rankCd = '',
    this.officerRank = '',
    this.officeName = '',
    this.userType = '',
    this.issued = '',
    this.expires = '',
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json["access_token"] ?? '',
        tokenType: json["token_type"] ?? '',
        expiresIn: json["expires_in"] ?? 0,
        audience: json["audience"] ?? '',
        userName: json["userName"] ?? '',
        personName: json["PERSON_NAME"] ?? '',
        psCd: json["PS_CD"] ?? '',
        districtCd: json["DISTRICT_CD"] ?? '',
        mobile2: json["MOBILE_2"] ?? '',
        personCode: json["PERSON_CODE"] ?? '',
        email: json["EMAIL"] ?? '',
        roleCd: json["ROLE_CD"] ?? '',
        role: json["ROLE"] ?? '',
        ps: json["PS"] ?? '',
        state: json["STATE"] ?? '',
        district: json["DISTRICT"] ?? '',
        officeCd: json["OFFICE_CD"] ?? '',
        officeTypeDesc: json["OFFICE_TYPE_DESC"] ?? '',
        officeTypeCd: json["OFFICE_TYPE_CD"] ?? '',
        mobile1: json["MOBILE_1"] ?? '',
        officeLevelCd: json["OFFICE_LEVEL_CD"] ?? '',
        rankCd: json["RANK_CD"] ?? '',
        officerRank: json["OFFICER_RANK"] ?? '',
        officeName: json["OFFICE_NAME"] ?? '',
        userType: json["USER_TYPE"] ?? '',
        issued: json[".issued"] ?? '',
        expires: json[".expires"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "audience": audience,
        "userName": userName,
        "PERSON_NAME": personName,
        "PS_CD": psCd,
        "DISTRICT_CD": districtCd,
        "MOBILE_2": mobile2,
        "PERSON_CODE": personCode,
        "EMAIL": email,
        "ROLE_CD": roleCd,
        "ROLE": role,
        "PS": ps,
        "STATE": state,
        "DISTRICT": district,
        "OFFICE_CD": officeCd,
        "OFFICE_TYPE_DESC": officeTypeDesc,
        "OFFICE_TYPE_CD": officeTypeCd,
        "MOBILE_1": mobile1,
        "OFFICE_LEVEL_CD": officeLevelCd,
        "RANK_CD": rankCd,
        "OFFICER_RANK": officerRank,
        "OFFICE_NAME": officeName,
        "USER_TYPE": userType,
        ".issued": issued,
        ".expires": expires,
      };
}
