import 'dart:async';
import 'dart:collection';

import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/EarningReportsResponseDataModel.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/my_user.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';

import '../../../DataBeans/MyUserResponseDataModel.dart';

class ViewModelEarningReport extends BaseViewModel {
  final StreamController<EarningReportsResponseModel>
      _responseStreamController = StreamController();

  Stream<EarningReportsResponseModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<MyUserDataModel>> _usersStreamController =
      StreamController();

  Stream<List<MyUserDataModel>> get userStream => _usersStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    _usersStreamController.close();
    super.disposeStream();
  }

  void requestEarningReports(String userId, String fromDate, String toDate) {
    var requestData = HashMap<String, dynamic>();
    requestData["user_id"] = Encoder.encode(userId);
    requestData["from_date_time"] = Encoder.encode(fromDate);
    requestData["to_date_time"] = Encoder.encode(toDate);
    request(
      networkRequest.getEarningReports(requestData),
      (map) {
        EarningReportsResponseDataModel dataModel =
            EarningReportsResponseDataModel();
        dataModel.parseData(map);
        _responseStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestMyUser() {
    request(
      networkRequest.getMyUsers(),
      (map) async {
        MyUserResponseDataModel dataModel = MyUserResponseDataModel();
        dataModel.parseData(map);
        final box = HiveBoxes.getMyUsers();
        await box.clear();
        var users = dataModel.users.map((element) {
          return element.toMyUser;
        }).toList();
        box.addAll(users);
        _usersStreamController.sink.add(dataModel.users);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
