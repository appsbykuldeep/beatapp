import 'dart:convert';

import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/extensions/api_reponse_parser.dart';
import 'package:beatapp/model/login_response.dart';

import '../../preferences/preference_util.dart';

class LoginResponseModel extends LoginResponse {
  // String psCd;

  String districtCD;

  String roleCD;

  String officeCD;

  String officeTypeCD;

  String officeLevelCD;

  String rankCD;

  String error;

  String errorDescription;

  LoginResponseModel({
    super.accessToken,
    super.tokenType,
    super.expiresIn,
    super.userName,
    super.personName,
    super.psCd = '',
    this.districtCD = '',
    super.mobile2,
    super.personCode,
    super.email,
    this.roleCD = '',
    super.role,
    super.ps,
    super.state,
    super.district,
    this.officeCD = '',
    super.officeTypeDesc,
    this.officeTypeCD = '',
    super.mobile1,
    this.officeLevelCD = '',
    this.rankCD = '',
    super.officerRank,
    super.issued,
    super.expires,
    this.error = '',
    this.errorDescription = '',
    super.userType = '',
  }) : super(
          districtCd: districtCD,
          roleCd: roleCD,
          officeCd: officeCD,
          officeTypeCd: officeTypeCD,
          officeLevelCd: officeLevelCD,
          rankCd: rankCD,
        );

  static LoginResponseModel loginResponseFromJson(String str) =>
      LoginResponseModel.fromJson(json.decode(str));

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: ['access_token'].fetchString(json),
      tokenType: ['token_type'].fetchString(json),
      expiresIn: ['expires_in'].fetchint(json),
      userName: ['userName'].fetchString(json),
      personName: ['PERSON_NAME'].fetchString(json),
      psCd: ['PS_CD'].fetchString(json),
      districtCD: ['DISTRICT_CD'].fetchString(json),
      mobile2: ['MOBILE_2'].fetchString(json),
      personCode: ['PERSON_CODE'].fetchString(json),
      email: ['EMAIL'].fetchString(json),
      roleCD: ['ROLE_CD'].fetchString(json),
      role: ['ROLE'].fetchString(json),
      ps: ['PS'].fetchString(json),
      state: ['STATE'].fetchString(json),
      district: ['DISTRICT'].fetchString(json),
      officeCD: ['OFFICE_CD'].fetchString(json),
      officeTypeDesc: ['OFFICE_TYPE_DESC'].fetchString(json),
      officeTypeCD: ['OFFICE_TYPE_CD'].fetchString(json),
      mobile1: ['MOBILE_1'].fetchString(json),
      officeLevelCD: ['OFFICE_LEVEL_CD'].fetchString(json),
      rankCD: ['RANK_CD'].fetchString(json),
      officerRank: ['OFFICER_RANK'].fetchString(json),
      issued: ['.issued'].fetchString(json),
      expires: ['.expires'].fetchString(json),
      error: ['error'].fetchString(json),
      errorDescription: ['error_description'].fetchString(json),
      userType: ['USER_TYPE'].fetchString(json),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "userName": userName,
        "PERSON_NAME": personName,
        "PS_CD": psCd,
        "DISTRICT_CD": districtCD,
        "MOBILE_2": mobile2,
        "PERSON_CODE": personCode,
        "EMAIL": email,
        "ROLE_CD": roleCD,
        "ROLE": role,
        "PS": ps,
        "STATE": state,
        "DISTRICT": district,
        "OFFICE_CD": officeCD,
        "OFFICE_TYPE_DESC": officeTypeDesc,
        "OFFICE_TYPE_CD": officeTypeCD,
        "MOBILE_1": mobile1,
        "OFFICE_LEVEL_CD": officeLevelCD,
        "RANK_CD": rankCD,
        "OFFICER_RANK": officerRank,
        ".issued": issued,
        ".expires": expires,
        "error": error,
        "error_description": errorDescription,
        "USER_TYPE": userType
      };

  static Future<LoginResponseModel> fromPreference() async {
    var userJson = await PreferenceHelper().getString(AppUser.prefKey);
    LoginResponseModel user =
        LoginResponseModel.fromJson(jsonDecode(userJson!));
    return user;
  }
/*User getUser() {
        User user = new User();
        user.district = this.district;
        user.districtCD = this.districtCD;
        user.email = this.email;
        user.mobile1 = this.mobile1;
        user.mobile2 = this.mobile2;
        user.officeCD = this.officeCD;
        user.officeLevelCD = this.officeLevelCD;
        user.officerRank = this.officerRank;
        user.officeTypeCD = this.officeTypeCD;
        user.officeTypeDesc= this.officeTypeDesc;
        user.personCode= this.personCode;
        user.personName= this.personName;
        user.ps= this.ps;
        user.psCD= this.psCD;
        user.rankCD= this.rankCD;
        user.role= this.role;
        user.roleCD= this.roleCD;
        user.state= this.state;
        user.userName= this.userName;
        return user;
    }*/
}
