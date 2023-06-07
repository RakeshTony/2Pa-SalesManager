import 'dart:async';
import 'dart:collection';

import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/MemberPlanCommissionResponseDataModel.dart';

import '../../../DataBeans/DefaultDataModel.dart';
import '../../../DataBeans/UserRanksPlansDataModel.dart';
import '../../../Utils/Enum/enum_error_type.dart';
import '../../../Utils/Enum/enum_request_type.dart';
import '../../../Utils/app_encoder.dart';

class ViewModelMemberShipPlan extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<List<PlansData>> _planStreamController =
      StreamController();

  Stream<List<PlansData>> get plansStream => _planStreamController.stream;
  final StreamController<MemberPlanOperatorDataModel>
      _commissionStreamController = StreamController();

  Stream<MemberPlanOperatorDataModel> get commissionStream =>
      _commissionStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _planStreamController.close();
    _commissionStreamController.close();
    super.disposeStream();
  }

  void requestPlansList() {
    HashMap<String, dynamic> requestMap = HashMap();
    request(
      networkRequest.getPlansList(requestMap),
      (map) {
        MemberPlansResponseModel dataModel = MemberPlansResponseModel();
        dataModel.parseData(map);
        _planStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.BANNER,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestPlansDetails(String planId) {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["plan_id"] = Encoder.encode(planId);
    request(
      networkRequest.getPlansDetails(requestMap),
      (map) {
        MemberPlanCommissionResponseDataModel dataModel =
            MemberPlanCommissionResponseDataModel();
        dataModel.parseData(map);
        _commissionStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.BANNER,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void savePlanCommission(String planId,String operatorsJson,String denominationJson) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["plan_id"] = Encoder.encode(planId);
    requestMap["operators"] = Encoder.encode(operatorsJson);
    requestMap["denominations"] = Encoder.encode(denominationJson);
    request(
      networkRequest.savePlanCommission(requestMap),
      (map) {
        DefaultDataModel dataModel = DefaultDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestUpdatePlans(String requestJsonData) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["data"] = Encoder.encode(requestJsonData);
    request(
      networkRequest.managePlans(requestMap),
      (map) {
        DefaultDataModel dataModel = DefaultDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
