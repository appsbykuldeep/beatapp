import 'dart:async';

import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/model/api_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/string_ext.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<ApiResponse> dioApiCall({
  required String endPoint,
  dynamic apibody,
  Map<String, String>? apiheders,
  bool bygetmethod = false,
  int timeoutSec = 180,
  bool showDialog = true,
  CancelToken? cancelToke,
}) async {
  ApiResponse responsemodel = ApiResponse();

  if (showDialog) {
    DialogHelper.showLoaderDialog();
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${AppUser.ACCESS_TOKEN}',
    ...apiheders ?? {},
  };

  debugPrint('Dio response $apibody');

  final dioOptions = Options(
    headers: headers,
    sendTimeout: Duration(seconds: timeoutSec),
    receiveTimeout: Duration(seconds: timeoutSec),
    responseType: ResponseType.json,
    validateStatus: (status) => true,
  );

  Response dioResponse;
  Dio dio = Dio();

  final url = endPoint.attachHost();

  debugPrint("url : $url");

  try {
    if (bygetmethod) {
      dioResponse = await dio.get(
        url,
        options: dioOptions,
        cancelToken: cancelToke,
      );
    } else {
      dioResponse = await dio.post(
        url,
        data: apibody,
        options: dioOptions,
        cancelToken: cancelToke,
      );
    }

    cancelToke = null;
    responsemodel.statusCode = dioResponse.statusCode ?? 0;
    responsemodel.resultMsj = errorMsjBucode(dioResponse.statusCode ?? 404);
    print(dioResponse.statusCode);
    print(dioResponse.data);

    if (dioResponse.statusCode == 200) {
      responsemodel.resultStatus = true;
      responsemodel.resultData = dioResponse.data;
    }
  } on DioException catch (e) {
    if (e.response != null) {
      responsemodel.statusCode = e.response!.statusCode ?? 0;
    } else if ([DioExceptionType.receiveTimeout, DioExceptionType.sendTimeout]
        .contains(e.type)) {
      responsemodel.statusCode = 408;
    }
  } on Exception {
    responsemodel.statusCode = 1010;
  } catch (derr) {
    responsemodel.statusCode = 1020;
  }

  if (showDialog) {
    DialogHelper.hideLoaderDialog();
  }

  if (responsemodel.statusCode == 401 && !endPoint.isLoginEndPoint()) {
    NavigatorUtils.expireAuthentication();
  }

  if (responsemodel.resultMsj.isEmpty) {
    responsemodel.resultMsj = errorMsjBucode(responsemodel.statusCode);
  }
  return responsemodel;
}

String errorMsjBucode(int? code) {
  code ??= 0;
  if ([401, 402].contains(code)) {
    return _statusCodeErrMsj[401] ?? '';
  }

  if (code >= 500 && code <= 599) {
    return _statusCodeErrMsj[500] ?? '';
  }

  return _statusCodeErrMsj[code] ?? "Something is wrong.($code)";
}

Map<int, String> _statusCodeErrMsj = {
  101: 'Please update your app',
  200: 'Response received.',
  400: 'Bad Request',
  401: 'Unauthorized User',
  404: "Not Found",
  408: 'Server not responding or network is slow.',
  500: 'Server error',
};
