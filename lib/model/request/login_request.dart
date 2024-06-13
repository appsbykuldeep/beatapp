import 'package:beatapp/preferences/constraints.dart';

class LoginRequest {
  String? mobileNo;
  String? deviceId;
  String? clientId;
  String? loginType;
  String? otp;
  String? password;

  LoginRequest(this.mobileNo,this.otp ,this.deviceId, this.password);

  Map<String, dynamic> header() => {"otp": otp};

  Map<String, dynamic> toJson() => {
        "username": mobileNo,
        "password": password ?? "Login",
        "grant_type": "password",
        "userrefreshtoken": "false",
        "LoginType": password != null ? "P" :"O",
        "client_id": Constraints.CLIENT_ID
      };
}
