import 'package:twopa_sales_manager/BaseClasses/base_data_model.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';

class EarningReportsResponseDataModel extends BaseDataModel {
  EarningReportsResponseModel data = EarningReportsResponseModel();

  @override
  EarningReportsResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = EarningReportsResponseModel.fromJson(
        toMap(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class EarningReportsResponseModel {
  List<EarningReportsDataModel> data;
  double total;

  EarningReportsResponseModel({
    this.data = const [],
    this.total = 0.0,
  });

  factory EarningReportsResponseModel.fromJson(Map<String, dynamic> json) {
    return EarningReportsResponseModel(
      data:
          toList(json["data"]).map((e) => EarningReportsDataModel.fromJson(e)).toList(),
      total: toDouble(json["total"]),
    );
  }
}

class EarningReportsDataModel {
  String operatorTitle;
  String name;
  String logo;
  String productTitle;
  String datetime;
  double cost;
  double selling;
  double profit;

  EarningReportsDataModel({
    this.operatorTitle = "",
    this.name = "",
    this.logo = "",
    this.productTitle = "",
    this.datetime = "",
    this.cost = 0.0,
    this.selling = 0.0,
    this.profit = 0.0,
  });

  factory EarningReportsDataModel.fromJson(Map<String, dynamic> json) {
    return EarningReportsDataModel(
      operatorTitle: toString(json["op_title"]),
      name: toString(json["name"]),
      logo: toString(json["logo"]),
      productTitle: toString(json["product_title"]),
      datetime: toString(json["datetime"]),
      cost: toDouble(json["cost"]),
      selling: toDouble(json["selling"]),
      profit: toDouble(json["profit"]),
    );
  }
}
