import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/DefaultDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/UserRanksPlansDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';

class ViewModelAddAgent extends BaseViewModel {
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
    TextEditingController emailController,
    TextEditingController mobileController,
    TextEditingController addressController,
    String planId,
  ) async {
    String _name = nameController.text.trim();
    String _email = emailController.text.trim();
    String _mobile = mobileController.text.trim();
    String _address = addressController.text.trim();
    String _error = _validateUserDetails(_name, _email, _mobile, planId);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["name"] = Encoder.encode(_name);
      requestMap["email"] = Encoder.encode(_email);
      requestMap["mobile"] = Encoder.encode(_mobile);
      requestMap["address"] = Encoder.encode(_address);
      requestMap["plan_id"] = Encoder.encode(planId);
      request(
        networkRequest.registerAgent(requestMap),
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

  void requestUpdateAgent(
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController mobileController,
    TextEditingController addressController,
    String planId,
    String editUserId,
  ) async {
    String _name = nameController.text.trim();
    String _email = emailController.text.trim();
    String _mobile = mobileController.text.trim();
    String _address = addressController.text.trim();
    String _error = _validateUserDetails(_name, _email, _mobile, planId);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["id"] = Encoder.encode(editUserId);
      requestMap["name"] = Encoder.encode(_name);
      requestMap["email"] = Encoder.encode(_email);
      requestMap["mobile"] = Encoder.encode(_mobile);
      requestMap["address"] = Encoder.encode(_address);
      requestMap["plan_id"] = Encoder.encode(planId);
      request(
        networkRequest.updateAgent(requestMap),
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
    String email,
    String mobile,
    String planId,
  ) {
    if (planId.isEmpty)
      return "Please Choose Plan";
    else if (name.isEmpty)
      return "Please Enter Name";
    else if (email.isEmpty)
      return "Please Enter Email";
    else if (mobile.isEmpty)
      return "Please Enter Mobile Number";
    else
      return "";
  }

  void requestPlansList({String mPlanType = "1"}) {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["is_agent"] = Encoder.encode(mPlanType);
    request(
      networkRequest.getPlansList(requestMap),
      (map) {
        MemberPlansResponseModel dataModel = MemberPlansResponseModel();
        dataModel.parseData(map);
        _ranksPlanStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.BANNER,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
