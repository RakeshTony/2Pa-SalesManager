import 'dart:convert';
import 'package:twopa_sales_manager/DataBeans/MyUserResponseDataModel.dart';
import 'package:hive/hive.dart';

part 'my_user.g.dart';

@HiveType(typeId: 13)
class MyUser {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String username;
  @HiveField(2)
  late String walletId;
  @HiveField(3)
  late String name;
  @HiveField(4)
  late String mobile;
  @HiveField(5)
  late String email;
  @HiveField(6)
  late String firmName;
  @HiveField(7)
  late bool status;
  @HiveField(8)
  late double totalCredits;
  @HiveField(9)
  late double totalBalance;
  @HiveField(10)
  late String icon;

  @override
  String toString() {
    return jsonEncode({
      "id": id,
      "name": name,
      "mobile": mobile,
      "email": email,
    });
  }

  MyUser({
    this.id = "",
    this.username = "",
    this.walletId = "",
    this.name = "",
    this.mobile = "",
    this.email = "",
    this.firmName = "",
    this.status = false,
    this.totalCredits = 0.0,
    this.totalBalance = 0.0,
    this.icon = "",
  });
}

extension MyUserExtension on MyUser {
  MyUserDataModel get toMyUserDataModel => MyUserDataModel()
    ..id = this.id
    ..username = this.username
    ..walletId = this.walletId
    ..name = this.name
    ..mobile = this.mobile
    ..email = this.email
    ..firmName = this.firmName
    ..status = this.status
    ..totalCredits = this.totalCredits
    ..totalBalance = this.totalBalance
    ..icon = this.icon;
}

extension MyUserDataModelExtension on MyUserDataModel {
  MyUser get toMyUser => MyUser()
    ..id = this.id
    ..username = this.username
    ..walletId = this.walletId
    ..name = this.name
    ..mobile = this.mobile
    ..email = this.email
    ..firmName = this.firmName
    ..status = this.status
    ..totalCredits = this.totalCredits
    ..totalBalance = this.totalBalance
    ..icon = this.icon;
}
