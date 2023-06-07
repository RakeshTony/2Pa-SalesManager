import 'package:flutter/material.dart';

import '../../Database/hive_boxes.dart';
import '../../Routes/routes.dart';
import '../../Theme/colors.dart';
import '../../main.dart';
import '../Enum/enum_r_font_weight.dart';
import '../app_icons.dart';

class AppBarCommonTitleWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldState;
  final String? title;
  final bool isShowBalance;
  final bool isShowUser;
  final bool isShowShare;
  final GestureTapCallback? doShare;
  final Color backgroundColor;
  final Color backgroundColorBackButton;
  final bool isShowNotification;

  AppBarCommonTitleWidget({
    Key? key,
    this.parentScaffoldState,
    this.title,
    this.isShowBalance = true,
    this.isShowUser = true,
    this.isShowShare = false,
    this.isShowNotification = true,
    this.doShare,
    this.backgroundColor = kMainColor,
    this.backgroundColorBackButton = kMainColorSecond,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize;

  @override
  State createState() => AppBarCommonTitleWidgetState();
}

class AppBarCommonTitleWidgetState extends State<AppBarCommonTitleWidget> {
  var wallet = HiveBoxes.getBalanceWallet();

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var items = <Widget>[
      SizedBox(
        height: widget.preferredSize.height,
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
          //color: widget.backgroundColor,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [kWhiteColor, kButtonBorderColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
    ),
          child: Container(
            height: widget.preferredSize.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _getBackIcon(),
                SizedBox(width: 10,),
                _getTitle(),
                _getNotificationIcon(),
              ],
            ),
          ),
        ),
      )
    ];
    return Material(
      child: Container(
        margin: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: items,
        ),
      ),
    );
  }

  Widget _getBackIcon() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        child: Icon(Icons.arrow_back_rounded, color: kColor11),
      ),
    );
  }

  Widget _getAppLogo() {
    return Image.asset(
      LOGO,
      height: 33,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _getTitle() {
    return Flexible(
      child: Text(
        "${widget.title}",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: kSecondTextColor,
          fontSize: 18,
          fontWeight: RFontWeight.BOLD,
        ),
      ),
    );
  }

  Widget _getUserIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, PageRoutes.profile);
        },
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

  Widget _getChangeLanguage() {
    var isShow = true;
    if (isShow) {
      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: InkWell(
          onTap: () {},
          child: Image.asset(
            IC_CHANGE_LANGUAGE,
            width: 30,
            height: 30,
          ),
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget _getShareIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: widget.doShare,
        child: Image.asset(
          IC_SHARE,
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _getNotificationIcon() {
    return Visibility(
      visible: widget.isShowNotification,
      child: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, PageRoutes.notificationPage);
          },
          child: Icon(Icons.notifications_active_outlined,color: kColor11,),
        ),
      ),
    );
  }
}
