import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/Ux/CreditTransfer/credit_transfer_new_page.dart';
import '../../BaseClasses/base_state.dart';
import '../../BaseClasses/view_model_common.dart';
import '../../Database/hive_boxes.dart';
import '../../Database/models/default_config.dart';
import '../../Locale/locales.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';
import 'credit_transfer_incoming_page.dart';
import 'credit_transfer_outgoing_page.dart';

class CreditTransferPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreditTransferBody();
  }
}

class CreditTransferBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreditTransferBodyState();
}

class _CreditTransferBodyState
    extends BasePageState<CreditTransferBody, ViewModelCommon> {

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
            title: "${locale.creditTransfer}",
            isShowNotification: false),
        backgroundColor: kWhiteColor,
        body: Column(
          children: [
            Container(
              color: kWhiteColor,
              child: TabBar(
                indicatorColor: kColor11,
                tabs: [
                  Tab(
                    text: '${locale.newStr}',
                  ),
                  Tab(
                    text: '${locale.outgoing}',
                  ),
                  Tab(
                    text: '${locale.incoming}',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CreditTransferNewPage(),
                  CreditTransferOutgoingPage(),
                  CreditTransferIncomingPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
