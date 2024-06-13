import 'dart:convert';

import 'package:beatapp/model/login_response.dart';
import 'package:beatapp/model/offices_response.dart';
import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/utility/build_utils.dart';

class AppUser {
  AppUser._();

  // static final AppUser _instance = AppUser._();
  // static AppUser get instance => _instance;

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

  static Future<void> setBuildDetails() async {
    buildDetails = await BuildUtils.getappBuild();
  }

  static void logoutUser() {
    user = LoginResponse.fromJson({});
    pref.saveString(prefKey, "");
  }

  static void setSaveUserDetail(LoginResponse e) {
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
