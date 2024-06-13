import 'dart:convert';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/main.dart';
import 'package:http/http.dart';

Future<Response> getVersion({String endPoint = ''}) async {
  return await post(Uri.parse("http://45.64.156.147/PrahariAPI/$endPoint"),
      headers: {"Content-Type": "application/json"});
}

Future<Response> callApiLogin(
    {String endPoint = '', final request, String headerValue = ''}) async {
  print(jsonEncode(request));
  return await client.post(Uri.parse(EndPoints.BASE_URLToken + endPoint),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'otp': headerValue,
      },
      body: request);
}

Future<Response> callApi({String endPoint = '', final request}) async {
  String token = AppUser.ACCESS_TOKEN;
  print(jsonEncode(request));
  print(EndPoints.BASE_URL + endPoint);
  return await client.post(Uri.parse(EndPoints.BASE_URL + endPoint),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request));
}
