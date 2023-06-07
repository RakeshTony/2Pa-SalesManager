import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';

import '../../BaseClasses/base_state.dart';
import '../../BaseClasses/view_model_common.dart';
import '../../Locale/locales.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReportsPageBody();
  }
}

class ReportsPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReportsPageBodyState();
}

class _ReportsPageBodyState
    extends BasePageState<ReportsPageBody, ViewModelCommon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBarCommonTitleWidget(
            backgroundColor: kMainColor,
            title: "${locale.summaryReport}",
            isShowNotification: false),
        backgroundColor: kWhiteColor,
        body: ListView(children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, PageRoutes.walletTransaction);
            },
            child: ListTile(
              style: ListTileTheme.of(context).style,
              title: Text(
                "${locale.walletTransaction}",
                style: TextStyle(
                    fontWeight: RFontWeight.BOLD,
                    fontSize: 16,
                    color: kColor11),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: kColor11),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, PageRoutes.reportsEarning);
            },
            child: ListTile(
              title: Text(
                "${locale.earningsReport}",
                style: TextStyle(
                    fontWeight: RFontWeight.BOLD,
                    fontSize: 16,
                    color: kColor11),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: kColor11),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, PageRoutes.reportsSales);
            },
            child: ListTile(
              title: Text(
                "${locale.salesReport}",
                style: TextStyle(
                    fontWeight: RFontWeight.BOLD,
                    fontSize: 16,
                    color: kColor11),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: kColor11),
            ),
          )
        ]),
      ),
    );
  }
}
