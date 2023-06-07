import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/DataBeans/MyUserResponseDataModel.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Utils/app_log.dart';
import 'package:twopa_sales_manager/Ux/CreditTransfer/Dialog/dialog_create_debit_note.dart';
import 'package:twopa_sales_manager/Ux/CreditTransfer/Dialog/dialog_credit_transfer_credit.dart';
import 'package:twopa_sales_manager/Ux/CreditTransfer/ViewModel/view_model_credit_transfer.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_success.dart';

import '../../Database/hive_boxes.dart';
import '../../Locale/locales.dart';
import '../../Utils/Enum/enum_sort_type.dart';
import '../../Utils/Widgets/input_field_widget.dart';

class CreditTransferNewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreditTransferNewBody();
  }
}

class CreditTransferNewBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreditTransferNewBodyState();
}

class _CreditTransferNewBodyState
    extends BasePageState<CreditTransferNewBody, ViewModelCreditTransfer> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  List<MyUserDataModel> mUsers = List<MyUserDataModel>.empty(growable: true);

  List<MyUserDataModel> filterData = [];
  var mWallet= HiveBoxes.getBalance();
  void doSearchListener() {
    var key = _searchController.text;
    if (filterData.isNotEmpty) filterData.clear();
    if (key.isNotEmpty) {
      filterData.addAll(mUsers
          .where((element) => element.name.searchAnyWhere(key))
          .toList());
    } else {
      filterData.addAll(mUsers);
    }
    setState(() {});
  }

  void sortData() {
    mUsers.sort((a, b) => a.totalBalance.compareTo(b.totalBalance));
    //AppLog.e("Data:- ", mUsers.first.name.toString());
    setState(() {});
  }
  

  @override
  void initState() {
    super.initState();
    _searchController.addListener(doSearchListener);
    viewModel.userStream.listen((event) {
      mUsers.clear();
      filterData.clear();
      mUsers.addAll(event);
      filterData.addAll(mUsers);
      setState(() {});
    });
    viewModel.debitNoteTransferStream.listen((event) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: event.getMessage,
            actionText: "OK",
            isCancelable: false,
            onActionTap: () {
              // Navigator.pop(context);
              viewModel.requestMyUser();
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    });
    viewModel.requestMyUser();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputFieldWidget.text("${locale.search}",
                margin:
                    EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 6),
                enableColor: kColor11,
                focusColor: kColor11,
                textEditingController: _searchController,
                focusNode: _searchFocusNode,
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: RFontWeight.REGULAR,
                  color: kMainTextColor,
                  height: 1.5,
                ),
                hintStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: RFontWeight.REGULAR,
                  color: kHintColor,
                ),
                suffixAsset: IC_SEARCH_BLACK),
            Container(
              margin: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
                child: InkWell(
                onTap: (){
                  sortData();
                },
                child: Icon(Icons.sort, color: kColor11, size: 24),)),
            /*Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                  color: kMainColorTransparent,
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CUSTOMER",
                    style: TextStyle(
                        color: kMainColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 12),
                  ),
                  Text(
                    "WALLET BALANCE",
                    style: TextStyle(
                        color: kMainColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 12),
                  ),
                  */
            /*Text(
                    "DEBIT",
                    style: TextStyle(
                        color: kMainColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 12),
                  ),*/
            /*
                  Text(
                    "CREDIT",
                    style: TextStyle(
                        color: kMainColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.REGULAR,
                        fontSize: 12),
                  ),
                ],
              ),
            ),*/
            Expanded(
              child: ListView.builder(
                itemCount: filterData.length, //mData.length,
                itemBuilder: (context, index) =>
                    _itemBuilder(filterData[index],mWallet.values.first,locale),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _itemBuilder(MyUserDataModel user,var mWallet,var locale) {
    return Stack(children: [
      Container(
          height: 136,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: .5,
              ),
            ],
          ),
          child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user.name}",
                            //textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontWeight: RFontWeight.REGULAR,
                                fontSize: 14),
                          ),
                          Text(
                            "${user.mobile}",
                            style: TextStyle(
                                color: kMainTextColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontWeight: RFontWeight.LIGHT,
                                fontSize: 13),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${locale.balance}",
                            //textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontWeight: RFontWeight.REGULAR,
                                fontSize: 14),
                          ),
                          Text(
                            "${mWallet?.currencySign ?? ""} ${user.totalBalance}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontWeight: RFontWeight.BOLD),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 28,left: 0,top: 12),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      indent: 20,
                      endIndent: 0,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /*Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("Max Limit"),
            SizedBox(height: 3,),
            Text(user.RESPONSE_MAX_CREDIT_LIMIT.toString(),style: TextStyle(fontWeight: RFontWeight.BOLD),),
          ],),*/
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${locale.due}"),
                              SizedBox(height: 3,),
                              Text("${mWallet?.currencySign ?? ""} ${user.totalCredits.toString()}",style: TextStyle(fontWeight: RFontWeight.BOLD)),
                            ],),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${locale.availableLimit}"),
                              SizedBox(height: 3,),
                              Text("${mWallet?.currencySign ?? ""} ${user.RESPONSE_AVAILABLE_CREDIT_LIMIT.toString()}",style: TextStyle(fontWeight: RFontWeight.BOLD)),
                            ],)
                        ],)),
                ],),
      ),
      InkWell(
        onTap: () async {
          var dialog = DialogCreditTransferCredit(user);
          var amount = await showDialog(
              context: context, builder: (context) => dialog);
          if (amount != null) {
            AppLog.e("AMOUNT", amount);
            viewModel.requestTransfer(amount, user.walletId);
          }
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(top: 130),
          child: Image.asset(
            FORWARD_CIRCLE,
            width: 40,
            height: 40,
          ),

        ),)
    ],);
  }
}
