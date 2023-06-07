import 'package:twopa_sales_manager/BaseClasses/base_data_model.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';

class SalesOperatorDataModel extends BaseDataModel {
  List<SalesOperatorData> data = [];
  @override
  SalesOperatorDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = toList(result[AppRequestKey.RESPONSE_DATA]).map((e) => SalesOperatorData.fromJson(e)).toList();
    return this;
  }
}

class SalesOperatorData {
  String id;
  String title;

  SalesOperatorData({
    this.id = "",
    this.title = "",
  });

  factory SalesOperatorData.fromJson(Map<String, dynamic> json) {
    return SalesOperatorData(
      id: toString(json['id']),
      title: toString(json['title']),
    );
  }
}
