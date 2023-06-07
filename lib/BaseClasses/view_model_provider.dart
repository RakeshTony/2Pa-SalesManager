import 'package:twopa_sales_manager/BaseClasses/base_view_model.dart';
import 'package:twopa_sales_manager/BaseClasses/view_model_common.dart';
import 'package:twopa_sales_manager/Ux/Agent/ViewModel/view_model_add_agent.dart';
import 'package:twopa_sales_manager/Ux/Agent/ViewModel/view_model_agent.dart';
import 'package:twopa_sales_manager/Ux/Authentication/ForgotPassword/ViewModel/view_model_forgot_password.dart';
import 'package:twopa_sales_manager/Ux/Authentication/Login/ViewModel/view_model_login.dart';
import 'package:twopa_sales_manager/Ux/Authentication/Verification/ViewModel/view_model_verification.dart';
import 'package:twopa_sales_manager/Ux/MemberShipPlan/ViewModel/view_model_add_plan.dart';
import 'package:twopa_sales_manager/Ux/Reports/ViewModel/view_model_sales_report.dart';
import 'package:twopa_sales_manager/Ux/Setting/ViewModel/view_model_enter_m_pin.dart';
import 'package:twopa_sales_manager/Ux/Setting/ViewModel/view_model_change_password.dart';
import 'package:twopa_sales_manager/Ux/Setting/ViewModel/view_model_set_m_pin.dart';
import 'package:twopa_sales_manager/Ux/CashCollection/ViewModel/view_model_cash_collection.dart';
import 'package:twopa_sales_manager/Ux/CreditTransfer/ViewModel/view_model_credit_transfer.dart';
import 'package:twopa_sales_manager/Ux/Customer/ViewModel/view_model_customer.dart';
import 'package:twopa_sales_manager/Ux/Home/ViewModel/view_model_home.dart';
import 'package:twopa_sales_manager/Ux/MemberShipPlan/ViewModel/view_model_member_ship_plan.dart';
import 'package:twopa_sales_manager/Ux/Notification/ViewModel/view_model_notification.dart';
import 'package:twopa_sales_manager/Ux/Reports/ViewModel/view_model_earning_report.dart';
import 'package:twopa_sales_manager/Ux/Reports/ViewModel/view_model_reports_summary.dart';
import 'package:twopa_sales_manager/Ux/Profile/ViewModel/view_model_profile.dart';
import 'package:twopa_sales_manager/Ux/Wallet/ViewModel/view_model_wallet.dart';

class ViewModelProvider {
  ViewModelProvider._();

  static final ViewModelProvider _viewModelProvider = ViewModelProvider._();

  static ViewModelProvider instance() => _viewModelProvider;

  V getViewModel<V extends BaseViewModel>() {
    switch (V) {
      case ViewModelCommon:
        return ViewModelCommon() as V;
      case ViewModelLogin:
        return ViewModelLogin() as V;
      case ViewModelCustomers:
        return ViewModelCustomers() as V;
      case ViewModelVerification:
        return ViewModelVerification() as V;
      case ViewModelForgotPassword:
        return ViewModelForgotPassword() as V;
      case ViewModelChangePassword:
        return ViewModelChangePassword() as V;
      case ViewModelNotification:
        return ViewModelNotification() as V;
      case ViewModelHome:
        return ViewModelHome() as V;
      case ViewModelWallet:
        return ViewModelWallet() as V;

      case ViewModelSalesReport:
        return ViewModelSalesReport() as V;

      case ViewModelProfile:
        return ViewModelProfile() as V;

      case ViewModelSetMPin:
        return ViewModelSetMPin() as V;
      case ViewModelEnterMPin:
        return ViewModelEnterMPin() as V;
      case ViewModelCreditTransfer:
        return ViewModelCreditTransfer() as V;
      case ViewModelCashCollection:
        return ViewModelCashCollection() as V;
      case ViewModelReportsSummary:
        return ViewModelReportsSummary() as V;
      case ViewModelMemberShipPlan:
        return ViewModelMemberShipPlan() as V;
      case ViewModelAddAgent:
        return ViewModelAddAgent() as V;
      case ViewModelEarningReport:
        return ViewModelEarningReport() as V;
      case ViewModelAgent:
        return ViewModelAgent() as V;
      case ViewModelAddPlan:
        return ViewModelAddPlan() as V;
      default:
        throw Exception("ViewModel not attach...");
    }
  }
}
