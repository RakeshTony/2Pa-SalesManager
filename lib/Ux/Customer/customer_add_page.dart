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
import 'package:twopa_sales_manager/Ux/Customer/ViewModel/view_model_customer.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_success.dart';
import '../../DataBeans/MyUserResponseDataModel.dart';
import '../../Utils/app_style_text.dart';

class CustomerAddPage extends StatelessWidget {
  final MyUserDataModel user;

  CustomerAddPage(this.user);

  @override
  Widget build(BuildContext context) {
    return CustomerAddPageBody(user);
  }
}

class CustomerAddPageBody extends StatefulWidget {
  final MyUserDataModel user;

  @override
  State<StatefulWidget> createState() => _CustomerAddPageBodyState();

  CustomerAddPageBody(this.user);
}

class _CustomerAddPageBodyState
    extends BasePageState<CustomerAddPageBody, ViewModelCustomers> {
  PlansData plansData = PlansData(name: "Select Plan");

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _numberNode = FocusNode();
  FocusNode _addressNode = FocusNode();

  PlansData? dropdownValuePlans;
  List<PlansData> spinnerItemsPlans = [];

  @override
  void initState() {
    super.initState();
    viewModel.requestPlansList();
    if (spinnerItemsPlans.isEmpty) spinnerItemsPlans.add(plansData);
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
              Navigator.pop(context, "RELOAD");
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);
    viewModel.plansStream.listen((map) {
      if (spinnerItemsPlans.isNotEmpty) spinnerItemsPlans.clear();
      spinnerItemsPlans.add(plansData);
      spinnerItemsPlans.addAll(map);
      if (widget.user.planId.isNotEmpty) {
        spinnerItemsPlans.forEach((element) {
          if (element.id == widget.user.planId) {
            dropdownValuePlans = element;
          }
        });
      }
      if (mounted) {
        setState(() {});
      }
    }, cancelOnError: false);
    if (!(widget.user.name == "")) {
      _nameController.text = widget.user.name;
      _emailController.text = widget.user.email;
      _numberController.text = widget.user.mobile;
      _addressController.text = widget.user.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    if (dropdownValuePlans == null) {
      dropdownValuePlans = plansData;
    }

    return Scaffold(
      appBar: AppBarCommonTitleWidget(
          backgroundColor: kMainColor,
          title: (widget.user.id.isNotEmpty ? "${locale.editCustomer}" : "${locale.addCustomer}")
              .toUpperCase(),
          isShowNotification: false),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    /*Plans Spinner*/
                    Visibility(
                      visible: true,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: kTextColor4.withOpacity(.15),
                          border: Border.all(width: .5, color: kTextColor4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<PlansData>(
                            value: dropdownValuePlans,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isDense: true,
                            style: AppStyleText.inputFiledPrimaryText2,
                            onChanged: (data) {
                              setState(() {
                                dropdownValuePlans = data!;
                              });
                            },
                            items: spinnerItemsPlans
                                .map<DropdownMenuItem<PlansData>>(
                                    (PlansData value) {
                              return DropdownMenuItem<PlansData>(
                                value: value,
                                child: Text(
                                  value.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: kColor7,
                                    fontSize: 14,
                                    fontWeight: RFontWeight.REGULAR,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    InputFieldWidget.text(
                      locale.name ?? "",
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
                      locale.email ?? "",
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      padding: EdgeInsets.all(5),
                      enableColor: kColor7,
                      focusColor: kColor8,
                      textEditingController: _emailController,
                      focusNode: _emailNode,
                      textStyle: inputTextStyle,
                      hintStyle: inputHintStyle,
                    ),
                    InputFieldWidget.number(
                      locale.mobileNumber ?? "",
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      padding: EdgeInsets.all(5),
                      enableColor: kColor7,
                      focusColor: kColor8,
                      textEditingController: _numberController,
                      focusNode: _numberNode,
                      textStyle: inputTextStyle,
                      hintStyle: inputHintStyle,
                    ),
                    InputFieldWidget.email(
                      locale.address ?? "",
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      padding: EdgeInsets.all(5),
                      enableColor: kColor7,
                      focusColor: kColor8,
                      textEditingController: _addressController,
                      focusNode: _addressNode,
                      textStyle: inputTextStyle,
                      hintStyle: inputHintStyle,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: mediaQuery.size.width,
                      child: CustomButton(
                        text: widget.user.id.isNotEmpty
                            ? "${locale.editCustomer}"
                            : "${locale.addCustomer}",
                        margin: EdgeInsets.only(top: 14, left: 33, right: 33),
                        radius: BorderRadius.all(Radius.circular(12.0)),
                        color: kMainButtonColor,
                        onPressed: () async {
                          var planId = dropdownValuePlans?.id ?? "";
                          if (widget.user.id.isEmpty) {
                            // CREATE NEW CUSTOMER
                            viewModel.requestCreateCustomer(
                                _nameController,
                                _emailController,
                                _numberController,
                                _addressController,
                                planId);
                          } else {
                            // CUSTOMER UPDATE
                            viewModel.requestUpdateCustomer(
                                _nameController,
                                _emailController,
                                _numberController,
                                _addressController,
                                planId,
                                widget.user.id);
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
