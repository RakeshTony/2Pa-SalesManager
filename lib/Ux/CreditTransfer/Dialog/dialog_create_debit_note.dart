import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/DataBeans/MyUserResponseDataModel.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';

class DialogCreateDebitNote extends StatelessWidget {
  final bool isCancelable;
  final MyUserDataModel user;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reAmountController = TextEditingController();

  DialogCreateDebitNote(
    this.user, {
    this.isCancelable = true,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isCancelable,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(

          decoration: new BoxDecoration(
              color: kWhiteColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: kNavigationButtonColor,
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        color: kNavigationButtonColor,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_forward,
                        color: kWhiteColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "CREDIT NEW DEBIT NOTE",
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
                        Icons.cancel_rounded,
                        color: kNavigationButtonColor,
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
                    color: kNavigationButtonColor,
                    fontSize: 18,
                    fontWeight: RFontWeight.BOLD,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer Wallet",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: kMainTextColor,
                            fontSize: 14,
                            fontWeight: RFontWeight.MEDIUM,
                          ),
                        ),
                        Text(
                          "${user.totalBalance}",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: kNavigationButtonColor,
                            fontSize: 12,
                            fontWeight: RFontWeight.BOLD,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InputFieldWidget.number("Enter Amount",
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  enableColor: kMainColor,
                  focusColor: kMainColor,
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
              InputFieldWidget.number("Re-Enter Amount",
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  enableColor: kMainColor,
                  focusColor: kMainColor,
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
                          color: kNavigationButtonColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Text("Debit".toUpperCase(),
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
