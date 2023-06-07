import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/Ux/Agent/agent_active_page.dart';
import '../../BaseClasses/base_state.dart';
import '../../BaseClasses/view_model_common.dart';
import '../../Database/hive_boxes.dart';
import '../../Database/models/default_config.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';

class AgentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgentBody();
  }
}

class AgentBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AgentBodyState();
}

class _AgentBodyState extends BasePageState<AgentBody, ViewModelCommon> {
  var configs = HiveBoxes.getDefaultConfig();

  DefaultConfig? getConfig() {
    return configs.values.isNotEmpty ? configs.values.first : null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarCommonTitleWidget(
            backgroundColor: kMainColor,
            title: "My Agents".toUpperCase(),
            backgroundColorBackButton: kColor9,
            isShowNotification: false),
        backgroundColor: kWhiteColor,
        body: Column(
          children: [
            Container(
              color: kMainColor,
              child: TabBar(
                indicatorColor: kColor8,
                tabs: [
                  Tab(
                    text: 'ACTIVE AGENTS',
                  ),
                  Tab(
                    text: 'INACTIVE AGENTS',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AgentActivePage(true),
                  AgentActivePage(false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
