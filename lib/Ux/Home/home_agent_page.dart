import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/app_helper.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Ux/CashCollection/cash_collection_collected_page.dart';
import 'package:twopa_sales_manager/Ux/CashCollection/cash_collection_new_page.dart';
import 'package:twopa_sales_manager/Ux/Home/home_drawer_menu.dart';
import 'package:twopa_sales_manager/Ux/Wallet/ViewModel/view_model_wallet.dart';

class HomeAgentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeAgentPageBody();
  }
}

class HomeAgentPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeAgentPageBodyState();
}

class _HomeAgentPageBodyState
    extends BasePageState<HomeAgentPageBody, ViewModelWallet> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                if (scaffoldKey.currentState?.hasDrawer == true) {
                  if (scaffoldKey.currentState?.isDrawerOpen == true) {
                    Navigator.of(scaffoldKey.currentState!.context).pop();
                  } else {
                    scaffoldKey.currentState!.openDrawer();
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: kMainColorSecond,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Icon(
                    Icons.menu,
                    size: 36,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
            title: Image.asset(
              LOGO,
              height: 33,
              fit: BoxFit.fitHeight,
            ),
          ),
          backgroundColor: kMainColor,
          body: Column(
            children: [
              Container(
                color: kMainColor,
                child: TabBar(
                  indicatorColor: kWhiteColor,
                  tabs: [
                    Tab(
                      text: 'NEW',
                    ),
                    Tab(
                      text: 'COLLECTED',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    CashCollectionNewPage(),
                    CashCollectionCollectedPage(),
                  ],
                ),
              )
            ],
          ),
          drawer: DrawerMenu(),
        ),
      ),
    );
  }
}
