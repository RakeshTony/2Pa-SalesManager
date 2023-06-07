import 'dart:async';
import 'dart:collection';

import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/DefaultDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';

import '../../../Utils/app_encoder.dart';

class ViewModelHome extends BaseViewModel {
  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    super.disposeStream();
  }

  void requestLogout() {
    HashMap<String, dynamic> requestMap = HashMap();
    request(
      networkRequest.logout(requestMap),
      (map) {
        DefaultDataModel dataModel = DefaultDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
  void requestProfileUpdate(String languageId) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["language_id"] = Encoder.encode(languageId);
    request(
      networkRequest.languageUpdate(requestMap),
          (map) {
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NONE,
    );
  }
}
