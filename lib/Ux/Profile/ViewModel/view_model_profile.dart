import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/DefaultDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/LoginDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';
import 'package:twopa_sales_manager/Utils/pair.dart';
import 'package:twopa_sales_manager/Ux/Authentication/Verification/verification_page.dart';
import 'package:twopa_sales_manager/main.dart';
import 'package:path/path.dart';

class ViewModelProfile extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<ProfileDataModel> _responseStreamController =
      StreamController();

  Stream<ProfileDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestProfileUpdate(
      TextEditingController nameController,
      TextEditingController mobileController,
      TextEditingController emailController,
      TextEditingController addressController,
      File? _image) async {
    String _mobile = mobileController.text.trim();
    String _name = nameController.text.trim();
    String _email = emailController.text.trim();
    String _address = addressController.text.trim();
    String _error = _validateUserDetails(_name, _mobile, _email, _address);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["username"] =
          Encoder.encode(mPreference.value.userData.username);
      requestMap["name"] = Encoder.encode(_name);
      requestMap["email"] = Encoder.encode(_email);
      requestMap["mobile"] = Encoder.encode(_mobile);
      requestMap["address"] = Encoder.encode(_address);
      if (_image != null) {
        var fileName = basename(_image.path);
        requestMap["image"] = MultipartFile.fromBytes(_image.readAsBytesSync(),
            filename: fileName);
      }
      request(
        networkRequest.profileUpdate(requestMap),
        (map) {
          ProfileDataModel dataModel = ProfileDataModel();
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
      String name, String mobile, String email, String address) {
    if (name.isEmpty)
      return "Please Enter Name";
    else if (mobile.isEmpty)
      return "Please Enter Mobile";
    else if (email.isEmpty)
      return "Please Enter Email";
    else if (address.isEmpty)
      return "Please Enter Address";
    else
      return "";
  }
}
