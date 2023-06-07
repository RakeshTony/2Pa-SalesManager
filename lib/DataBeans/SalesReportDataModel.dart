import 'package:twopa_sales_manager/BaseClasses/base_data_model.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';

class SalesReportDataModel extends BaseDataModel {
  SalesReportData report = SalesReportData();

  @override
  SalesReportDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.report =
        SalesReportData.fromJson(toMap(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class SalesReportData {
  String totalAmount;
  String totalQuantity;
  List<SalesReportProductData> productData;

  SalesReportData({
    this.totalAmount = "",
    this.totalQuantity = "",
    this.productData = const [],
  });

  factory SalesReportData.fromJson(Map<String, dynamic> json) {
    return SalesReportData(
      totalAmount: toString(json['TOTAL_AMOUNT']),
      totalQuantity: toString(json['TOTAL_QUANTITY']),
      productData: toList(json['PRODUCT_DATA'])
          .map((e) => SalesReportProductData.fromJson(e))
          .toList(),
    );
  }
}

class SalesReportProductData {
  String amount;
  String title;
  String quantity;

  SalesReportProductData({
    this.amount = "",
    this.title = "",
    this.quantity = "",
  });

  factory SalesReportProductData.fromJson(Map<String, dynamic> json) {
    return SalesReportProductData(
      amount: toString(json['amount']),
      title: toString(json['title']),
      quantity: toString(json['quantity']),
    );
  }
}
