import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/app_bar_common_title_widget.dart';
import 'package:twopa_sales_manager/Utils/Widgets/app_bar_common_widget.dart';
import 'package:twopa_sales_manager/Utils/Widgets/custom_button.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';
import 'package:twopa_sales_manager/Ux/Setting/ViewModel/view_model_change_password.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_success.dart';

import '../../Utils/app_decorations.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangePasswordBody();
  }
}

class ChangePasswordBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState
    extends BasePageState<ChangePasswordBody, ViewModelChangePassword> {
  TextEditingController _oldController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  FocusNode _oldNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _passwordConfirmNode = FocusNode();

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
            actionText: "Continue",
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

    return Container(
        decoration: decorationBackground,
        child: Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              color: kStripColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "${locale.changePassword}",
                    style: TextStyle(
                        fontSize: 14,
                        color: kTextColor6,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            InputFieldWidget.password(
              "${locale.oldPassword}",
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _oldController,
              focusNode: _oldNode,
              enableColor: kColor7,
              focusColor: kColor8,
              textStyle: inputTextStyle,
              hintStyle: inputHintStyle,
            ),
            InputFieldWidget.password(
              "${locale.newPassword}",
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _passwordController,
              focusNode: _passwordNode,
              enableColor: kColor7,
              focusColor: kColor8,
              textStyle: inputTextStyle,
              hintStyle: inputHintStyle,
            ),
            InputFieldWidget.password(
              "${locale.confirmPassword}",
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _passwordConfirmController,
              focusNode: _passwordConfirmNode,
              enableColor: kColor7,
              focusColor: kColor8,
              textStyle: inputTextStyle,
              hintStyle: inputHintStyle,
            ),
            CustomButton(
              text: "${locale.submit}",
              margin: EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 14),
              radius: BorderRadius.all(Radius.circular(12.0)),
              color: kMainButtonColor,
              onPressed: () {
                viewModel.requestChangePassword(_oldController,
                    _passwordController, _passwordConfirmController);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: locale.forgotPassword!,
        color: kMainButtonColor,
        radius: BorderRadius.all(Radius.circular(0.0)),
        onPressed: () {
          showAlertDialog(context);
        },
      ),
    ),);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        viewModel.requestForgotPasswordInside();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to continue reset password?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static const inputTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: RFontWeight.REGULAR,
    color: kMainTextColor,
    height: 1.5,
  );
  static const inputHintStyle = TextStyle(
    fontSize: 15,
    fontWeight: RFontWeight.REGULAR,
    color: kColor7,
  );
}
