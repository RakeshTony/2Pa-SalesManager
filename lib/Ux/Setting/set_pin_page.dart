import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/app_bar_common_widget.dart';
import 'package:twopa_sales_manager/Utils/Widgets/custom_button.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_success.dart';
import 'package:twopa_sales_manager/main.dart';
import '../../Utils/app_decorations.dart';
import 'ViewModel/view_model_set_m_pin.dart';

class SetPinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetPinBody();
  }
}

class SetPinBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetPinBodyState();
}

class _SetPinBodyState extends BasePageState<SetPinBody, ViewModelSetMPin> {
  TextEditingController _newController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  FocusNode _newNode = FocusNode();
  FocusNode _confirmNode = FocusNode();

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
              mPreference.value.mPin = _newController.text.trim();
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
      appBar: AppBarCommonWidget(
        isShowNotification: false,
      ),
      // appBar: AppBar(),
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
                    mPreference.value.mPin.isEmpty?"Set M-Pin":"Reset M-Pin",
                    style: TextStyle(
                        fontSize: 14,
                        color: kMainColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            InputFieldWidget.password(
              "New Pin",
              disableSpace: true,
              maxLength: 4,
              inputType: RInputType.TYPE_NUMBER_PASSWORD,
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _newController,
              focusNode: _newNode,
              textStyle: TextStyle(
                fontSize: 15,
                fontWeight: RFontWeight.LIGHT,
                color: kMainTextColor,
                height: 1.5,
              ),
            ),
            InputFieldWidget.password(
              "Confirm Pin",
              disableSpace: true,
              maxLength: 4,
              inputType: RInputType.TYPE_NUMBER_PASSWORD,
              margin: EdgeInsets.only(top: 14, left: 16, right: 16),
              textEditingController: _confirmController,
              focusNode: _confirmNode,
              textStyle: TextStyle(
                fontSize: 15,
                fontWeight: RFontWeight.LIGHT,
                color: kMainTextColor,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20,),
            CustomButton(
              text: "Submit",
              margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
              radius: BorderRadius.all(Radius.circular(34.0)),
              onPressed: () {
                var pin = _newController.text.trim();
                var confirmPin = _confirmController.text.trim();
                var error = "";
                if (pin.isEmpty) {
                  error = "Please Enter Pin";
                } else if (pin.length != 4) {
                  error = "Please Enter 4-Digit Pin ";
                } else if (confirmPin.isEmpty) {
                  error = "Please Enter Confirm Pin ";
                } else if (confirmPin.length != 4) {
                  error = "Please Enter 4-Digit Confirm Pin ";
                } else if (confirmPin != pin) {
                  error = "Pin Not Match";
                }
                if(error.isEmpty){
                  viewModel.requestSetMPin(_newController);
                }else{
                  AppAction.showGeneralErrorMessage(context, error);
                }
              },
            ),
          ],
        ),
      ),
    ),);
  }
}
