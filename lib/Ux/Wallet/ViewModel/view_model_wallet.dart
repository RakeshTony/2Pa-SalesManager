import 'dart:async';
import 'dart:collection';

import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/BalanceDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/my_user.dart';
import 'package:twopa_sales_manager/Database/models/recent_transaction.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';
import 'package:twopa_sales_manager/Utils/app_settings.dart';

import '../../../DataBeans/MyUserResponseDataModel.dart';

class ViewModelWallet extends BaseViewModel {
  final StreamController<List<WalletStatementDataModel>>
      _responseStreamController = StreamController();

  Stream<List<WalletStatementDataModel>> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<MyUserDataModel>> _usersStreamController = StreamController();
  Stream<List<MyUserDataModel>> get userStream => _usersStreamController.stream;

  @override
  void disposeStream() {
    _responseStreamController.close();
    _usersStreamController.close();
    super.disposeStream();
  }

  void requestBalanceEnquiry() async {
    final box = HiveBoxes.getBalance();
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["app_version"] = Encoder.encode(AppSettings.APP_VERSION);
    await request(
      networkRequest.getBalanceEnquiry(requestMap),
      (map) {
        BalanceDataModel dataModel = BalanceDataModel();
        dataModel.parseData(map);
        box.put("BAL", dataModel.balance.toBalance);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestWallet(String uId,String fromDate,String toDate,String type) {
    var requestData = HashMap<String, dynamic>();
    requestData["consider_as"] = ""; // Cr  Dr
    requestData["user_id"] = uId==""?"":Encoder.encode(uId);
    requestData["from_date_time"] = fromDate==""?"":Encoder.encode(fromDate + " 00:00:00");
    requestData["to_date_time"] = toDate==""?"":Encoder.encode(toDate + " 00:00:00");
    requestData["type"] = Encoder.encode(type); // recharge , transfer ,  etc.
    requestData["offset"] = 0;
    request(
      networkRequest.getWalletStatements(requestData),
      (map) {
        WalletStatementResponseDataModel dataModel =
            WalletStatementResponseDataModel();
        dataModel.parseData(map);
        var data = dataModel.statements.map((e) => e.toTransaction).toList();
       /* box.addAll(data);*/
        _responseStreamController.sink.add(dataModel.statements);
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
