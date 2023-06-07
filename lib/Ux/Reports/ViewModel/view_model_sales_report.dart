import 'dart:async';
import 'dart:collection';

import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/SalesOperatorDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/SalesReportDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';

class ViewModelSalesReport extends BaseViewModel {
  final StreamController<SalesReportDataModel> _responseStreamController =
      StreamController();

  Stream<SalesReportDataModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<SalesOperatorData>> _operatorsStreamController =
      StreamController();

  Stream<List<SalesOperatorData>> get operatorsStream =>
      _operatorsStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    _operatorsStreamController.close();
    super.disposeStream();
  }

  void requestSalesReport(
      String userId, String fromDate, String toDate, String operatorId) {
    var requestData = HashMap<String, dynamic>();
    requestData["user_id"] = Encoder.encode(userId);
    if (fromDate.isNotEmpty)
      requestData["from_date_time"] = Encoder.encode("$fromDate 00:00:00");
    if (toDate.isNotEmpty)
      requestData["to_date_time"] = Encoder.encode("$toDate 23:59:59");
    requestData["operator_id"] = Encoder.encode(operatorId);
    request(
      networkRequest.getSalesReports(requestData),
      (map) {
        SalesReportDataModel dataModel = SalesReportDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestOperators() {
    request(
      networkRequest.getOperators(),
      (map) {
        SalesOperatorDataModel dataModel = SalesOperatorDataModel();
        dataModel.parseData(map);
        _operatorsStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
