import 'dart:convert';
import 'dart:io';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/logger.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

final _dio = Dio();

Response get emptyresponse => Response(
      requestOptions: RequestOptions(),
      statusCode: 0,
      data: "Something is wrong !",
    );

Future<Response> getRequest(
    BuildContext context, String url, bool showDialog) async {
  showDialog ? DialogHelper.showLoaderDialog(context) : null;
  Response response;
  Logger.printLogMsg(EndPoints.BASE_URL + url);
  try {
    response = await _dio.get(EndPoints.BASE_URL + url);
  } on DioException catch (e) {
    Logger.printLogMsg(e.message.toString());
    throw Exception(e.message);
  }
  if (showDialog == true) {
    Navigator.pop(context);
  }
  if (response.statusCode == 200) {
    Logger.printLogMsg('post response $response');
  } else if (response.statusCode == 401) {
    NavigatorUtils.expireAuthentication(context);
  } else {
    MessageUtility.showToast(context, response.statusMessage!);
  }
  return response;
}

Future<Response> getRequestWithToken(
    BuildContext context, String url, showDialog) async {
  showDialog ? DialogHelper.showLoaderDialog(context) : null;

  String? accessToken = AppUser.ACCESS_TOKEN;
  Response response;
  Logger.printLogMsg(EndPoints.BASE_URL + url);
  try {
    response = await _dio.get(EndPoints.BASE_URL + url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'}));
    showDialog ? Navigator.pop(context) : null;
    if (response.statusCode == 200) {
      Logger.printLogMsg('post response $response');
    } else if (response.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    } else {
      MessageUtility.showToast(context, response.statusMessage!);
    }
    return response;
  } on DioException catch (e) {
    Logger.printLogMsg(e.message.toString());
    showDialog ? Navigator.pop(context) : null;
    if (e.response!.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    }
    return e.response!;
    //throw Exception(e.response?.statusMessage);
  }
}

Future<Response> postRequestImage(
    BuildContext context, String url, data, bool showDialog) async {
  showDialog ? DialogHelper.showLoaderDialog(context) : null;
  Logger.printLogMsg(EndPoints.BASE_URL + url);
  Response response;
  try {
    response = await _dio.post(
      EndPoints.BASE_URLToken + url,
    );
    showDialog ? Navigator.pop(context) : null;
    if (response.statusCode == 200) {
      //print('post response $response');
    } else {
      MessageUtility.showToast(context, response.statusMessage!);
    }
    return response;
  } on DioException catch (e) {
    Logger.printLogMsg(e.message.toString());
    showDialog ? Navigator.pop(context) : null;
    if (e.response!.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    }
    return e.response!;
    //throw Exception(e.response?.statusMessage);
  }
}

Future<Response> postRequestWithHeaderAndBody(
    BuildContext context, String url, header, data, showDialog) async {
  showDialog ? DialogHelper.showLoaderDialog(context) : null;
  Logger.printLogMsg(EndPoints.BASE_URLToken + url);
  Response response;
  try {
    response = await _dio.post(
      EndPoints.BASE_URLToken + url,
      data: data,
      options: Options(headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'otp': header["otp"],
      }),
    );
    showDialog ? Navigator.pop(context) : null;
    print(response.data);
    if (response.statusCode == 200) {
      Logger.printLogMsg('post response $response');
    } else {
      MessageUtility.showToast(context, response.statusMessage!);
    }
    return response;
  } on DioException catch (e) {
    print(e);
    Logger.printLogMsg(e.message.toString());
    showDialog ? Navigator.pop(context) : null;
    return e.response!;
    //throw Exception(e.response?.statusMessage);
  }
}

Future<Response> postRequestWithToken(
    BuildContext context, String url, bool showDialog) async {
  showDialog ? DialogHelper.showLoaderDialog(context) : null;
  String? token = AppUser.ACCESS_TOKEN;
  Logger.printLogMsg(EndPoints.BASE_URL + url);
  Response response;
  try {
    response = await _dio.post(
      EndPoints.BASE_URL + url,
      options: Options(headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      }),
    );
    showDialog ? Navigator.pop(context) : null;
    if (response.statusCode == 200) {
      Logger.printLogMsg('post response $response');
    } else if (response.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    } else {
      MessageUtility.showToast(context, response.statusMessage!);
    }
    return response;
  } on DioException catch (e) {
    Logger.printLogMsg(e.message.toString());
    showDialog ? Navigator.pop(context) : null;
    if (e.response!.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    }
    return e.response!;
    //throw Exception(e.response?.statusMessage);
  }
}

Future<Response> postRequestWithTokenAndBody(
    BuildContext context, String url, data, bool showDialog) async {
  showDialog ? DialogHelper.showLoaderDialog(context) : null;
  String? token = AppUser.ACCESS_TOKEN;
  print(token);
  Response response = Response(
    requestOptions: RequestOptions(),
    statusCode: 0,
    data: "Something is wrong !",
  );
  Logger.printLogMsg(EndPoints.BASE_URL + url);
  try {
    print(jsonEncode(data));
    response = await _dio.post(
      EndPoints.BASE_URL + url,
      data: jsonEncode(data),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // sendTimeout: const Duration(minutes: 2),
        // receiveTimeout: const Duration(minutes: 2),
      ),
    );
    print("Status ${response.statusCode}");
    print("Res ${response.data}");
    showDialog ? Navigator.pop(context) : null;
    if (response.statusCode == 200) {
      Logger.printLogMsg('post response $response');
    } else if (response.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    } else if (response.statusCode == 404) {
      MessageUtility.showToast(context, "Page Not Found...");
    } else {
      MessageUtility.showToast(context, response.statusMessage!);
    }
    return response;
  } on DioException catch (e) {
    print("Err $e");
    print("Err ${e.response?.statusCode}");
    response = Response(requestOptions: RequestOptions());
    response.statusCode = e.response?.statusCode ?? 0;
    response.data = e.message.toString();
    Logger.printLogMsg(e.message.toString());
    showDialog ? Navigator.pop(context) : null;
    if (e.response != null && e.response!.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    }
    return response;
    //throw Exception(e.response?.statusMessage);
  }
}

Future<Response> postRequestWithBody(
    BuildContext context, String url, data, bool showDialog) async {
  final ByteData certttt = await rootBundle.load('assets/uppolice.crt');
  final Uint8List crtData = certttt.buffer.asUint8List();

  showDialog ? DialogHelper.showLoaderDialog(context) : null;
  Logger.printLogMsg(EndPoints.BASE_URL + url);
  Response response = emptyresponse;
  try {
    response = await _dio.post(
      EndPoints.BASE_URL + url,
      data: jsonEncode(data),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Certificate-Pinning': 'true',
          'Certificate': crtData
        },
      ),
    );
    showDialog ? Navigator.pop(context) : null;
    if (response.statusCode == 200) {
      Logger.printLogMsg('post response $response');
    } else if (response.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    } else {
      MessageUtility.showToast(context, response.statusMessage!);
    }
    return response;
  } on DioException catch (e) {
    print(e);
    response.data = (e.message ?? "");

    showDialog ? Navigator.pop(context) : null;

    return e.response!;
    //throw Exception(e.response?.statusMessage);
  }
}

Future<Response> postRequestTokenWithBody(
    BuildContext context, String url, data, bool showDialog) async {
  showDialog ? DialogHelper.showLoaderDialog(context) : null;
  Logger.printLogMsg(EndPoints.BASE_URL + url);
  String? accessToken = AppUser.ACCESS_TOKEN;
  Response response;
  try {
    response = await _dio.post(EndPoints.BASE_URL + url,
        data: jsonEncode(data),
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }));
    showDialog ? Navigator.pop(context) : null;
    if (response.statusCode == 200) {
      Logger.printLogMsg('post response $response');
    } else if (response.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    } else {
      MessageUtility.showToast(context, response.statusMessage!);
    }
    return response;
  } on DioException catch (e) {
    Logger.printLogMsg(e.message.toString());
    showDialog ? Navigator.pop(context) : null;
    if (e.response!.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    }
    return e.response!;
    //throw Exception(e.response?.statusMessage);
  }
}

Future<Response> postRequestImageWithTokenAndData(
    BuildContext context, String url, data, bool showDialog) async {
  String? accessToken = AppUser.ACCESS_TOKEN;
  Logger.printLogMsg(EndPoints.BASE_URL + url);
  Response response;
  try {
    response = await _dio.post(
      EndPoints.BASE_URL + url,
      data: data,
      options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'}),
    );
    'post response $response';
    showDialog ? Navigator.pop(context) : null;
    if (response.statusCode == 200) {
      Logger.printLogMsg('post response $response');
    } else if (response.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    } else {
      MessageUtility.showToast(context, response.statusMessage!);
    }
    return response;
  } on DioException catch (e) {
    Logger.printLogMsg(e.message.toString());
    showDialog ? Navigator.pop(context) : null;
    if (e.response!.statusCode == 401) {
      NavigatorUtils.expireAuthentication(context);
    }
    return e.response!;
  }
}

// Future<String?> getAccessToken() {
//   return PreferenceHelper().getString(Constraints.ACCESS_TOKEN);
// }

/*String getAccessToken() {
  return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6Ijk0NTQ0MDQzMTUiLCJzdWIiOiI5NDU0NDA0MzE1IiwiaXNzIjoiaHR0cDovL2p3dGF1dGh6c3J2LmF6dXJld2Vic2l0ZXMubmV0IiwiYXVkIjoiMDk5MTUzYzI2MjUxNDliYzhlY2IzZTg1ZTAzZjAwMjIiLCJleHAiOjE2ODQ5NjM0OTIsIm5iZiI6MTY4NDk0NTQ5Mn0.Fb4Oba-JZWmiveLaaFy61vjzCvipHTk7mw-CcmdDufM";
}*/
