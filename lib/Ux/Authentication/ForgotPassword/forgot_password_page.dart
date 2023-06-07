
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/custom_button.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/Widgets/text_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Ux/Authentication/ForgotPassword/ViewModel/view_model_forgot_password.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_success.dart';

import '../../../Utils/app_decorations.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ForgotPasswordBody();
  }
}

class ForgotPasswordBody extends StatefulWidget {
  @override
  State createState() {
    return _ForgotPasswordBodyState();
  }
}

class _ForgotPasswordBodyState
    extends BasePageState<ForgotPasswordBody, ViewModelForgotPassword> {
  TextEditingController _numberController = TextEditingController();

  FocusNode _numberNode = FocusNode();

  @override
  void initState() {
    super.initState();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);
    viewModel.responseStream.listen((map) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: map.getMessage,
            actionText: "Go To Login",
            isCancelable: false,
            onActionTap: () {
              Navigator.pop(context);
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return  Container(
    decoration: decorationBackground,
        child:Scaffold(
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 48,
              ),
              Image.asset(
                LOGO_BIG,
                width: 192,
                height: 90,
              ),
              SizedBox(
                height: 48,
              ),
              TextWidget.big(
                "Forgot Password",
                fontFamily: RFontWeight.REGULAR,
                textAlign: TextAlign.center,
                color: kMainTextColor,
                fontSize: 27,
              ),
              SizedBox(
                height: 27,
              ),

              InputFieldWidget.text(
                "User name / Mobile Number",
                margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                textEditingController: _numberController,
                focusNode: _numberNode,
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: RFontWeight.LIGHT,
                  color: kMainTextColor,
                  height: 1.5,
                ),
              ),
              Container(
                height: 80,
                margin: EdgeInsets.only(top: 24),
                color: kTransparentColor,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: kTransparentColor,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color:kTransparentColor,
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: mediaQuery.size.width,
                      child: CustomButton(
                        text: "Submit",
                        margin:
                        EdgeInsets.only(top: 14, left: 33, right: 33),
                        radius: BorderRadius.all(Radius.circular(34.0)),
                        onPressed: () async {
                          viewModel
                              .requestForgotPassword(_numberController);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 66,
        padding: EdgeInsets.only(bottom: 16),
        child: Center(
          child: RichText(
            text: TextSpan(
                text: "Back To ",
                style: TextStyle(
                    fontWeight: RFontWeight.LIGHT,
                    fontSize: 17,
                    color: kMainColor),
                children: [
                  TextSpan(
                      text: "Login",
                      style: TextStyle(
                          fontWeight: RFontWeight.REGULAR,
                          fontSize: 17,
                          color: kMainColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        })
                ]),
          ),
        ),
      ),
    ));
  }
}
