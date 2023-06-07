import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twopa_sales_manager/DataBeans/UserRanksPlansDataModel.dart';
import 'package:twopa_sales_manager/Ux/Agent/add_agent_page.dart';
import 'package:twopa_sales_manager/Ux/Agent/agent_page.dart';
import 'package:twopa_sales_manager/Ux/Authentication/ForgotPassword/forgot_password_page.dart';
import 'package:twopa_sales_manager/Ux/Authentication/Login/login_page.dart';
import 'package:twopa_sales_manager/Ux/Authentication/Verification/verification_page.dart';
import 'package:twopa_sales_manager/Ux/Customer/customer_add_page.dart';
import 'package:twopa_sales_manager/Ux/Home/home_agent_page.dart';
import 'package:twopa_sales_manager/Ux/Home/home_sales_manager_page.dart';
import 'package:twopa_sales_manager/Ux/MemberShipPlan/add_plan_page.dart';
import 'package:twopa_sales_manager/Ux/Setting/enter_pin_page.dart';
import 'package:twopa_sales_manager/Ux/Setting/set_pin_page.dart';
import 'package:twopa_sales_manager/Ux/Customer/customers_page.dart';
import 'package:twopa_sales_manager/Ux/MemberShipPlan/member_ship_plan_commission_page.dart';
import 'package:twopa_sales_manager/Ux/MemberShipPlan/member_ship_plan_page.dart';
import 'package:twopa_sales_manager/Ux/Notification/notification_page.dart';
import 'package:twopa_sales_manager/Ux/Others/change_language_page.dart';
import 'package:twopa_sales_manager/Ux/Others/page_not_found.dart';
import 'package:twopa_sales_manager/Ux/Others/splash.dart';
import 'package:twopa_sales_manager/Ux/Profile/profile_page.dart';
import 'package:twopa_sales_manager/Ux/Reports/earnings_reports_page.dart';
import 'package:twopa_sales_manager/Ux/Reports/reports_page.dart';
import 'package:twopa_sales_manager/Ux/Reports/sales_reports_page.dart';
import 'package:twopa_sales_manager/Ux/Setting/change_password_page.dart';
import 'package:twopa_sales_manager/Ux/Wallet/wallet_transaction_page.dart';
import 'package:twopa_sales_manager/main.dart';

import '../DataBeans/MyUserResponseDataModel.dart';
import '../Ux/CashCollection/cash_collection.dart';
import '../Ux/CreditTransfer/credit_transfer.dart';

class PageRoutes {
  PageRoutes._();

  static const String languagePage = '/language_page';
  static const String sync = '/sync';
  static const String signInNavigator = '/signInNavigator';
  static const String home = '/home';
  static const String operator = '/operator';
  static const String services = '/services';

  static const String mobileData = '/mobileData/page';
  static const String mobile = '/mobile/page';
  static const String data = '/data/page';
  static const String electricity = '/electricity/page';
  static const String cableTv = '/cableTv/page';

  static const String topUpPage = '/topUp/page';
  static const String topUpOperator = '/topUp/operator';
  static const String topUpCheckOut = '/topUp/operator/browsePlans/checkOut';

  static const String rechargeStatus = '/recharge/status';
  static const String reprintPage = 'transaction/reprint';
  static const String settings = '/settings';
  static const String helpAndSupport = '/helpAndSupport';
  static const String setPin = '/settings/setPin';
  static const String redeemVoucher = '/voucher/redeemVoucher';
  static const String notificationPage = '/notification/notificationPage';
  static const String aboutUs = '/settings/aboutUs';
  static const String transactions = '/transactions';
  static const String creditTransfer = '/creditTransfer';
  static const String cashCollection = '/cashCollection';
  static const String memberShipPlan = '/memberShipPlan';
  static const String memberShipPlanCommission = '/memberShipPlanCommission';
  static const String memberShipPlanAddEdit = '/memberShipPlanAddEdit';
  static const String myAgents = '/myAgents';
  static const String reports = '/reports';
  static const String reportsEarning = '/reportsEarning';
  static const String reportsSales = '/reportsSales';
  static const String walletTransaction = '/walletTransaction';

  static const String commissionReport = '/transactions/commissionReport';
  static const String preFundDeposit = '/transactions/preFundDeposit';
  static const String salesReport = '/transactions/salesReport';
  static const String salesFilter = '/transactions/salesReport/salesFilter';
  static const String walletRequestFilter =
      '/payments/walletRequest/walletRequestFilter';
  static const String customRange = '/transactions/customRange';
  static const String myTransaction = '/transactions/customRange/myTransaction';
  static const String profile = '/profile';
  static const String kyc = '/kyc';
  static const String wallet = '/wallet';
  static const String walletTopUp = '/wallet/topUp';
  static const String scanPay = '/scanPay';
  static const String fundRequestReport = '/scanPay/fundRequestReport';
  static const String fundTransfer = '/scanPay/fundTransfer';
  static const String payNow = '/scanPay/payNow';
  static const String addBank = '/scanPay/addBank';
  static const String addMyBankAccount = '/scanPay/myBank';
  static const String addBeneficiary = '/scanPay/addBeneficiary';
  static const String transferMoney = '/scanPay/transferMoney';
  static const String transferBankCardPage = '/scanPay/static const String';

  static const String enterPin = '/scanPay/payNow/enterPin';
  static const String agentAddEdit = '/agent/addAgent';
  static const String customerAddEdit = '/customer/addEdit';
  static const String customers = '/customers/page';
  static const String customersList = '/customers/page';

  static const String splash = '/splash';
  static const String login = '/login';
  static const String verification = '/login/verification';
  static const String forgotPassword = '/login/forgot_password';
  static const String changePassword = '/settings/changePassword';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => Splash());
      case login:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => LoginPage());

      case verification:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (context) =>
                VerificationPage(args as RedirectVerificationModel, () async {
                  // Navigator.popAndPushNamed(context, PageRoutes.sync);
                  if (mPreference.value.mPin.isEmpty) {
                    await Navigator.pushNamed(context, PageRoutes.setPin);
                    if (mPreference.value.mPin.isEmpty)
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    else
                      askPin(context);
                  } else {
                    askPin(context);
                  }
                }));
      case forgotPassword:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ForgotPasswordPage());

      case home:
        {
          if (mPreference.value.groupData.isAgent) {
            // AGENT
            return MaterialPageRoute(
                settings: RouteSettings(name: routeSettings.name),
                builder: (_) => HomeAgentPage());
          } else {
            // SALES MANAGER
            return MaterialPageRoute(
                settings: RouteSettings(name: routeSettings.name),
                builder: (_) => HomeSalesManagerPage());
          }
        }
      case languagePage:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ChangeLanguagePage());
      case customers:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => CustomersPage());
      case agentAddEdit:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => AddAgentPage(args as MyUserDataModel));
      case customerAddEdit:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => CustomerAddPage(args as MyUserDataModel));
      case changePassword:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ChangePasswordPage());
      case setPin:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => SetPinPage());

      case notificationPage:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => NotificationPage());

      case creditTransfer:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => CreditTransferPage());
      case cashCollection:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => CashCollectionPage());

      case myAgents:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => AgentPage());
      case memberShipPlan:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => MemberShipPlanPage());
      case memberShipPlanCommission:
        {
          var data = args as Map<String, dynamic>;
          PlansData plansData = data["planData"] as PlansData;
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => MemberShipPlanCommissionPage(
                    plansData: plansData,
                  ));
        }

      case memberShipPlanAddEdit:
        {
          var data = args as Map<String, dynamic>;
          PlansData plansData = data["planData"] as PlansData;
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => AddPlanPage(
                    plansData: plansData,
                  ));
        }
      case reports:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ReportsPage());
      case reportsEarning:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => EarningReportsPage());
      case reportsSales:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => SalesReportsPage());
      case walletTransaction:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => WalletTransactionPage());

      case salesReport:
        {
          return MaterialPageRoute(
              settings: RouteSettings(name: routeSettings.name),
              builder: (_) => SalesReportsPage());
        }

      case profile:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => ProfilePage());
      case enterPin:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => EnterPinPage());

      default:
        return MaterialPageRoute(
            settings: RouteSettings(name: routeSettings.name),
            builder: (_) => PageNotFound());
    }
  }

  static void askPin(BuildContext context) async {
    var status = await Navigator.pushNamed(context, PageRoutes.enterPin);
    if (status == "SUCCESS") {
      Navigator.pushNamed(context, PageRoutes.home);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}
