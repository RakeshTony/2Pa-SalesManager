import 'dart:async';
import 'dart:collection';

import 'package:twopa_sales_manager/Utils/app_log.dart';
import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/my_user.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';

import '../../../DataBeans/DefaultDataModel.dart';
import '../../../DataBeans/MyUserResponseDataModel.dart';
import '../../../DataBeans/UserRanksPlansDataModel.dart';
import '../../../Utils/app_encoder.dart';

class ViewModelCustomers extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;
  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<MyUserDataModel>> _usersStreamController =
      StreamController();

  Stream<List<MyUserDataModel>> get userStream => _usersStreamController.stream;
  final StreamController<List<PlansData>> _ranksPlanStreamController =
      StreamController();

  Stream<List<PlansData>> get plansStream => _ranksPlanStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _usersStreamController.close();
    _responseStreamController.close();
    _ranksPlanStreamController.close();
    super.disposeStream();
  }

  void requestMyUser() {
    request(
      networkRequest.getMyUsers(),
      (map) async {
        MyUserResponseDataModel dataModel = MyUserResponseDataModel();
        dataModel.parseData(map);
        final box = HiveBoxes.getMyUsers();
        await box.clear();
        var users = dataModel.users.map((element) {
          return element.toMyUser;
        }).toList();
        box.addAll(users);
        _usersStreamController.sink.add(dataModel.users);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestCreateCustomer(
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

  void requestUpdateCustomer(
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

  void requestPlansList({String mPlanType = "0"}) {
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
