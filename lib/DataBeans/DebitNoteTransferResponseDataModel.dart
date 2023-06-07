import 'package:twopa_sales_manager/BaseClasses/base_data_model.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_request_key.dart';

class DebitNoteTransferResponseDataModel extends BaseDataModel {
  DebitNoteTransferDataModel data = DebitNoteTransferDataModel();

  @override
  DebitNoteTransferResponseDataModel parseData(result) {
    this.statusCode = toInt(result[AppRequestKey.RESPONSE_CODE]);
    this.status = toBoolean(result[AppRequestKey.RESPONSE]);
    this.message = toString(result[AppRequestKey.RESPONSE_MSG]);
    this.data = DebitNoteTransferDataModel.fromJson(
        toMap(result[AppRequestKey.RESPONSE_DATA]));
    return this;
  }
}

class DebitNoteTransferDataModel {
  String txnId;
  String amount;

  DebitNoteTransferDataModel({
    this.txnId = "",
    this.amount = "",
  });

  factory DebitNoteTransferDataModel.fromJson(Map<String, dynamic> json) {
    return DebitNoteTransferDataModel(
        txnId: toString(json["TXN_ID"]), amount: toString(json["AMOUNT"]));
  }
}
