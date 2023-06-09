import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:twopa_sales_manager/NetworkRequest/network_request.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_log.dart';
import 'package:twopa_sales_manager/Utils/app_request_code.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';
import 'package:twopa_sales_manager/Utils/app_string.dart';

abstract class BaseViewModel {
  @protected
  NetworkRequest networkRequest = NetworkRequest.instance;

  final StreamController<Map<String, dynamic>> _errorStreamController =
      StreamController();

  Stream<Map<String, dynamic>> get errorStream => _errorStreamController.stream;

  final StreamController<Map<String, dynamic>> _requestTypeStreamController =
      StreamController();

  Stream<Map<String, dynamic>> get requestTypeStream =>
      _requestTypeStreamController.stream;

  @mustCallSuper
  void disposeStream() {
    _errorStreamController.close();
    _requestTypeStreamController.close();
  }

  @protected
  request(Future<Response> request, Function(Map<String, dynamic>) onSuccess,
      {RequestType requestType = RequestType.NONE,
      ErrorType errorType = ErrorType.NONE,
      bool isResponseStatus = false}) async {
    try {
      ConnectivityResult _connectivityResult =
          await Connectivity().checkConnectivity();
      if (_connectivityResult == ConnectivityResult.none) {
        return _throwError(AppRequestCode.SERVER_ERROR,
            AppString.no_internet_connection, errorType);
      } else {
        _handleProgress(true, requestType);
        Response<dynamic> response = await request;
        _handleProgress(false, requestType);
        AppLog.e("Result ${response.statusCode}", response.data);
        if (response.data != null && response.data.isNotEmpty) {
          String _decodeBody = Encoder.decode(response.data);
          AppLog.e("Result ${response.statusCode}", _decodeBody);
          var _resultBody = jsonDecode(_decodeBody);
          if (toInt(_resultBody[AppRequestKey.RESPONSE_CODE]) == 401) {
            return _throwError(401,
                toString(_resultBody[AppRequestKey.RESPONSE_MSG]), errorType);
          } else if (toBoolean(_resultBody[AppRequestKey.RESPONSE]) ||
              isResponseStatus) {
            try{
              onSuccess(_resultBody);
            }catch(e){}
            return AppRequestCode.OK;
          } else {
            return _throwError(response.statusCode,
                toString(_resultBody[AppRequestKey.RESPONSE_MSG]), errorType);
          }
        } else {
          return _throwError(
              response.statusCode, response.statusMessage, errorType);
        }
      }
    } on DioError catch (dioError) {
      _handleProgress(false, requestType);
      if (dioError.type == DioErrorType.connectTimeout)
        return _throwError(AppRequestCode.SERVER_ERROR,
            AppString.connection_time_out, ErrorType.NONE);
      else if (dioError.type == DioErrorType.other) {
        AppLog.e("ERROR_OTHER", dioError.error.toString());
        var error = dioError.error.toString();
        if (error.contains("Network is unreachable")) {
          return _throwError(AppRequestCode.SERVER_ERROR,
              AppString.no_internet_connection, ErrorType.POPUP);
        } else {
          return _throwError(AppRequestCode.SERVER_ERROR,
              AppString.something_went_wrong, ErrorType.NONE);
        }
      } else {
        return _throwError(AppRequestCode.SERVER_ERROR, "", ErrorType.NONE);
      }
    } on Exception {
      _handleProgress(false, requestType);
      return _throwError(AppRequestCode.SERVER_ERROR,
          AppString.something_went_wrong, ErrorType.BANNER);
    }
  }

  int _throwError(int? statusCode, String? message, ErrorType errorType) {
    _errorStreamController.sink.add({
      AppRequestKey.RESPONSE_CODE: statusCode,
      AppRequestKey.RESPONSE_MSG: message,
      AppRequestKey.ERROR_TYPE: errorType,
    });
    return statusCode ?? 0;
  }

  void _handleProgress(bool status, RequestType type) {
    if (!_requestTypeStreamController.isClosed)
      _requestTypeStreamController.sink.add({
        AppRequestKey.SHOW_PROGRESS: status,
        AppRequestKey.PROGRESS_TYPE: type,
      });
  }
}
