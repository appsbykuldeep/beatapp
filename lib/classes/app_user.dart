import 'dart:convert';

import 'package:beatapp/constants/enums/app_user_type_enum.dart';
import 'package:beatapp/model/login_response.dart';
import 'package:beatapp/model/offices_response.dart';
import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/utility/build_utils.dart';

class AppUser {
  AppUser._();

  static LoginResponse user = LoginResponse.fromJson({});
  static BuildDetails buildDetails = BuildDetails.empty;
  static final pref = PreferenceHelper();
  static const String prefKey = "UserInfo";

  static String get PS_CD => user.psCd;
  static String get ACCESS_TOKEN => user.accessToken;
  static String get USER_TYPE => user.userType;
  static String get ROLE_CD => user.roleCd;
  static String get OFFICE_TYPE => user.officeTypeCd;
  static String get OFFICE_Name => user.officeName;
  static String get APP_VERSION_CODE => buildDetails.buildNumber;
  static String get PERSON_NAME => user.personName;

  static AppUserType get appUserType => switch (int.tryParse(ROLE_CD)) {
        null => AppUserType.other,
        2 => AppUserType.sho,
        3 => AppUserType.invitigativeOfficer,
        4 => AppUserType.eo,
        11 => AppUserType.co,
        12 => AppUserType.liu,
        13 => AppUserType.dcrb,
        16 => AppUserType.sp,
        17 => AppUserType.sp,
        23 => AppUserType.headConst,
        // Officer
        (18 || 19 || 24 || 25 || 26 || 34 || 37 || 101) => AppUserType.officer,
        _ => AppUserType.other,
      };

  static Future<void> setBuildDetails() async {
    buildDetails = await BuildUtils.getappBuild();
  }

  static void logoutUser() {
    user = LoginResponse.fromJson({});
    pref.saveString(prefKey, "");
  }

  static set setSaveUserDetail(LoginResponse e) {
    user = e;
    saveUserDetail();
  }

  static void updateByOfficeDetails(OfficesResponse office) {
    user.roleCd = office.rolecd.toString();
    user.officeTypeCd = office.officetype;
    user.officeName = office.officename;

    saveUserDetail();
  }

  static void saveUserDetail() {
    pref.saveString(
      prefKey,
      jsonEncode(user.toJson()),
    );
  }

  static Future<void> setByLocalStorage() async {
    try {
      var userJson = await pref.getString(prefKey);
      if (userJson == null || userJson.isEmpty) return;
      user = LoginResponse.fromJson(jsonDecode(userJson));
    } catch (e) {
      print(e);
      user = LoginResponse.fromJson({});
    }
  }

  static Future<LoginResponse> getByLocalStorage() async {
    LoginResponse userInfo = LoginResponse.fromJson({});
    try {
      var userJson = await pref.getString(prefKey);
      if (userJson == null || userJson.isEmpty) return userInfo;
      user = LoginResponse.fromJson(jsonDecode(userJson));
    } catch (e) {
      return userInfo;
    }
    return userInfo;
  }
}
