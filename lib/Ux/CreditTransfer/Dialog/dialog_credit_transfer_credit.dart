import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/DataBeans/MyUserResponseDataModel.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';

import '../../../Locale/locales.dart';
import '../../../Utils/app_icons.dart';

class DialogCreditTransferCredit extends StatelessWidget {
  final bool isCancelable;
  final MyUserDataModel user;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reAmountController = TextEditingController();

  DialogCreditTransferCredit(
    this.user, {
    this.isCancelable = true,
  });

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async => isCancelable,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          color: kWhiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: kColor6,
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        FORWARD_CIRCLE,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${locale.creditAmountTransfer}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kMainTextColor,
                          fontSize: 16,
                          fontWeight: RFontWeight.BOLD,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(
                            Icons.cancel,
                            color: kColor6,
                            size: 35,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "${user.name}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: kColor6,
                    fontSize: 18,
                    fontWeight: RFontWeight.BOLD,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "${locale.customerDue}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kMainTextColor,
                              fontSize: 14,
                              fontWeight: RFontWeight.MEDIUM,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${user.totalBalance}",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kColor6,
                              fontSize: 12,
                              fontWeight: RFontWeight.BOLD,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "${locale.balanceDue}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kMainTextColor,
                              fontSize: 14,
                              fontWeight: RFontWeight.MEDIUM,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${user.totalCredits}",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kColor6,
                              fontSize: 12,
                              fontWeight: RFontWeight.BOLD,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              InputFieldWidget.number(locale.enterAmount ?? "",
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  enableColor: kColor6,
                  focusColor: kColor6,
                  textEditingController: _amountController,
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: RFontWeight.REGULAR,
                    color: kMainTextColor,
                    height: 1.5,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: RFontWeight.REGULAR,
                    color: kColor7,
                  )),
              InputFieldWidget.number(locale.reEnterAmount ?? "",
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  enableColor: kColor6,
                  focusColor: kColor6,
                  textEditingController: _reAmountController,
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: RFontWeight.REGULAR,
                    color: kMainTextColor,
                    height: 1.5,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: RFontWeight.REGULAR,
                    color: kColor7,
                  )),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      var amount = _amountController.text.toString().trim();
                      var reAmount = _reAmountController.text.toString().trim();
                      if (amount.isEmpty) {
                        AppAction.showGeneralErrorMessage(
                            context, "Please Enter Amount");
                      } else if (reAmount.isEmpty) {
                        AppAction.showGeneralErrorMessage(
                            context, "Please Enter Re-Amount");
                      } else if (!reAmount.endsWith(amount)) {
                        AppAction.showGeneralErrorMessage(
                            context, "Amount not match");
                      } else {
                        Navigator.pop(context, amount);
                      }
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                      decoration: new BoxDecoration(
                          color: kColor6,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Text("${locale.transfer}".toUpperCase(),
                          style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 12,
                              fontWeight: RFontWeight.REGULAR,
                              fontFamily: RFontFamily.SOFIA_PRO)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle title() {
    return TextStyle(
        color: kMainTextColor,
        fontSize: 14,
        fontWeight: RFontWeight.BOLD,
        fontFamily: RFontFamily.POPPINS);
  }

  TextStyle description() {
    return TextStyle(
        color: kMainTextColor,
        fontSize: 12,
        fontWeight: RFontWeight.REGULAR,
        fontFamily: RFontFamily.POPPINS);
  }
}
