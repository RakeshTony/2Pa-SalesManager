import 'package:twopa_sales_manager/Database/models/my_user.dart';
import 'package:hive/hive.dart';
import 'package:twopa_sales_manager/Database/hive_database.dart';
import 'package:twopa_sales_manager/Database/models/app_media.dart';
import 'package:twopa_sales_manager/Database/models/app_pages.dart';
import 'package:twopa_sales_manager/Database/models/balance.dart';
import 'package:twopa_sales_manager/Database/models/countries.dart';
import 'package:twopa_sales_manager/Database/models/currencies.dart';
import 'package:twopa_sales_manager/Database/models/default_config.dart';
import 'package:twopa_sales_manager/Database/models/denomination.dart';
import 'package:twopa_sales_manager/Database/models/operator.dart';
import 'package:twopa_sales_manager/Database/models/push_notification.dart';
import 'package:twopa_sales_manager/Database/models/recent_transaction.dart';
import 'package:twopa_sales_manager/Database/models/service.dart';
import 'package:twopa_sales_manager/Database/models/services_child.dart';

class HiveBoxes {
  HiveBoxes._();

  static Box<Country> getCountries() => Hive.box<Country>(Table.COUNTRIES);

  static Box<ServiceChild> getServicesChild() =>
      Hive.box<ServiceChild>(Table.SERVICE_CHILD);

  static Box<Currency> getCurrencies() => Hive.box<Currency>(Table.CURRENCIES);

  static Box<Balance> getBalance() => Hive.box<Balance>(Table.BALANCE);

  static Balance? getBalanceWallet() => getBalance().get("BAL");

  static Box<Service> getServices() => Hive.box<Service>(Table.SERVICE);

  static Box<Operator> getOperators() => Hive.box<Operator>(Table.OPERATOR);

  static Box<Denomination> getDenomination() =>
      Hive.box<Denomination>(Table.DENOMINATION);

  static Box<RecentTransaction> getRecentTransactions() =>
      Hive.box<RecentTransaction>(Table.RECENT_TRANSACTIONS);

  static Box<AppMedia> getAppMedia() => Hive.box<AppMedia>(Table.APP_MEDIA);

  static Box<DefaultConfig> getDefaultConfig() =>
      Hive.box<DefaultConfig>(Table.DEFAULT_CONFIG);

  static Box<AppPages> getAppPages() => Hive.box<AppPages>(Table.APP_PAGES);

  static Box<PushNotification> getPushNotification() =>
      Hive.box<PushNotification>(Table.PUSH_NOTIFICATION);

  static Box<MyUser> getMyUsers() => Hive.box<MyUser>(Table.MY_USERS);
}
