// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/call_api.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/login_response.dart';
import 'package:beatapp/model/request/login_request.dart';
import 'package:beatapp/preferences/constraints.dart';
import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/ui/dashboard/user_office_view.dart';
import 'package:beatapp/ui/signup/signup.dart';
import 'package:beatapp/utility/build_utils.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/input_formatters.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/methods.dart';
import 'package:beatapp/utility/permission_helper.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPassword = false;
  String _responseOTP = "";
  final TextEditingController _con_MobileNo =
      TextEditingController(text: kDebugMode ? '7839858252' : '');
  final TextEditingController _con_Password =
      TextEditingController(text: kDebugMode ? 'sot@123' : '');
  final TextEditingController _con_OtpBox1 = TextEditingController();
  final TextEditingController _con_OtpBox2 = TextEditingController();
  final TextEditingController _con_OtpBox3 = TextEditingController();
  final TextEditingController _con_OtpBox4 = TextEditingController();

  BuildDetails buildDetails = BuildDetails.empty;

  /*
  
  SHO :: 9454404241 :: sot@123

  Beat const :: 7839858252 :: Otp login

  SP  :: 9454400305 :: spsdr@3051
  
  81159 55084
   */

  @override
  void dispose() {
    _con_MobileNo.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getBuildDetails();
    PermissionHelper().permission();
  }

  Future<void> _mobileValidateOTP() async {
    var param = {
      "LoginID": _con_MobileNo.text.toString(),
    };
    /* final res=await callApiLogin(endPoint:EndPoints.END_POINT_VALIDATE_MOBILE,request: param );
    print(res.body);*/
    print(param);
    var response = await HttpRequst.postRequestWithBody(
        context, EndPoints.END_POINT_VALIDATE_MOBILE, param, true);

    print("code ${response.statusCode}");
    print("code ${response.data}");
    if (response.statusCode == 200 &&
        !response.toString().contains("Invalid User Detail")) {
      _responseOTP = response.data.toString();
      showOTPDialog(context);
    } else {
      MessageUtility.showToast(context, response.data!);
    }
    setState(() {});
  }

  String getOTP() {
    String otp = "";
    otp = _con_OtpBox1.text +
        _con_OtpBox2.text +
        _con_OtpBox3.text +
        _con_OtpBox4.text;
    return otp;
  }

  Future<void> getBuildDetails() async {
    buildDetails = await BuildUtils.getappBuild();
  }

  void _logInWithOTP() async {
    role = "";
    dashboardMenu.clear();
    personName.value = '';
    var loginData = LoginRequest(_responseOTP, getOTP(), null, null);
    var header = loginData.header();
    var param = loginData.toJson();
    var response = await HttpRequst.postRequestWithHeaderAndBody(
      context,
      EndPoints.END_POINT_LOGIN,
      header,
      param,
      true,
    );
    print("code ${response.statusCode}");
    if (response.statusCode == 200) {
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      // saveUserObject(response.data);
      AppUser.setSaveUserDetail = loginResponse;
      PreferenceHelper().saveBool(Constraints.IS_LOGIN, true);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const UserOfficeView(),
        ),
        (route) => false,
      );
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text("error_mobile_valid"));
    }
    setState(() {});
  }

  void _logInWithPassword() async {
    showLoader();
    role = '';
    personName.value = '';
    dashboardMenu.clear();
    var loginData = LoginRequest(
      _con_MobileNo.text.toString(),
      _con_Password.text,
      null,
      _con_Password.text,
    );
    var param = loginData.toJson();
    final res = await callApiLogin(
      endPoint: EndPoints.END_POINT_LOGIN,
      request: param,
      headerValue: _con_Password.text,
    );

    print(res.body);
    hideLoader();
    if (res.statusCode == 200) {
      LoginResponse loginResponse = loginResponseFromJson(res.body);
      // saveUserObject(res.body);
      AppUser.setSaveUserDetail = loginResponse;

      // pref.saveString(Constraints.PS_CD, loginResponse.psCd);
      // pref.saveString(Constraints.ACCESS_TOKEN, loginResponse.accessToken);
      // pref.saveString(Constraints.USER_TYPE, loginResponse.userType);
      // pref.saveString(Constraints.ROLE_CD, loginResponse.roleCd);
      // pref.saveString(Constraints.APP_VERSION_CODE, buildDetails.buildNumber);
      // pref.saveString(Constraints.PERSON_NAME, loginResponse.personName);
      PreferenceHelper().saveBool(Constraints.IS_LOGIN, true);
      Get.to(() => const UserOfficeView());
    }
  }

  final formKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        body: Container(
          margin: const EdgeInsets.fromLTRB(16, 35, 16, 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "Version : ${BuildUtils.appVersion}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Text(
                          'Prahari (Beat Policing)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorProvider.transparent_black,
                            fontSize: SizeProvider.size_24,
                          ),
                        ),
                      ),
                      24.height,
                      Image.asset(
                        "assets/images/ic_launcher.png",
                        height: SizeProvider.size_150,
                        width: SizeProvider.size_150,
                      ),
                      24.height,
                      Form(
                        key: formKey,
                        child: EditText(
                          hintText: 'mobile_number',
                          labelText: 'mobile_number',
                          prefixText: "+91 ",
                          maxLength: 10,
                          controller: _con_MobileNo,
                          validator: Validations.mobileValidator,
                          textInputType: TextInputType.phone,
                          inputFormatters: digitOnly,
                          suffixIcon: const Icon(
                            Icons.phone_android,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      12.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  _mobileValidateOTP();
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    ("assets/images/ic_otp.png"),
                                    height: SizeProvider.size_35,
                                    width: SizeProvider.size_35,
                                    color: Color(ColorProvider.colorPrimary),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.all(SizeProvider.size_15),
                                    child: Text(
                                      AppTranslations.of(context)!
                                          .text("via_otp"),
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const VerticalDivider(
                                    color: Colors.grey, thickness: 2),
                                Padding(
                                  padding: EdgeInsets.all(SizeProvider.size_15),
                                  child: Text(
                                      AppTranslations.of(context)!.text("or"),
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ),
                                const VerticalDivider(
                                    color: Colors.grey, thickness: 2),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                _isPassword = !_isPassword;
                                setState(() {});
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/ic_password.png",
                                    height: SizeProvider.size_35,
                                    width: SizeProvider.size_35,
                                    color: Color(ColorProvider.colorPrimary),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.all(SizeProvider.size_15),
                                    child: Text(
                                        AppTranslations.of(context)!
                                            .text("via_password"),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      _isPassword
                          ? Column(
                              children: [
                                Form(
                                  key: passwordFormKey,
                                  child: EditText(
                                    hintText: 'password',
                                    labelText: 'password',
                                    controller: _con_Password,
                                    validator: Validations.emptyValidator,
                                    textInputType:
                                        TextInputType.visiblePassword,
                                    suffixIcon: const Icon(
                                      Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),

                                // Color(ColorProvider.colorPrimary),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate() &&
                                            passwordFormKey.currentState!
                                                .validate()) {
                                          _logInWithPassword();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(
                                              ColorProvider.colorPrimary)),
                                      child: Text(
                                        AppTranslations.of(context)!
                                            .text("login"),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const Signup());
                        },
                        child: Padding(
                          padding: EdgeInsets.all(SizeProvider.size_15),
                          child: const Text(
                            "Don't have an account? Register here",
                            //AppTranslations.of(context)!.text("for_police_only"),
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }

  FocusNode focus_box1 = FocusNode();
  FocusNode focus_box2 = FocusNode();
  FocusNode focus_box3 = FocusNode();
  FocusNode focus_box4 = FocusNode();

  void showOTPDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "OTP",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * .90,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF000000),
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    //BoxShadow
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.all(PaddingAndMarginProvider.padding_20),
                    child: Text(
                      AppTranslations.of(context)!.text(
                        "verification",
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(ColorProvider.grey_60),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      "assets/images/img_code_verification.png",
                      height: SizeProvider.size_60,
                      width: SizeProvider.size_60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppTranslations.of(context)!.text(
                        "message_otp",
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(ColorProvider.grey_60),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextField(
                                obscureText: true,
                                controller: _con_OtpBox1,
                                textAlign: TextAlign.center,
                                focusNode: focus_box1,
                                maxLength: 1,
                                maxLines: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: const InputDecoration(
                                  counterText: "",
                                ),
                                onChanged: (value) => {
                                      if (value.isNotEmpty)
                                        {focus_box2.requestFocus()}
                                    }),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextField(
                              obscureText: true,
                              controller: _con_OtpBox2,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              focusNode: focus_box2,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                counterText: "",
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  focus_box3.requestFocus();
                                } else {
                                  focus_box1.requestFocus();
                                }
                              },
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextField(
                                obscureText: true,
                                controller: _con_OtpBox3,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                maxLength: 1,
                                maxLines: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  counterText: "",
                                ),
                                focusNode: focus_box3,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    focus_box4.requestFocus();
                                  } else {
                                    focus_box2.requestFocus();
                                  }
                                }),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextField(
                                obscureText: true,
                                controller: _con_OtpBox4,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                maxLength: 1,
                                maxLines: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  counterText: "",
                                ),
                                focusNode: focus_box4,
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    focus_box3.requestFocus();
                                  }
                                }),
                          )),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.fromLTRB(0, 15, 15, 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _mobileValidateOTP();
                      },
                      child: Text(
                        AppTranslations.of(context)!.text("resend_otp"),
                        style: const TextStyle(
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () => {Navigator.pop(context, false)},
                        child: Container(
                          width: MediaQuery.of(context).size.width * .35,
                          margin: const EdgeInsets.only(right: 5, bottom: 15),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                            color: Color(ColorProvider.colorPrimary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            AppTranslations.of(context)!.text("cancel"),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          if (getOTP().length == 4)
                            {_logInWithOTP()}
                          else
                            {
                              MessageUtility.showToast(
                                  context, "Please enter Otp")
                            }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .35,
                          margin: const EdgeInsets.only(left: 5, bottom: 15),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                            color: Color(ColorProvider.colorPrimary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            AppTranslations.of(context)!.text("verify"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  // saveUserObject(dynamic data) {
  //   PreferenceHelper().saveString(
  //     Constraints.USER_DATA,
  //     data is Map ? jsonEncode(data) : data,
  //   );
  // }
}
