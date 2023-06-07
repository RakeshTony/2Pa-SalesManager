import 'dart:async';
import 'dart:collection';

import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/DataBeans/CreditResponseDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/DebitNoteTransferResponseDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/MyUserResponseDataModel.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/my_user.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_error_type.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_request_type.dart';
import 'package:twopa_sales_manager/Utils/app_encoder.dart';

class ViewModelCreditTransfer extends BaseViewModel {
  final StreamController<List<MyUserDataModel>> _usersStreamController =
      StreamController();

  Stream<List<MyUserDataModel>> get userStream => _usersStreamController.stream;

  final StreamController<CreditResponseModel> _creditStreamController =
      StreamController();

  Stream<CreditResponseModel> get creditStream =>
      _creditStreamController.stream;

  final StreamController<DebitNoteTransferResponseDataModel>
      _debitNoteTransferStreamController = StreamController();

  Stream<DebitNoteTransferResponseDataModel> get debitNoteTransferStream =>
      _debitNoteTransferStreamController.stream;

  @override
  void disposeStream() {
    _usersStreamController.close();
    _creditStreamController.close();
    _debitNoteTransferStreamController.close();
    super.disposeStream();
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

  void requestDebitNote(String amount, String walletId) {
    HashMap<String, dynamic> requestData = HashMap<String, dynamic>();
    requestData["amount"] = Encoder.encode(amount);
    requestData["wallet_id"] = Encoder.encode(walletId);
    request(
      networkRequest.getDebitNote(requestData),
      (map) async {
        DebitNoteTransferResponseDataModel dataModel =
            DebitNoteTransferResponseDataModel();
        dataModel.parseData(map);
        _debitNoteTransferStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestTransfer(String amount, String walletId) {
    HashMap<String, dynamic> requestData = HashMap<String, dynamic>();
    requestData["amount"] = Encoder.encode(amount);
    requestData["wallet_id"] = Encoder.encode(walletId);
    requestData["is_credit"] = Encoder.encode("1");
    request(
      networkRequest.getTransfer(requestData),
      (map) async {
        DebitNoteTransferResponseDataModel dataModel =
            DebitNoteTransferResponseDataModel();
        dataModel.parseData(map);
        _debitNoteTransferStreamController.sink.add(dataModel);
      },
      errorType: ErrorType.POPUP,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestCreditOutgoing(
      String userId, String fromDateTime, String toDateTime) {
    HashMap<String, dynamic> requestData = HashMap<String, dynamic>();
    requestData["user_id"] = Encoder.encode(userId);
    requestData["from_date_time"] = Encoder.encode(fromDateTime);
    requestData["to_date_time"] = Encoder.encode(toDateTime);

    _creditStreamController.sink.add(CreditResponseModel());

    request(
      networkRequest.getCreditOutgoing(requestData),
      (map) async {
        CreditResponseDataModel dataModel = CreditResponseDataModel();
        dataModel.parseData(map);
        _creditStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.BANNER,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestCreditIncoming(String fromDateTime, String toDateTime) {
    HashMap<String, dynamic> requestData = HashMap<String, dynamic>();
    requestData["from_date_time"] = Encoder.encode(fromDateTime);
    requestData["to_date_time"] = Encoder.encode(toDateTime);

    _creditStreamController.sink.add(CreditResponseModel());
    request(
      networkRequest.getCreditIncoming(requestData),
      (map) async {
        CreditResponseDataModel dataModel = CreditResponseDataModel();
        dataModel.parseData(map);
        _creditStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.NONE,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }
}
