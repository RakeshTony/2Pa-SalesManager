import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/app_bar_common_widget.dart';
import 'package:twopa_sales_manager/Utils/Widgets/custom_button.dart';
import 'package:twopa_sales_manager/Utils/Widgets/otp_text_field.dart';
import 'package:twopa_sales_manager/Utils/Widgets/text_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';
import 'package:twopa_sales_manager/Ux/Setting/ViewModel/view_model_enter_m_pin.dart';
import 'package:twopa_sales_manager/main.dart';

import '../../Utils/app_decorations.dart';

class EnterPinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EnterPinBody();
  }
}

class EnterPinBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnterPinBodyState();
}

class _EnterPinBodyState
    extends BasePageState<EnterPinBody, ViewModelEnterMPin> {
  @override
  void initState() {
    super.initState();
    viewModel.responseStream.listen((event) {
      if (event.getStatus) {
        mPreference.value.clear();
        Phoenix.rebirth(context);
      }
    });
  }

  var _otp = "";
  var _isOtpComplete = false;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
    decoration: decorationBackground,
      child:Scaffold(
      appBar: AppBarCommonWidget(
        isShowNotification: false,
      ),
      // appBar: AppBar(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kMainButtonColor.withOpacity(.15),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${locale.enterMPin}",
                    style: TextStyle(
                        fontSize: 14,
                        color: kMainTextColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Reset M-Pin"),
                              content: Text(
                                  "Are you sure you want to reset the M-PIN?"),
                              actionsAlignment: MainAxisAlignment.spaceAround,
                              actions: <Widget>[
                                Container(
                                  child: MaterialButton(
                                    child: Text("No"),
                                    textColor: kMainTextColor,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: kColor6)),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                Container(
                                  child: MaterialButton(
                                    child: Text("Yes"),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: kColor6)),
                                    textColor: kMainTextColor,
                                    onPressed: () {
                                      viewModel.requestResetMPin();
                                      //mPreference.value.clear();
                                      //Phoenix.rebirth(context);
                                    },
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: kMainButtonColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        "${locale.reset}",
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 12,
                          fontWeight: RFontWeight.MEDIUM,
                          fontFamily: RFontFamily.SOFIA_PRO,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OTPTextField(
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 50,
                      fieldStyle: FieldStyle.oval,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: RFontWeight.REGULAR,
                          color: kMainTextColor),
                      onChanged: (pin) {
                        print("Changed: " + pin);
                        _otp = pin;
                        _isOtpComplete = false;
                      },
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                        _otp = pin;
                        _isOtpComplete = true;
                        checkPin(_otp);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: mediaQuery.size.width,
              child: CustomButton(
                text: "${locale.continue_}",
                radius: BorderRadius.all(Radius.circular(34.0)),
                onPressed: () {
                  checkPin(_otp);
                },
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Center(
              child: InkWell(
                child: TextWidget.big(
                  "${locale.cancel}",
                  fontFamily: RFontWeight.LIGHT,
                  textAlign: TextAlign.center,
                  color: kMainColor,
                  fontSize: 20,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    ),);
  }

  void checkPin(String pin) {
    if (mPreference.value.mPin == pin)
      Navigator.pop(context, "SUCCESS");
    else
      AppAction.showGeneralErrorMessage(context, "Invalid M-Pin");
  }
}
