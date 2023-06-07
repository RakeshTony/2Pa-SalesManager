import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/DefaultDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';

class ViewModelSetMPin extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestSetMPin(
      TextEditingController mPinController) async {
    String _mPin = mPinController.text.trim();
    String _error = _validateDetails(_mPin);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["pin"] = Encoder.encode(_mPin);
      request(
        networkRequest.setMPin(requestMap),
        (map) {
          DefaultDataModel dataModel = DefaultDataModel();
          dataModel.parseData(map);
          _responseStreamController.sink.add(dataModel);
        },
        errorType: ErrorType.POPUP,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  void requestForgotPasswordInside() async {
    HashMap<String, dynamic> requestMap = HashMap();
    request(
      networkRequest.resetPassword(requestMap),
          (map) {
        DefaultDataModel dataModel = DefaultDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );

  }

  String _validateDetails(String mPin) {
    if (mPin.isEmpty)
      return "Please Enter Pin";
    else
      return "";
  }
}
