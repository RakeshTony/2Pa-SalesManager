import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/DefaultDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/UserRanksPlansDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';

class ViewModelAddPlan extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<PlansData>> _ranksPlanStreamController =
      StreamController();

  Stream<List<PlansData>> get plansStream => _ranksPlanStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _ranksPlanStreamController.close();
    super.disposeStream();
  }

  void requestCreateAgent(
    TextEditingController nameController,
    TextEditingController codeController,
    TextEditingController minController,
    TextEditingController maxController,
  ) async {
    String _planName = nameController.text.trim();
    String _planCode = codeController.text.trim();
    String _minAmount = minController.text.trim();
    String _maxAmount = maxController.text.trim();
    String _error =
        _validateUserDetails(_planName, _planCode, _minAmount, _maxAmount);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["is_agent"] = Encoder.encode("1");
      requestMap["plan_name"] = Encoder.encode(_planName);
      requestMap["plan_code"] = Encoder.encode(_planCode);
      requestMap["min_transfer_amount"] = Encoder.encode(_minAmount);
      requestMap["max_transfer_amount"] = Encoder.encode(_maxAmount);
      request(
        networkRequest.managePlans(requestMap),
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

  void requestUpdatePlan(
    TextEditingController nameController,
    TextEditingController codeController,
    TextEditingController minController,
    TextEditingController maxController,
    String editUserId,
  ) async {
    String _planName = nameController.text.trim();
    String _planCode = codeController.text.trim();
    String _minAmount = minController.text.trim();
    String _maxAmount = maxController.text.trim();
    String _error =
        _validateUserDetails(_planName, _planCode, _minAmount, _maxAmount);
    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["is_agent"] = Encoder.encode("1");
      requestMap["id"] = Encoder.encode(editUserId);
      requestMap["plan_name"] = Encoder.encode(_planName);
      requestMap["plan_code"] = Encoder.encode(_planCode);
      requestMap["min_transfer_amount"] = Encoder.encode(_minAmount);
      requestMap["max_transfer_amount"] = Encoder.encode(_maxAmount);
      request(
        networkRequest.managePlans(requestMap),
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

  String _validateUserDetails(
    String name,
    String planCode,
    String minAmount,
    String maxAmount,
  ) {
    if (name.isEmpty)
      return "Please Enter Plan Name";
    else if (planCode.isEmpty)
      return "Please Enter Plan Code";
    else if (minAmount.isEmpty)
      return "Please Enter Min Amount";
    else if (maxAmount.isEmpty)
      return "Please Enter Max Amount";
    else
      return "";
  }
}
