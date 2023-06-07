import 'dart:async';
import 'dart:collection';
import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/MyUserResponseDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';

import '../../../DataBeans/DefaultDataModel.dart';
import '../../../Utils/app_encoder.dart';

class ViewModelAgent extends BaseViewModel {
  final StreamController<List<MyUserDataModel>> _usersStreamController =
  StreamController();

  Stream<List<MyUserDataModel>> get userStream => _usersStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
  StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  @override
  void disposeStream() {
    _usersStreamController.close();
    _responseStreamController.close();
    super.disposeStream();
  }
  void requestAgents(String status) {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["status"] = Encoder.encode(status);
    request(
      networkRequest.getMyAgents(requestMap),
          (map) async {
        MyUserResponseDataModel dataModel = MyUserResponseDataModel();
        dataModel.parseData(map);
        /*final box = HiveBoxes.getMyUsers();
        await box.clear();
        var users = dataModel.users.map((element) {
          return element.toMyUser;
        }).toList();
        box.addAll(users);*/
        _usersStreamController.sink.add(dataModel.users);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestUpdateAgentStatus(
      String status,
      String editUserId,
      ) async {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["id"] = Encoder.encode(editUserId);
    requestMap["status"] = Encoder.encode(status);
    request(
      networkRequest.updateAgentStatus(requestMap),
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
