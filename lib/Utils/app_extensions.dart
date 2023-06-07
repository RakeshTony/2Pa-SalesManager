import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/currencies.dart';
import 'package:collection/collection.dart';

extension StringExtensions on String {
  bool startsWithIgnoreCase(String string) {
    return this.toLowerCase().startsWith(string.toLowerCase());
  }

  bool searchAnyWhere(String string) {
    return this.toLowerCase().contains(string.toLowerCase());
  }

  bool equalsIgnoreCase(String string) {
    return this.toLowerCase() == string.toLowerCase();
  }

  bool equalsIgnoreCases(List<String> strings) {
    bool status = false;
    for (String string in strings) {
      if (this.toLowerCase() == string.toLowerCase()) {
        status = true;
        break;
      }
    }
    return status;
  }

  DateTime getDateTime() {
    return DateTime.parse(this);
  }

  String getDateFormat({String format = "d MMM yy, hh:mm a"}) {
    if (this.isEmpty) return "";
    return DateFormat(format).format(DateTime.parse(this));
  }

  String getDate({String format = "yyyy-MM-dd"}) {
    if (this.isEmpty) return "";
    return DateFormat(format).format(DateTime.parse(this));
  }

  String getTime({String format = "hh:mm a"}) {
    if (this.isEmpty) return "";
    return DateFormat(format).format(DateTime.parse(this));
  }
}

extension DateTimeExtension on DateTime {
  String getDate({String format = "yyyy-MM-dd"}) {
    return DateFormat(format).format(this);
  }
}

extension MapExtensions on Map {
  dynamic get(String key) {
    if (this.containsKey(key)) {
      return this[key];
    } else {
      return null;
    }
  }
}

bool toBoolean(dynamic value) {
  return value == null ? false : value.toString().toUpperCase() == "TRUE";
}

int toInt(dynamic value) {
  return int.tryParse(value.toString()) ?? 0;
}

bool toIntBoolean(dynamic value) {
  return toInt(value) == 1;
}

double toDouble(dynamic value) {
  return double.tryParse(value.toString()) ?? 0.0;
}

bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  return double.tryParse(s) != null;
}

String toString(dynamic value) {
  return value == null ? "" : value.toString();
}

List<String> toSplit(dynamic value, {String separator = ","}) {
  if (value == null) return List<String>.empty(growable: true);
  var data = value.toString();
  if (data.isEmpty) return List<String>.empty(growable: true);
  return data.split(separator);
}

List toList(dynamic value) {
  return value is List ? value : [];
}

Map<String, dynamic> toMap(dynamic value) {
  return (value is Map ? value : HashMap<String, dynamic>())
      as Map<String, dynamic>;
}

Map<dynamic, dynamic> toMaps(dynamic value) {
  return (value is Map ? value : HashMap<dynamic, dynamic>());
}

Currency getCurrency(String currencyId) {
  var data = HiveBoxes.getCurrencies().values;
  var curr = data.firstWhereOrNull((element) => element.id == currencyId);
  if (curr == null) {
    curr = data.first;
  }
  return curr;
}

extension DateExtensions on DateTime {
  String getDateTimeFormat() {
    var formatter = DateFormat.yMd().add_Hms();
    return formatter.format(this);
  }
}
