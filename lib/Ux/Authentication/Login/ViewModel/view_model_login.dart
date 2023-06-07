import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/CountryDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/LoginDataModel.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/countries.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';
import 'package:twopa_sales_manager/Utils/app_log.dart';
import 'package:twopa_sales_manager/Utils/pair.dart';
import 'package:twopa_sales_manager/Ux/Authentication/Verification/verification_page.dart';

class ViewModelLogin extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<Pair<RedirectVerificationModel, LoginDataModel>>
      _responseStreamController = StreamController();

  Stream<Pair<RedirectVerificationModel, LoginDataModel>> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestLogin(
    TextEditingController mobileController,
    TextEditingController passwordController,
    String deviceInfo,
  ) async {
    AppLog.e("HELLO", "DATA");
    String _username = mobileController.text.trim();
    String _password = passwordController.text.trim();
    String _error = _validateUserDetails(_username, _password);
    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["username"] = Encoder.encode(_username);
      requestMap["pass"] = Encoder.encode(_password);
      requestMap["is_sales"] = Encoder.encode("false");
      requestMap["device_info"] = Encoder.encode(deviceInfo);
      requestMap["device_details"] = Encoder.encode("Empty Send");
      requestMap["fcm_token_key"] = Encoder.encode("Empty Send");
      request(
        networkRequest.loginUser(requestMap),
        (map) {
          LoginDataModel dataModel = LoginDataModel();
          dataModel.parseData(map);
          var redirect = RedirectVerificationModel(
            requestMap["username"],
            requestMap["pass"],
            requestMap["is_sales"],
            requestMap["device_info"],
            requestMap["device_details"],
            requestMap["fcm_token_key"],
          );
          _responseStreamController.sink.add(Pair(redirect, dataModel));
        },
        errorType: ErrorType.POPUP,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  String _validateUserDetails(String number, String password) {
    if (number.isEmpty)
      return "Please Enter Username Number";
    else if (password.isEmpty)
      return "Please Enter Password";
    else
      return "";
  }
}
