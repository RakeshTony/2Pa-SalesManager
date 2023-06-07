import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/main.dart';

class AppBarDashboardWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final GlobalKey<ScaffoldState> parentScaffoldState;
  final PreferredSizeWidget? bottom;
  final double elevation;

  AppBarDashboardWidget(
    this.parentScaffoldState, {
    Key? key,
    this.onTap,
    this.elevation = 3,
    this.bottom,
  })  : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State createState() => AppBarDashboardWidgetState();
}

class AppBarDashboardWidgetState extends State<AppBarDashboardWidget> {
  var wallet = HiveBoxes.getBalanceWallet();

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[
      SizedBox(
        height: widget.preferredSize.height,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
            color: kMainColor,
            child: Container(
              height: widget.preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [_getDrawerIcon()],
                  ),
                  _getAppLogo(),
                  _getSyncIcon(),
                ],
              ),
            ),
          ),
        ),
      )
    ];
    if (widget.bottom != null) {
      items.add(widget.bottom!);
    }
    return Material(
      elevation: widget.elevation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items,
      ),
    );
  }

  Widget _getDrawerIcon() {
    return InkWell(
        onTap: () {
          if (widget.parentScaffoldState.currentState?.hasDrawer == true) {
            if (widget.parentScaffoldState.currentState?.isDrawerOpen == true) {
              Navigator.of(widget.parentScaffoldState.currentState!.context)
                  .pop();
            } else {
              widget.parentScaffoldState.currentState!.openDrawer();
            }
          }
        },
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 2),
          width: 45,
          height: 45,
          decoration: BoxDecoration(
              color: kMainColorSecond,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Icon(
            Icons.menu,
            size: 35,
            color: kWhiteColor,
          ),
        ));
  }

  Widget _getSyncIcon() {
    return InkWell(
        onTap: () {
          Navigator.popAndPushNamed(context, PageRoutes.sync);
        },
        child: Container(
          width: 45,
          height: 45,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
              color: kMainColorSecond,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Center(
            child: Icon(
              Icons.cloud_sync_sharp,
              size: 30,
              color: kWhiteColor,
            ),
          ),
        ));
  }

  Widget _getAppLogo() {
    return Image.asset(
      LOGO,
      height: 33,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _getUserIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () {},
        child: Stack(
          children: [
            Image.asset(
              CIRCLE_BACKGROUND,
              width: 30,
              height: 30,
            ),
            Container(
              width: 30,
              height: 30,
              child: Center(
                child: Text(
                  mPreference.value.userData.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 13, color: kWhiteColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getNotificationIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, PageRoutes.notificationPage);
        },
        child: Image.asset(
          IC_BELL_NOTIFICATION,
          width: 30,
          height: 30,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
