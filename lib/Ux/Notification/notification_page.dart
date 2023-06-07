import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Database/models/push_notification.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/app_bar_common_widget.dart';

import '../../Database/hive_boxes.dart';
import 'ViewModel/view_model_notification.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationPageBody();
  }
}

class NotificationPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotificationPageBodyState();
}

class _NotificationPageBodyState
    extends BasePageState<NotificationPageBody, ViewModelNotification> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBarCommonWidget(),
      // appBar: AppBar(),
      backgroundColor: kScreenBackground,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              color: theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder(
                valueListenable: HiveBoxes.getPushNotification().listenable(),
                builder: (context, Box<PushNotification> data, _) {
                  List<PushNotification> items = data.values.toList();
                  items.sort((a, b) => b.time.compareTo(a.time));
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        _itemNotification(items[index], index),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 0,
                    ),
                    itemCount: items.length,
                  );
                }),
          ],
        ),
      ),
    );
  }

  _itemNotification(PushNotification notification, int index) {
    return Container(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? kWhiteColor : kTransparentColor,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: ListTile(
        title: Text(
          notification.title,
          style: TextStyle(
            color: kMainTextColor,
            fontWeight: RFontWeight.REGULAR,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          notification.body,
          style: TextStyle(
              color: kMainTextColor,
              fontWeight: RFontWeight.LIGHT,
              fontSize: 12),
        ),
      ),
    );
  }
}
