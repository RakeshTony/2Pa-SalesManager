import 'package:twopa_sales_manager/BaseClasses/base_data_model.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';

class MemberPlansResponseModel extends BaseDataModel {
  List<PlansData> data = [];
  @override
  MemberPlansResponseModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => PlansData.fromJson(e)).toList();
    return this;
  }
}

class PlansData {
  String id;
  String name;
  String code;
  bool isAgent;
  bool status;
  String minTransferAmount;
  String maxTransferAmount;

  PlansData({
    this.id = "",
    this.name = "",
    this.code = "",
    this.isAgent = false,
    this.status = false,
    this.minTransferAmount = "",
    this.maxTransferAmount = "",
  });

  factory PlansData.fromJson(Map<String, dynamic> json) {

    return PlansData(
      id: toString(json["id"]),
      name: toString(json["name"]),
      code: toString(json["code"]),
      isAgent: toBoolean(json["is_agent"]),
      status: toBoolean(json["status"]),
      minTransferAmount: toString(json["min_transfer_amount"]),
      maxTransferAmount: toString(json["max_transfer_amount"]),
    );
  }
}