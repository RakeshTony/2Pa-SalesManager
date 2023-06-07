import 'package:twopa_sales_manager/BaseClasses/base_data_model.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';

class CreditResponseDataModel extends BaseDataModel {
  CreditResponseModel data = CreditResponseModel();

  @override
  CreditResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = CreditResponseModel.fromJson(
        toMap(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class CreditResponseModel {
  List<CreditDataModel> data;
  double total;

  CreditResponseModel({
    this.data = const [],
    this.total = 0.0,
  });

  factory CreditResponseModel.fromJson(Map<String, dynamic> json) {
    return CreditResponseModel(
      data:
          toList(json["data"]).map((e) => CreditDataModel.fromJson(e)).toList(),
      total: toDouble(json["total"]),
    );
  }
}

class CreditDataModel {
  String type;
  String username;
  String name;
  String date;
  double amount;

  CreditDataModel({
    this.type = "",
    this.username = "",
    this.name = "",
    this.date = "",
    this.amount = 0.0,
  });

  factory CreditDataModel.fromJson(Map<String, dynamic> json) {
    return CreditDataModel(
      type: toString(json["Type"]),
      username: toString(json["Username"]),
      name: toString(json["Name"]),
      date: toString(json["DATE"]),
      amount: toDouble(json["AMOUNT"]),
    );
  }
}
