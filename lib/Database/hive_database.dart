import 'dart:io';
import 'package:twopa_sales_manager/Database/models/app_media.dart';
import 'package:twopa_sales_manager/Database/models/app_pages.dart';
import 'package:twopa_sales_manager/Database/models/default_config.dart';
import 'package:twopa_sales_manager/Database/models/my_user.dart';
import 'package:twopa_sales_manager/Database/models/recent_transaction.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:twopa_sales_manager/Database/models/balance.dart';
import 'package:twopa_sales_manager/Database/models/countries.dart';
import 'package:twopa_sales_manager/Database/models/currencies.dart';
import 'package:twopa_sales_manager/Database/models/operator.dart';
import 'package:twopa_sales_manager/Database/models/service.dart';
import 'package:twopa_sales_manager/Database/models/services_child.dart';
import 'models/denomination.dart';
import 'models/push_notification.dart';

// flutter packages pub run build_runner build --delete-conflicting-outputs
class Table {
  static const COUNTRIES = "countries";
  static const CURRENCIES = "currencies";
  static const SERVICE_CHILD = "services_child";
  static const BALANCE = "balance";
  static const OPERATOR = "operator";
  static const SERVICE = "service";
  static const DENOMINATION = "denomination";
  static const RECENT_TRANSACTIONS = "transaction";
  static const APP_MEDIA = "app_media";
  static const APP_PAGES = "app_pages";
  static const DEFAULT_CONFIG = "default_config";
  static const PUSH_NOTIFICATION = "push-notification";
  static const MY_USERS = "my-users";
}

class HiveDatabase {
  static Future init() async {
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(CountryAdapter());
    await Hive.openBox<Country>(Table.COUNTRIES);
    Hive.registerAdapter(RecentTransactionAdapter());
    await Hive.openBox<RecentTransaction>(Table.RECENT_TRANSACTIONS);
    Hive.registerAdapter(ServiceChildAdapter());
    await Hive.openBox<ServiceChild>(Table.SERVICE_CHILD);
    Hive.registerAdapter(CurrencyAdapter());
    await Hive.openBox<Currency>(Table.CURRENCIES);
    Hive.registerAdapter(BalanceAdapter());
    await Hive.openBox<Balance>(Table.BALANCE);
    Hive.registerAdapter(ServiceAdapter());
    await Hive.openBox<Service>(Table.SERVICE);
    Hive.registerAdapter(OperatorAdapter());
    await Hive.openBox<Operator>(Table.OPERATOR);
    Hive.registerAdapter(DenominationAdapter());
    await Hive.openBox<Denomination>(Table.DENOMINATION);
    Hive.registerAdapter(AppMediaAdapter());
    await Hive.openBox<AppMedia>(Table.APP_MEDIA);
    Hive.registerAdapter(DefaultConfigAdapter());
    await Hive.openBox<DefaultConfig>(Table.DEFAULT_CONFIG);
    Hive.registerAdapter(AppPagesAdapter());
    await Hive.openBox<AppPages>(Table.APP_PAGES);
    Hive.registerAdapter(PushNotificationAdapter());
    await Hive.openBox<PushNotification>(Table.PUSH_NOTIFICATION);
    Hive.registerAdapter(MyUserAdapter());
    await Hive.openBox<MyUser>(Table.MY_USERS);
  }
}
