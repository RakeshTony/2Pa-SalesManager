import 'package:hive_flutter/adapters.dart';
import 'package:twopa_sales_manager/DataBeans/DefaultConfigDataModel.dart';

part 'push_notification.g.dart';

@HiveType(typeId: 12)
class PushNotification extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String body;
  @HiveField(2)
  late DateTime time;
}