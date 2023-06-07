import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/BaseClasses/view_model_common.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/main.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends BasePageState<Splash, ViewModelCommon> {
  bool drop = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      navigateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: kMainColor,
      body: Container(
        decoration: BoxDecoration(
          image:
          DecorationImage(image: AssetImage(SPLASH), fit: BoxFit.fitWidth),
        ),
        child: Center(
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LOGO_BIG),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateUser() async {
    if (mPreference.value.isLogin) {
      if (mPreference.value.mPin.isEmpty) {
        await Navigator.pushNamed(context, PageRoutes.setPin);
        if (mPreference.value.mPin.isEmpty)
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        else
          askPin();
      } else {
        askPin();
      }
    } else {
      Navigator.pushNamed(context, PageRoutes.login);
    }
  }

  void askPin() async {
    var status = await Navigator.pushNamed(context, PageRoutes.enterPin);
    if (status == "SUCCESS") {
      Navigator.pushNamed(context, PageRoutes.home);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}
