import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/Ux/CashCollection/cash_collection_collected_page.dart';
import 'package:twopa_sales_manager/Ux/CashCollection/cash_collection_new_page.dart';
import 'package:twopa_sales_manager/Ux/CashCollection/cash_collection_payment_made_page.dart';
import '../../BaseClasses/base_state.dart';
import '../../BaseClasses/view_model_common.dart';
import '../../Database/hive_boxes.dart';
import '../../Database/models/default_config.dart';
import '../../Locale/locales.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';

class CashCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CashCollectionBody();
  }
}

class CashCollectionBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CashCollectionBodyState();
}

class _CashCollectionBodyState
    extends BasePageState<CashCollectionBody, ViewModelCommon> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarCommonTitleWidget(
            backgroundColor: kMainColor,
            title: "${locale.creditCollection}".toUpperCase(),
            backgroundColorBackButton: kColor9,
            isShowNotification: false),
        backgroundColor: kWhiteColor,
        body: Column(
          children: [
            Container(
              color: kMainColor,
              child: TabBar(
                indicatorColor: kColor11,
                tabs: [
                  Tab(
                    text: '${locale.newStr}',
                  ),
                  Tab(
                    text: '${locale.collected}',
                  ),
                  /*Tab(
                    text: 'PAYMENT MADE',
                  ),*/
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CashCollectionNewPage(),
                  CashCollectionCollectedPage(),
                  /*CashCollectionPaymentMadePage(),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
