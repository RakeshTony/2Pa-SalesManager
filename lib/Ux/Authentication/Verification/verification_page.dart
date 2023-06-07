import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/custom_button.dart';
import 'package:twopa_sales_manager/Utils/Widgets/otp_text_field.dart';
import 'package:twopa_sales_manager/Utils/Widgets/text_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Ux/Authentication/Verification/ViewModel/view_model_verification.dart';
import 'package:twopa_sales_manager/main.dart';

class RedirectVerificationModel {
  String username;
  String password;
  String isSales;
  String deviceInfo;
  String deviceDetails;
  String fcmTokenKey;

  RedirectVerificationModel(
    this.username,
    this.password,
    this.isSales,
    this.deviceInfo,
    this.deviceDetails,
    this.fcmTokenKey,
  );
}

class VerificationPage extends StatelessWidget {
  final VoidCallback onVerificationDone;
  final RedirectVerificationModel data;

  VerificationPage(this.data, this.onVerificationDone);

  @override
  Widget build(BuildContext context) {
    return VerificationBody(data, onVerificationDone);
  }
}

class VerificationBody extends StatefulWidget {
  final VoidCallback onVerificationDone;
  final RedirectVerificationModel data;

  VerificationBody(this.data, this.onVerificationDone);

  @override
  State createState() {
    return _VerificationBodyState();
  }
}

class _VerificationBodyState
    extends BasePageState<VerificationBody, ViewModelVerification> {
  var _otp = "";
  var _isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.verifyLoginStream.listen((map) async {
      if (mounted) {
        await mPreference.value.setUserLogin(map);
        widget.onVerificationDone();
      }
    }, cancelOnError: false);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: kWhiteColor,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 38,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextWidget.big(
                    "Confirm your OTP",
                    fontFamily: RFontWeight.REGULAR,
                    textAlign: TextAlign.center,
                    color: kWhiteColor,
                    fontSize: 27,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextWidget.big(
                    "Verification",
                    fontFamily: RFontWeight.REGULAR,
                    textAlign: TextAlign.center,
                    color: kMainButtonColor,
                    fontSize: 27,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OTPTextField(
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 50,
                    fieldStyle: FieldStyle.oval,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: RFontWeight.REGULAR,
                        color: kWhiteColor),
                    onChanged: (pin) {
                      print("Changed: " + pin);
                      _otp = pin;
                      _isOtpComplete = false;
                    },
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                      _otp = pin;
                      _isOtpComplete = true;
                    },
                  ),
                ),
                Container(
                  width: mediaQuery.size.width,
                  margin: EdgeInsets.symmetric(vertical: 48),
                  child: CustomButton(
                    text: "Verification",
                    margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                    radius: BorderRadius.all(Radius.circular(34.0)),
                    onPressed: () async {
                      viewModel.requestVerify(_otp, widget.data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 66,
        child: Center(
          child: InkWell(
            child: TextWidget.big(
              "Resend OTP",
              fontFamily: RFontWeight.REGULAR,
              textAlign: TextAlign.center,
              color: kWhiteColor,
              fontSize: 21,
            ),
            onTap: () {
              viewModel.requestVerify(_otp, widget.data, isResend: true);
            },
          ),
        ),
      ),
    );
  }
}
