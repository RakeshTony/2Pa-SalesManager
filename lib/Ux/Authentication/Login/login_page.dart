import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/custom_button.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/Widgets/text_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';
import 'package:twopa_sales_manager/Utils/app_helper.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Ux/Authentication/Login/ViewModel/view_model_login.dart';
import 'package:twopa_sales_manager/main.dart';

import '../../../Utils/app_decorations.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginBody();
  }
}

class LoginBody extends StatefulWidget {
  @override
  State createState() {
    return _LoginBodyState();
  }
}

class _LoginBodyState extends BasePageState<LoginBody, ViewModelLogin> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  TextEditingController _numberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FocusNode _numberNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  late GlobalKey<FormState> formState;

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    formState = GlobalKey<FormState>();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.responseStream.listen((map) async {
      if (mounted) {
        switch (map.second.getStatusCode) {
          case 200: // LOGIN SUCCESSFULLY
            {
              var isSalesManager = map.second.groupData.isSalesManager;
              var isAgent = map.second.groupData.isAgent;
              if (isSalesManager || isAgent) {
                await mPreference.value.setUserLogin(map.second);
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
                AppAction.showGeneralErrorMessage(context, "Invalid User");
              }
              break;
            }
          case 201: // GO TO OTP VERIFICATION
            {
              Navigator.pushNamed(context, PageRoutes.verification,
                  arguments: map.first);
              break;
            }
        }
      }
    }, cancelOnError: false);
  }

  void askPin() async {
    var status = await Navigator.pushNamed(context, PageRoutes.enterPin);
    if (status == "SUCCESS") {
      Navigator.pushNamed(context, PageRoutes.home);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
   child: Container(
    decoration: decorationBackground,
    child:  Scaffold(
      backgroundColor: kTransparentColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 52,
                  ),
                  Image.asset(
                    LOGO_BIG,
                    width: 192,
                    height: 90,
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  TextWidget.medium(
                    "Sales Manager",
                    fontFamily: RFontWeight.REGULAR,
                    textAlign: TextAlign.center,
                    color: kLightTextColor,
                    fontSize: 21,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget.big(
                    locale.signIn!,
                    fontFamily: RFontWeight.REGULAR,
                    textAlign: TextAlign.center,
                    color: kLightTextColor,
                    fontSize: 27,
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 33, right: 33),
                    child: Stack(
                      children: [
                        InputFieldWidget.text(
                          "Username / Mobile Number",
                          padding: EdgeInsets.only(
                              top: 12, right: 10, left: 0, bottom: 12),
                          textEditingController: _numberController,
                          focusNode: _numberNode,
                          textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: RFontWeight.LIGHT,
                            color: kMainTextColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InputFieldWidget.password(
                    locale.password ?? "",
                    margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                    textEditingController: _passwordController,
                    focusNode: _passwordNode,
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: RFontWeight.LIGHT,
                      color: kMainTextColor,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    height: 80,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          height: 80,
                          child: Column(
                            children: [
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: kTransparentColor,
                                  )),
                            ],
                          ),
                        ),
                        Align(
                          child: Container(
                            width: mediaQuery.size.width,
                            child: CustomButton(
                              text: locale.signIn,
                              margin:
                                  EdgeInsets.only(top: 14, left: 33, right: 33),
                              radius: BorderRadius.all(Radius.circular(30.0)),
                              onPressed: () async {
                                // Navigator.pushNamed(context, PageRoutes.bottomNavigation);
                                viewModel.requestLogin(
                                    _numberController,
                                    _passwordController,
                                    _deviceData.toString());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: mediaQuery.size.width,
                    color: kTransparentColor,
                    padding: EdgeInsets.only(top: 24),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageRoutes.forgotPassword);
                        },
                        child: Text(
                          locale.forgotPassword!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: RFontWeight.REGULAR,
                              color: kMainColor,
                              fontFamily: RFontFamily.POPPINS),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ),
      ),
    );
  }
}
