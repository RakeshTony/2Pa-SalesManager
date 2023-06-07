import 'dart:async';

import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';

class ViewModelReportsSummary extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    super.disposeStream();
  }
}
