import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/DataBeans/CreditResponseDataModel.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/my_user.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Ux/CashCollection/ViewModel/view_model_cash_collection.dart';
import 'package:intl/intl.dart';

import '../../BaseClasses/base_state.dart';
import '../../Locale/locales.dart';
import '../../Theme/colors.dart';
import '../../Utils/Enum/enum_r_font_family.dart';
import '../../Utils/Enum/enum_r_font_weight.dart';
import '../../Utils/app_style_text.dart';

class CashCollectionCollectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CashCollectionCollectedBody();
  }
}

class CashCollectionCollectedBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CashCollectionCollectedBodyState();
}

class _CashCollectionCollectedBodyState extends BasePageState<
    CashCollectionCollectedBody, ViewModelCashCollection> {
  var mUsers = HiveBoxes.getMyUsers().values;
  var defaultUser =
      MyUser(id: "", name: "Select Customer(Default: All Customers)");
  List<MyUser> users = [];
  late String fromDate = "", toDate = "";
  late MyUser mSelectedUser;

  CreditResponseModel mCreditData = CreditResponseModel();

  @override
  void initState() {
    users.addAll(mUsers.toList());
    mSelectedUser = defaultUser;
    if (!users.contains(defaultUser)) {
      users.insert(0, defaultUser);
    }
    super.initState();
    viewModel.creditStream.listen((event) {
      mCreditData = event;
      setState(() {});
    });
    apiCall();
  }

  apiCall() {
    viewModel.requestCreditCollect(mSelectedUser.id, "$fromDate", "$toDate");
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      child: Scaffold(
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
                  child: DropdownButton<MyUser>(
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
                    },
                    items: users.map<DropdownMenuItem<MyUser>>((MyUser value) {
                      return DropdownMenuItem<MyUser>(
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
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.maxFinite,
                      height: 36,
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
                            fromDate =
                                DateFormat("yyyy-MM-dd").format(dateTime);
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
                      height: 36,
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
                margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "${locale.reportFor} : ${mSelectedUser.id.isNotEmpty ? mSelectedUser.name : "All"}",
                        style: TextStyle(
                          color: kColor11,
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
                          color: kColor11,
                          border: Border.all(width: .5, color: kTextColor4),
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
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: kColor8.withOpacity(.15),
                  border: Border.all(width: .5, color: kColor8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${locale.totalCollection}",
                      style: TextStyle(
                          color: kColor8,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.BOLD,
                          fontSize: 18),
                    ),
                    Text(
                      "${mCreditData.total}",
                      style: TextStyle(
                          color: kColor8,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: kColor8.withOpacity(.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        "CUSTOMER",
                        style: TextStyle(
                            color: kColor8,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "DATE",
                        style: TextStyle(
                            color: kColor8,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "AMOUNT",
                        style: TextStyle(
                            color: kColor8,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: mCreditData.data.length,
                  itemBuilder: (context, index) =>
                      _itemWidget(mCreditData.data[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemWidget(CreditDataModel item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.name}",
                        style: TextStyle(
                            color: kMainTextColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 16),
                      ),
                      Text(
                        "${item.type}",
                        style: TextStyle(
                            color: kColor8,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.REGULAR,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.date.getTime()}",
                        //textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: kColor7,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 14),
                      ),
                      Text(
                        "${item.date.getDate()}",
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
                  flex: 2,
                  child: Text(
                    "${item.amount}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: kMainColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.MEDIUM,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

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
