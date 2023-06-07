import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/DataBeans/UserRanksPlansDataModel.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/app_bar_common_title_widget.dart';
import 'package:twopa_sales_manager/Utils/Widgets/custom_button.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';
import 'package:twopa_sales_manager/Utils/app_style_text.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_success.dart';
import '../../DataBeans/MyUserResponseDataModel.dart';
import 'ViewModel/view_model_add_plan.dart';

class AddPlanPage extends StatelessWidget {
  PlansData plansData;

  AddPlanPage({required this.plansData});

  @override
  Widget build(BuildContext context) {
    return AddPlanBody(plansData);
  }
}

class AddPlanBody extends StatefulWidget {
  final  PlansData plansData;

  @override
  State<StatefulWidget> createState() => _AddPlanBodyState();

  AddPlanBody(this.plansData);
}

class _AddPlanBodyState extends BasePageState<AddPlanBody, ViewModelAddPlan> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _amountMinController = TextEditingController();
  TextEditingController _amountMaxController = TextEditingController();

  FocusNode _nameNode = FocusNode();
  FocusNode _codeNode = FocusNode();
  FocusNode _amountMinNode = FocusNode();
  FocusNode _amountMaxNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.plansData.name;
    _codeController.text = widget.plansData.code;
    _amountMinController.text = widget.plansData.minTransferAmount;
    _amountMaxController.text = widget.plansData.maxTransferAmount;
    viewModel.responseStream.listen((map) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: map.getMessage,
            actionText: "Continue",
            isCancelable: false,
            onActionTap: () {
              Navigator.pop(context, "RELOAD");
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

    return Scaffold(
      appBar: AppBarCommonTitleWidget(
          backgroundColor: kMainColor,
          title: (widget.plansData.id.isNotEmpty ? "Edit Plan" : "Add Plan").toUpperCase(),
          backgroundColorBackButton: kMainColorSecond,
          isShowNotification: false),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    InputFieldWidget.text(
                      "Plan Name",
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      padding: EdgeInsets.all(5),
                      enableColor: kColor7,
                      focusColor: kColor8,
                      textEditingController: _nameController,
                      focusNode: _nameNode,
                      textStyle: inputTextStyle,
                      hintStyle: inputHintStyle,
                    ),
                    InputFieldWidget.email(
                      "Plan Code",
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      padding: EdgeInsets.all(5),
                      enableColor: kColor7,
                      focusColor: kColor8,
                      textEditingController: _codeController,
                      focusNode: _codeNode,
                      textStyle: inputTextStyle,
                      hintStyle: inputHintStyle,
                    ),
                    InputFieldWidget.number(
                      "Min Amount",
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      padding: EdgeInsets.all(5),
                      enableColor: kColor7,
                      focusColor: kColor8,
                      textEditingController: _amountMinController,
                      focusNode: _amountMinNode,
                      textStyle: inputTextStyle,
                      hintStyle: inputHintStyle,
                    ),
                    InputFieldWidget.email(
                      "Max Amount",
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      padding: EdgeInsets.all(5),
                      enableColor: kColor7,
                      focusColor: kColor8,
                      textEditingController: _amountMaxController,
                      focusNode: _amountMaxNode,
                      textStyle: inputTextStyle,
                      hintStyle: inputHintStyle,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: mediaQuery.size.width,
                      child: CustomButton(
                        text: widget.plansData.id.isNotEmpty
                            ? "Edit Plan"
                            : "Add Plan",
                        margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                        radius: BorderRadius.all(Radius.circular(12.0)),
                        color: kMainColor,
                        onPressed: () async {
                          if (widget.plansData.id.isEmpty) {
                            // CREATE NEW AGENT
                            viewModel.requestCreateAgent(
                                _nameController,
                                _codeController,
                                _amountMinController,
                                _amountMaxController);
                          } else {
                            // AGENT UPDATE
                            viewModel.requestUpdatePlan(
                                _nameController,
                                _codeController,
                                _amountMinController,
                                _amountMaxController,
                                widget.plansData.id);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
