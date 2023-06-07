import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_style_text.dart';
import 'package:twopa_sales_manager/Ux/Wallet/ViewModel/view_model_wallet.dart';
import 'package:intl/intl.dart';
import '../../BaseClasses/base_state.dart';
import '../../DataBeans/MyUserResponseDataModel.dart';
import '../../DataBeans/WalletStatementResponseDataModel.dart';
import '../../Locale/locales.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';

class WalletTransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WalletTransactionPageBody();
  }
}

class WalletTransactionPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WalletTransactionPageBodyState();
}

class _WalletTransactionPageBodyState
    extends BasePageState<WalletTransactionPageBody, ViewModelWallet> {
  var defaultUser = MyUserDataModel(id: "", name: "Select Customer");
  List<MyUserDataModel> users = [];
  late String fromDate = "", toDate = "";
  var defaultTransactionType = "Transaction Type";
  var mSelectedTransactionType = "Transaction Type";
  List<String> mTransactionType = [
    "Transaction Type",
    'Wallet Topup',
    'Recharge',
    'Profit',
    'IssuedEpin',
    'Payout'
  ];
  late MyUserDataModel mSelectedUser;

  getSelectedType() {
    switch (mSelectedTransactionType) {
      case "Transaction Type":
        return "";
      case "Wallet Topup":
        return "Transfer";
      case "IssuedEpin":
        return "IssueEpin";
      default:
        return mSelectedUser;
    }
  }

/*
  var _fromDate = DateTime.now();
  var _toDate = DateTime.now();
  var _initialDate = DateTime.now();
*/

  @override
  void initState() {
    mSelectedUser = defaultUser;
    if (!users.contains(defaultUser)) {
      users.insert(0, defaultUser);
    }
    super.initState();
    viewModel.userStream.listen((event) {
      users.addAll(event);
      setState(() {});
    });
    // _setDateTime();
    viewModel.requestMyUser();
    apiCall();
  }

  apiCall() {
    viewModel.requestWallet(
        mSelectedUser.id, fromDate, toDate, getSelectedType());
  }

/*

  _setInitialDate() {
    if (_initialDate.isBefore(_fromDate)) {
      _initialDate = _fromDate;
      _initialDate.add(Duration(days: 1));
    } else if (_initialDate.isAfter(_toDate)) {
      _initialDate = _toDate;
      _initialDate.subtract(Duration(days: 1));
    }
  }

  _setDateTime() {
    _setInitialDate();
    setState(() {
      fromDate = _fromDate.getDate();
      toDate = _toDate.getDate();
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarCommonTitleWidget(
          backgroundColor: kMainColor,
          title: "${locale.walletTransaction}",
          isShowNotification: false),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kTextColor4.withOpacity(.15),
                border: Border.all(width: .5, color: kTextColor4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MyUserDataModel>(
                  value: mSelectedUser,
                  icon: Icon(Icons.arrow_drop_down, color: kColor7),
                  isExpanded: true,
                  iconSize: 24,
                  elevation: 16,
                  isDense: true,
                  style: AppStyleText.inputFiledDropDownText,
                  onChanged: (data) {
                    setState(() {
                      mSelectedUser = data!;
                    });
                    // apiCall();
                  },
                  items: users.map<DropdownMenuItem<MyUserDataModel>>(
                      (MyUserDataModel value) {
                    return DropdownMenuItem<MyUserDataModel>(
                      value: value,
                      child: Text(
                        value.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kColor7,
                          fontSize: 14,
                          fontWeight: RFontWeight.BOLD,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kTextColor4.withOpacity(.15),
                border: Border.all(width: .5, color: kTextColor4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: mSelectedTransactionType,
                  icon: Icon(Icons.arrow_drop_down, color: kColor7),
                  isExpanded: true,
                  iconSize: 24,
                  elevation: 16,
                  isDense: true,
                  style: AppStyleText.inputFiledDropDownText,
                  onChanged: (data) {
                    setState(() {
                      mSelectedTransactionType = data!;
                    });
                    // apiCall();
                  },
                  items: mTransactionType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kColor7,
                          fontSize: 14,
                          fontWeight: RFontWeight.BOLD,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: 16, right: 06, top: 16),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: kTextColor4.withOpacity(.15),
                      border: Border.all(width: .5, color: kTextColor4),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        var dateTime = await _pickFromDate(context);
                        if (dateTime != null) {
                          fromDate = DateFormat("yyyy-MM-dd").format(dateTime);
                          setState(() {});
                          // apiCall();
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.date_range, size: 24, color: kColor7),
                          Expanded(
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                    text: "${locale.from}",
                                    style: TextStyle(
                                      color: kColor7,
                                      fontSize: 14,
                                      fontWeight: RFontWeight.BOLD,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "\n$fromDate",
                                        style: TextStyle(
                                          color: kColorPending,
                                          fontSize: 12,
                                          fontWeight: RFontWeight.LIGHT,
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: fromDate.isNotEmpty,
                            child: InkWell(
                              onTap: () {
                                fromDate = "";
                                setState(() {});
                                // apiCall();
                              },
                              child:
                                  Icon(Icons.close, size: 24, color: kColor7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: 06, right: 16, top: 16),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: kTextColor4.withOpacity(.15),
                      border: Border.all(width: .5, color: kTextColor4),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        var dateTime = await _pickToDate(context);
                        if (dateTime != null) {
                          toDate = DateFormat("yyyy-MM-dd").format(dateTime);
                          setState(() {});
                          // apiCall();
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.date_range, size: 24, color: kColor7),
                          Expanded(
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                    text: "${locale.to}",
                                    style: TextStyle(
                                      color: kColor7,
                                      fontSize: 14,
                                      fontWeight: RFontWeight.BOLD,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "\n$toDate",
                                        style: TextStyle(
                                          color: kColorPending,
                                          fontSize: 12,
                                          fontWeight: RFontWeight.LIGHT,
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: toDate.isNotEmpty,
                            child: InkWell(
                              onTap: () {
                                toDate = "";
                                setState(() {});
                                // apiCall();
                              },
                              child:
                                  Icon(Icons.close, size: 24, color: kColor7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 16,top: 16,right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "${locale.reportFor} : ${mSelectedUser.id.isNotEmpty ? mSelectedUser.name : "All"}",
                      style: TextStyle(
                        color: kColor6,
                        fontSize: 16,
                        fontWeight: RFontWeight.BOLD,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      apiCall();
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: kColor6,
                        border: Border.all(width: .5, color: kColor6),
                      ),
                      child: Text(
                        "${locale.search}",
                        style: TextStyle(color: kMainColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            /*Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => _itemWidget(),
              ),
            ),*/
            Expanded(
              child: StreamBuilder(
                stream: viewModel.responseStream,
                initialData:
                    List<WalletStatementDataModel>.empty(growable: true),
                builder: (context,
                    AsyncSnapshot<List<WalletStatementDataModel>> snapshot) {
                  var items =
                      List<WalletStatementDataModel>.empty(growable: true);
                  if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data ?? [];
                    for (WalletStatementDataModel item in data) {
                      items.add(item);
                    }
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => _itemWidget(items[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _itemWidget(WalletStatementDataModel data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: .1,
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             /* Expanded(
                child: Text(
                  data.user,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.BOLD,
                      fontSize: 16),
                ),
              ),*/
              Expanded(
                flex: 4,
                child: Text(
                  data.type,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.BOLD,
                      fontSize: 16),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  data.created,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.REGULAR,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Opening",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: kColor7,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.BOLD,
                          fontSize: 14),
                    ),
                    Text(
                      data.openBal.toString(),
                      style: TextStyle(
                          color: kColor7.withOpacity(.7),
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.LIGHT,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: kColor7,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.BOLD,
                          fontSize: 14),
                    ),
                    Text(
                      data.amount.toString(),
                      style: TextStyle(
                          color: kColor7.withOpacity(.7),
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.LIGHT,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Closing",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: kColor7,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.BOLD,
                          fontSize: 14),
                    ),
                    Text(
                      data.closeBal.toString(),
                      style: TextStyle(
                          color: kColor7.withOpacity(.7),
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.LIGHT,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            data.narration,
            style: TextStyle(
                color: kColor7.withOpacity(.7),
                fontFamily: RFontFamily.POPPINS,
                fontWeight: RFontWeight.LIGHT,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  /* Future<DateTime?> _pickFromDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(2021),
      lastDate: _toDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ??
              Container(
                width: 0,
                height: 0,
              ),
        );
      },
    );
  }

  Future<DateTime?> _pickToDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: _fromDate,
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ??
              Container(
                width: 0,
                height: 0,
              ),
        );
      },
    );
  }*/
  Future<DateTime?> _pickFromDate(BuildContext context) {
    var mToDate = DateTime.now();
    var mInitialDate = DateTime.now();
    if (mInitialDate.isAfter(mToDate)) {
      mInitialDate = mToDate;
      mInitialDate.subtract(Duration(days: 1));
    }
    return showDatePicker(
      context: context,
      initialDate: mInitialDate,
      firstDate: DateTime(2021),
      lastDate: mToDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ??
              Container(
                width: 0,
                height: 0,
              ),
        );
      },
    );
  }

  Future<DateTime?> _pickToDate(BuildContext context) {
    var mFromDate = DateTime(2021);
    var mInitialDate = DateTime.now();
    if (mInitialDate.isBefore(mFromDate)) {
      mInitialDate = mFromDate;
      mInitialDate.add(Duration(days: 1));
    }
    return showDatePicker(
      context: context,
      initialDate: mInitialDate,
      firstDate: mFromDate,
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ??
              Container(
                width: 0,
                height: 0,
              ),
        );
      },
    );
  }
}
