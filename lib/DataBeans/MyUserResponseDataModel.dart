import 'package:twopa_sales_manager/BaseClasses/base_data_model.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';

class MyUserResponseDataModel extends BaseDataModel {
  List<MyUserDataModel> users = [];

  @override
  MyUserResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.users = toList(result[AppRequestKey.RESPONSE_DATA])
        .map((e) => MyUserDataModel.fromJson(e))
        .toList();
    return this;
  }
}

class MyUserDataModel {
  String id;
  String username;
  String walletId;
  String name;
  String mobile;
  String address;
  String email;
  String planId;
  String firmName;
  bool status;
  double totalCredits;
  double totalBalance;
  String icon;
  double RESPONSE_MAX_CREDIT_LIMIT;
  double RESPONSE_AVAILABLE_CREDIT_LIMIT;

  MyUserDataModel({
    this.id = "",
    this.username = "",
    this.walletId = "",
    this.name = "",
    this.mobile = "",
    this.address = "",
    this.email = "",
    this.planId = "",
    this.firmName = "",
    this.status = false,
    this.totalCredits = 0.0,
    this.totalBalance = 0.0,
    this.icon = "",
    this.RESPONSE_MAX_CREDIT_LIMIT = 0.0,
    this.RESPONSE_AVAILABLE_CREDIT_LIMIT = 0.0,
  });

  factory MyUserDataModel.fromJson(Map<String, dynamic> json) {
    return MyUserDataModel(
      id: toString(json["id"]),
      username: toString(json["username"]),
      walletId: toString(json["wallet_id"]),
      name: toString(json["name"]),
      mobile: toString(json["mobile"]),
      address: toString(json["address"]),
      email: toString(json["email"]),
      planId: toString(json["plan_id"]),
      firmName: toString(json["firm_name"]),
      status: toBoolean(json["status"]),
      totalCredits: toDouble(json["total_credits"]),
      totalBalance: toDouble(json["total_balance"]),
      icon: toString(json["icon"]),
      RESPONSE_MAX_CREDIT_LIMIT: toDouble(json["RESPONSE_MAX_CREDIT_LIMIT"]),
      RESPONSE_AVAILABLE_CREDIT_LIMIT: toDouble(json["RESPONSE_AVAILABLE_CREDIT_LIMIT"]),
    );
  }
}
