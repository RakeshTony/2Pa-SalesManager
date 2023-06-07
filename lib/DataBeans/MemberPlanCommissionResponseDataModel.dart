import 'dart:convert';

import 'package:twopa_sales_manager/BaseClasses/base_data_model.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';

class MemberPlanCommissionResponseDataModel extends BaseDataModel {
  MemberPlanOperatorDataModel data = MemberPlanOperatorDataModel();

  @override
  MemberPlanCommissionResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    data = MemberPlanOperatorDataModel.fromJson(
        toMap(result[AppRequestKey.RESPONSE_DATA]));
    // this.data = list.map((e) => DefaultBank.fromJson(e)).toList();
    return this;
  }
}

class MemberPlanOperatorDataModel {
  List<MemberPlanCommissionDataModel> operators;

  MemberPlanOperatorDataModel({
    this.operators = const [],
  });

  factory MemberPlanOperatorDataModel.fromJson(Map<String, dynamic> json) {
    return MemberPlanOperatorDataModel(
      operators: toList(json["Operators"])
          .map((e) => MemberPlanCommissionDataModel.fromJson(e))
          .toList(),
    );
  }
}

class MemberPlanCommissionDataModel {
  String operatorId;
  String operatorTitle;
  String operatorLogo;
  double myCommission;
  double commission;
  bool status;
  List<MemberPlanDenominationModel> denominations;

  MemberPlanCommissionDataModel({
    this.operatorId = "",
    this.operatorTitle = "",
    this.operatorLogo = "",
    this.myCommission = 0.0,
    this.commission = 0.0,
    this.status = false,
    this.denominations = const [],
  });

  factory MemberPlanCommissionDataModel.fromJson(Map<String, dynamic> json) {
    return MemberPlanCommissionDataModel(
      operatorId: toString(json["operator_id"]),
      operatorTitle: toString(json["operator_title"]),
      operatorLogo: toString(json["operator_logo"]),
      myCommission: toDouble(json["my_commission"]),
      commission: toDouble(json["commission"]),
      status: toBoolean(json["status"]),
      denominations: toList(json["Denominations"])
          .map((e) => MemberPlanDenominationModel.fromJson(e))
          .toList(),
    );
  }
}

class MemberPlanDenominationModel {
  String id;
  String denomination;
  String title;
  String sellingPrice;
  String currencyId;
  String currencyCode;
  String operatorId;
  double maxCommission;
  double commission;
  double myCommission;
  bool status;

  MemberPlanDenominationModel({
    this.id = "",
    this.denomination = "",
    this.title = "",
    this.sellingPrice = "",
    this.currencyId = "",
    this.currencyCode = "",
    this.operatorId = "",
    this.maxCommission = 0.0,
    this.commission = 0.0,
    this.myCommission = 0.0,
    this.status = false,
  });

  factory MemberPlanDenominationModel.fromJson(Map<String, dynamic> json) {
    return MemberPlanDenominationModel(
      id: toString(json["id"]),
      denomination: toString(json["denomination"]),
      title: toString(json["title"]),
      sellingPrice: toString(json["selling_price"]),
      currencyId: toString(json["currency_id"]),
      currencyCode: toString(json["Currency"]["Code"]),
      operatorId: toString(json["operator_id"]),
      maxCommission: toDouble(json["max_commission"]),
      commission: toDouble(json["commission"]),
      status: toBoolean(json["status"]),
      myCommission: toDouble(json["my_commission"]),
    );
  }
}
