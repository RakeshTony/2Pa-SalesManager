import 'dart:convert';

import 'package:flutter/services.dart' as rootBundle;
import 'package:twopa_sales_manager/DataBeans/RemitaCustomFieldModel.dart';

Future<List<RemitaCustomFieldModel>> getRemitaCustomFields() async {
  //read json file
  final jsonData =
      await rootBundle.rootBundle.loadString('assets/remita_field.json');
  //decode json data as list
  final list = json.decode(jsonData) as List<dynamic>;
  //map json and initialize using DataModel
  return list.map((e) => RemitaCustomFieldModel.fromJson(e)).toList();
}
