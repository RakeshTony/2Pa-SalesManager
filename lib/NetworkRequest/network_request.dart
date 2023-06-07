import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:twopa_sales_manager/NetworkRequest/dio_builder.dart';

class NetworkRequest {
  DioBuilder _dioBuilder = DioBuilder.instance;

  NetworkRequest._();

  static final NetworkRequest _networkRequest = NetworkRequest._();

  static NetworkRequest get instance => _networkRequest;

  /*--------------- DATA  START ---------------*/

  Future<Response> getCountries() =>
      _dioBuilder.dio.post("android_countries_list");

  Future<Response> getStateList(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "android_states_list",
        data: FormData.fromMap(request),
      );

  Future<Response> getCitiesList(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "android_cities_list",
        data: FormData.fromMap(request),
      );

  /*--------------- DATA  END ---------------*/

  /*--------------- AUTHENTICATION START ---------------*/

  Future<Response> loginUser(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "android_login",
        data: FormData.fromMap(request),
      );

  Future<Response> registerUser(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "android_registration",
        data: FormData.fromMap(request),
      );

  Future<Response> registerAgent(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "add_user",
        data: FormData.fromMap(request),
      );

  Future<Response> updateAgent(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "update_user",
        data: FormData.fromMap(request),
      );

  Future<Response> updateAgentStatus(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "change_status",
        data: FormData.fromMap(request),
      );

  Future<Response> forgotPassword(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_forget_password", data: FormData.fromMap(request));

  Future<Response> resetPassword(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_reset_password", data: FormData.fromMap(request));

  Future<Response> changePassword(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_change_password", data: FormData.fromMap(request));

  // Future<Response> logout() => _dioBuilder.dio.post("logout");

  Future<Response> logout(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "logout",
        data: FormData.fromMap(request),
      );

  Future<Response> profileUpdate(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "android_update_profile",
        data: FormData.fromMap(request),
      );

/*--------------- AUTHENTICATION END ---------------*/

/*--------------- CONFIGURATION START ---------------*/
  Future<Response> getCurrencies() =>
      _dioBuilder.dio.post("android_currencies");

  Future<Response> getServices() => _dioBuilder.dio.post("services");

  Future<Response> getServiceOperatorDenomination() =>
      _dioBuilder.dio.post("pos_get_service_operator_denomination");

  Future<Response> getBalanceEnquiry(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("balance_enquiry", data: FormData.fromMap(request));

  Future<Response> getAppMedia() => _dioBuilder.dio.post("android_app_media");

/*--------------- CONFIGURATION END ---------------*/

/*--------------- TOP UP START ---------------*/
  Future<Response> getAutoDetectOperator(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("auto_detect_operator", data: FormData.fromMap(request));

  Future<Response> getParams(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("getparams", data: FormData.fromMap(request));

  Future<Response> doBulkTopUp(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("bulk_topup", data: FormData.fromMap(request));

  /* ------------------  FOR ELECTRICITY -------------------------- */
  Future<Response> doOperatorValidate(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("operator_validate", data: FormData.fromMap(request));

  /* ------------------  FOR CABLE TV -------------------------- */
  Future<Response> doOperatorPlan(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("operator_plans", data: FormData.fromMap(request));

  Future<Response> doOperatorPlanAddons(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("operator_plan_addons", data: FormData.fromMap(request));

/*--------------- TOP UP END ---------------*/
/*--------------- VOUCHER START ---------------*/

  Future<Response> doBulkOrder(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("bulk_order", data: FormData.fromMap(request));

  Future<Response> doRedeemVoucher(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("redeem_voucher", data: FormData.fromMap(request));

/*--------------- TOP UP END ---------------*/

/*--------------- REPORTING START ---------------*/

  Future<Response> getMyUsers() => _dioBuilder.dio.post("get_my_users");

  Future<Response> getMyAgents(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("get_my_agents", data: FormData.fromMap(request));

  Future<Response> getCreditOutgoing(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("credit_outgoing", data: FormData.fromMap(request));

  Future<Response> getCreditIncoming(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("credit_incoming", data: FormData.fromMap(request));

  Future<Response> getDebitNote(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("debitnote", data: FormData.fromMap(request));

  Future<Response> getCollect(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("collect", data: FormData.fromMap(request));

  Future<Response> getCreditCollect(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("credit_collected", data: FormData.fromMap(request));

  Future<Response> getPaymentMade(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("payment_made", data: FormData.fromMap(request));

  Future<Response> getTransfer(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("transfer", data: FormData.fromMap(request));

  Future<Response> getWalletStatements(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("walletstatments", data: FormData.fromMap(request));

  Future<Response> getEarningReports(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("earings_report", data: FormData.fromMap(request));

  Future<Response> getSalesReports(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("closure_report", data: FormData.fromMap(request));

  Future<Response> getOperators() => _dioBuilder.dio.post("get_operators");

  Future<Response> getCommissionReport() =>
      _dioBuilder.dio.post("operator_deno_comissions");

  Future<Response> getAndroidSalesReport(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_closure_report", data: FormData.fromMap(request));

  Future<Response> getLatestTransactions(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("get_latest_transactions", data: FormData.fromMap(request));

  Future<Response> getVoucherSoldReport(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("get_voucher_sold_report", data: FormData.fromMap(request));

  Future<Response> getUserOrders(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_get_user_orders", data: FormData.fromMap(request));

  Future<Response> getFundReceivedSummaryReport(
          HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("credit_statement", data: FormData.fromMap(request));

/*--------------- REPORTING END ---------------*/

/*------------------get user details via qr or mobile number-----------*/
  Future<Response> getUserWalletDetails(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_get_wallet", data: FormData.fromMap(request));

  /* Fund Transfer To User*/
  Future<Response> payNow(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("transfer", data: FormData.fromMap(request));

  /* Make Fund and Credit Request*/

  Future<Response> fundRequest(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_add_fundrequest", data: FormData.fromMap(request));

  Future<Response> fundRequestReport(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_fund_requests", data: FormData.fromMap(request));

  // ------------------------- FOR SYSTEM BANK ---------------------------

  Future<Response> getSystemAdminBanksList() =>
      _dioBuilder.dio.post("android_admin_bankers");

  /*User Banks add Edit and Update*/
  Future<Response> getUserBanksList(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("get_my_bankers", data: FormData.fromMap(request));

  Future<Response> addUserBank(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_add_user_bankers", data: FormData.fromMap(request));

  Future<Response> editUserBanks(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_manage_user_bankers", data: FormData.fromMap(request));

  /*End*/

  /*Default Banks*/
  Future<Response> getBanksList() => _dioBuilder.dio.post("android_bank_list");

  Future<Response> getBanksBranchList(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("android_branch_list", data: FormData.fromMap(request));

  /*End*/

  Future<Response> getMyDownlineUsesList() =>
      _dioBuilder.dio.post("get_my_active_downline");

  Future<Response> getRanksList() =>
      _dioBuilder.dio.post("android_get_down_ranks");

  Future<Response> getPlansByRanksList(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "android_get_planby_ranks",
        data: FormData.fromMap(request),
      );

  Future<Response> getPlansList(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "get_my_plans",
        data: FormData.fromMap(request),
      );

  Future<Response> getPlansDetails(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "get_my_plan_details",
        data: FormData.fromMap(request),
      );

  Future<Response> savePlanCommission(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "save_plan_commission",
        data: FormData.fromMap(request),
      );

  Future<Response> getConfigData() => _dioBuilder.dio.post("config");

  /*Default Banks*/
  Future<Response> addBeneficiary(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("manage_user_beneficiary", data: FormData.fromMap(request));

  Future<Response> bankTransferDirect(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("bankTransferDirect", data: FormData.fromMap(request));

  Future<Response> transferMoney(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("bankTransfer", data: FormData.fromMap(request));

  Future<Response> validateBeneficiary(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("validate_beneficiary", data: FormData.fromMap(request));

  /* Fund Transfer To User*/
  Future<Response> deleteBeneficiary(HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("delete_beneficiary", data: FormData.fromMap(request));

  /*Transaction Reprint*/
  Future<Response> getTransactionReprintData(
          HashMap<String, dynamic> request) =>
      _dioBuilder.dio
          .post("transaction_reprint", data: FormData.fromMap(request));

  /*Mobile Pin*/
  Future<Response> setMPin(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("android_setpin", data: FormData.fromMap(request));

  Future<Response> managePlans(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post("manage_plan", data: FormData.fromMap(request));

  Future<Response> languageUpdate(HashMap<String, dynamic> request) =>
      _dioBuilder.dio.post(
        "android_update_language",
        data: FormData.fromMap(request),
      );

}
