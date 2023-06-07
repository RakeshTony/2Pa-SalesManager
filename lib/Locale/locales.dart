import 'dart:async';


import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

import 'Languages/arabic.dart';
import 'Languages/english.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': english(),
    'ar': arabic(),
  };

  String? get changeLanguage {
    return _localizedValues[locale.languageCode]!['changeLanguage'];
  }

  String? get signIn {
    return _localizedValues[locale.languageCode]!['signIn'];
  }

  String? get password {
    return _localizedValues[locale.languageCode]!['password'];
  }

  String? get mobileNumber {
    return _localizedValues[locale.languageCode]!['mobileNumber'];
  }

  String? get forgotPassword {
    return _localizedValues[locale.languageCode]!['forgotPassword'];
  }
  String? get yourWalletBalance {
    return _localizedValues[locale.languageCode]!['yourWalletBalance'];
  }
  String? get creditTransfer {
    return _localizedValues[locale.languageCode]!['creditTransfer'];
  }
  String? get creditCollection {
    return _localizedValues[locale.languageCode]!['creditCollection'];
  }
  String? get myCustomer {
    return _localizedValues[locale.languageCode]!['myCustomer'];
  }
  String? get summaryReport {
    return _localizedValues[locale.languageCode]!['summaryReport'];
  }
  String? get hiWelcome {
    return _localizedValues[locale.languageCode]!['hiWelcome'];
  }
  String? get myDue {
    return _localizedValues[locale.languageCode]!['myDue'];
  }
  String? get customerDue {
    return _localizedValues[locale.languageCode]!['customerDue'];
  }
  String? get profile {
    return _localizedValues[locale.languageCode]!['profile'];
  }
  String? get language {
    return _localizedValues[locale.languageCode]!['language'];
  }
  String? get changePassword {
    return _localizedValues[locale.languageCode]!['changePassword'];
  }
  String? get logout {
    return _localizedValues[locale.languageCode]!['logout'];
  }
  String? get submit {
    return _localizedValues[locale.languageCode]!['submit'];
  }
  String? get oldPassword {
    return _localizedValues[locale.languageCode]!['oldPassword'];
  }

  String? get newPassword {
    return _localizedValues[locale.languageCode]!['newPassword'];
  }
  String? get confirmPassword {
    return _localizedValues[locale.languageCode]!['confirmPassword'];
  }
  String? get loggingOut {
    return _localizedValues[locale.languageCode]!['loggingOut'];
  }

  String? get areYouSure {
    return _localizedValues[locale.languageCode]!['areYouSure'];
  }

  String? get no {
    return _localizedValues[locale.languageCode]!['no'];
  }

  String? get yes {
    return _localizedValues[locale.languageCode]!['yes'];
  }
  String? get newStr {
    return _localizedValues[locale.languageCode]!['newStr'];
  }
  String? get collected {
    return _localizedValues[locale.languageCode]!['collected'];
  }
  String? get searchCustomer {
    return _localizedValues[locale.languageCode]!['searchCustomer'];
  }
  String? get balance {
    return _localizedValues[locale.languageCode]!['balance'];
  }
  String? get availableLimit {
    return _localizedValues[locale.languageCode]!['availableLimit'];
  }
  String? get due {
    return _localizedValues[locale.languageCode]!['due'];
  }
  String? get from {
    return _localizedValues[locale.languageCode]!['from'];
  }
  String? get to {
    return _localizedValues[locale.languageCode]!['to'];
  }
  String? get search {
    return _localizedValues[locale.languageCode]!['search'];
  }
  String? get reportFor {
    return _localizedValues[locale.languageCode]!['reportFor'];
  }
  String? get totalCollection {
    return _localizedValues[locale.languageCode]!['totalCollection'];
  }
  String? get amount {
    return _localizedValues[locale.languageCode]!['amount'];
  }
  String? get date {
    return _localizedValues[locale.languageCode]!['date'];
  }
  String? get customer {
    return _localizedValues[locale.languageCode]!['customer'];
  }
  String? get searchByName {
    return _localizedValues[locale.languageCode]!['searchByName'];
  }
  String? get outgoing {
    return _localizedValues[locale.languageCode]!['outgoing'];
  }
  String? get incoming {
    return _localizedValues[locale.languageCode]!['incoming'];
  }
  String? get totalOutgoing {
    return _localizedValues[locale.languageCode]!['totalOutgoing'];
  }

  String? get totalIncoming {
    return _localizedValues[locale.languageCode]!['totalIncoming'];
  }

  String? get walletTransaction {
    return _localizedValues[locale.languageCode]!['walletTransaction'];
  }
  String? get earningsReport {
    return _localizedValues[locale.languageCode]!['earningsReport'];
  }
  String? get salesReport {
    return _localizedValues[locale.languageCode]!['salesReport'];
  }
  String? get totalEarnings {
    return _localizedValues[locale.languageCode]!['totalEarnings'];
  }
  String? get products {
    return _localizedValues[locale.languageCode]!['products'];
  }
  String? get quantity {
    return _localizedValues[locale.languageCode]!['quantity'];
  }
  String? get amountCaps {
    return _localizedValues[locale.languageCode]!['amountCaps'];
  }
  String? get addNewCustomer {
    return _localizedValues[locale.languageCode]!['addNewCustomer'];
  }
  String? get editCustomer {
    return _localizedValues[locale.languageCode]!['editCustomer'];
  }
  String? get addCustomer {
    return _localizedValues[locale.languageCode]!['addCustomer'];
  }
  String? get name {
    return _localizedValues[locale.languageCode]!['name'];
  }
  String? get email {
    return _localizedValues[locale.languageCode]!['email'];
  }
  String? get address {
    return _localizedValues[locale.languageCode]!['address'];
  }
  String? get creditAmountTransfer {
    return _localizedValues[locale.languageCode]!['creditAmountTransfer'];
  }
  String? get customerWallet {
    return _localizedValues[locale.languageCode]!['customerWallet'];
  }
  String? get balanceDue {
    return _localizedValues[locale.languageCode]!['balanceDue'];
  }
  String? get enterAmount {
    return _localizedValues[locale.languageCode]!['enterAmount'];
  }
  String? get reEnterAmount {
    return _localizedValues[locale.languageCode]!['reEnterAmount'];
  }
  String? get transfer {
    return _localizedValues[locale.languageCode]!['transfer'];
  }
  String? get collectCredit {
    return _localizedValues[locale.languageCode]!['collectCredit'];
  }
  String? get collect {
    return _localizedValues[locale.languageCode]!['collect'];
  }
  String? get cancel {
    return _localizedValues[locale.languageCode]!['cancel'];
  }
  String? get enterMPin {
    return _localizedValues[locale.languageCode]!['enterMPin'];
  }

  String? get invalidMPin {
    return _localizedValues[locale.languageCode]!['invalidMPin'];
  }
  String? get continue_ {
    return _localizedValues[locale.languageCode]!['continue_'];
  }
  String? get reset {
    return _localizedValues[locale.languageCode]!['reset'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
