import 'dart:async';
import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/CommissionResponseDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';

class ViewModelNotification extends BaseViewModel {
  final StreamController<List<CommissionOperatorData>>
      _commissionStreamController = StreamController();

  Stream<List<CommissionOperatorData>> get commissionStream =>
      _commissionStreamController.stream;

  @override
  void disposeStream() {
    _commissionStreamController.close();
    super.disposeStream();
  }

  void requestCommission() {
    request(
      networkRequest.getCommissionReport(),
      (map) {
        CommissionResponseDataModel dataModel = CommissionResponseDataModel();
        dataModel.parseData(map);
        _commissionStreamController.sink.add(dataModel.operators);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
