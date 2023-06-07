import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/DataBeans/SalesOperatorDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/SalesReportDataModel.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/my_user.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/app_style_text.dart';
import 'package:twopa_sales_manager/Ux/Reports/ViewModel/view_model_sales_report.dart';
import 'package:intl/intl.dart';
import '../../BaseClasses/base_state.dart';
import '../../Locale/locales.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';

class SalesReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SalesReportsPageBody();
  }
}

class SalesReportsPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SalesReportsPageBodyState();
}

class _SalesReportsPageBodyState
    extends BasePageState<SalesReportsPageBody, ViewModelSalesReport> {
  var mUsers = HiveBoxes.getMyUsers().values;
  var defaultUser = MyUser(id: "", name: "Select User");
  List<MyUser> users = [];
  late MyUser mSelectedUser;

  var defaultOperator = SalesOperatorData(id: "", title: "Select Operator");
  List<SalesOperatorData> mOperators = [];
  late String fromDate = "", toDate = "";

  late SalesOperatorData mSelectedOperator;
  SalesReportDataModel _data = SalesReportDataModel();

  @override
  void initState() {
    users.addAll(mUsers.toList());
    mSelectedUser = defaultUser;
    if (!users.contains(defaultUser)) {
      users.insert(0, defaultUser);
    }
    mSelectedOperator = defaultOperator;
    super.initState();

    viewModel.responseStream.listen((event) {
      _data = event;
      setState(() {});
    });
    viewModel.operatorsStream.listen((event) {
      mOperators.clear();
      mOperators.addAll(event);
      setState(() {});
    });
    viewModel.requestOperators();
    apiCall();
  }

  apiCall() {
    viewModel.requestSalesReport(
        mSelectedUser.id, fromDate, toDate, mSelectedOperator.id);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    if (!mOperators.contains(defaultOperator)) {
      mOperators.insert(0, defaultOperator);
    }
    return Scaffold(
      appBar: AppBarCommonTitleWidget(
          backgroundColor: kMainColor,
          title: "${locale.salesReport}",
          isShowNotification: false),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      // apiCall();
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
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: kTextColor4.withOpacity(.15),
                  border: Border.all(width: .5, color: kTextColor4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SalesOperatorData>(
                    value: mSelectedOperator,
                    icon: Icon(Icons.arrow_drop_down, color: kColor7),
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    isDense: true,
                    style: AppStyleText.inputFiledDropDownText,
                    onChanged: (data) {
                      setState(() {
                        mSelectedOperator = data!;
                      });
                      // apiCall();
                    },
                    items: mOperators.map<DropdownMenuItem<SalesOperatorData>>(
                        (SalesOperatorData value) {
                      return DropdownMenuItem<SalesOperatorData>(
                        value: value,
                        child: Text(
                          value.title,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: kMainTextColor.withOpacity(.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${locale.products}",
                        style: TextStyle(
                            color: kMainTextColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${locale.quantity}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: kMainTextColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${locale.amountCaps}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: kMainTextColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: ListView.builder(
                  controller: ScrollController(),
                  shrinkWrap: true,
                  itemCount: _data.report.productData.length,
                  itemBuilder: (context, index) =>
                      _itemWidget(_data.report.productData[index]),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: kMainTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${_data.report.totalQuantity}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontWeight: RFontWeight.BOLD,
                                fontSize: 12),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${_data.report.totalAmount}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontWeight: RFontWeight.BOLD,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemWidget(SalesReportProductData item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "${item.title}",
              style: TextStyle(
                  color: kTextColor3,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.BOLD,
                  fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${item.quantity}",
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: kMainColor,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.BOLD,
                  fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${item.amount}",
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: kMainColor,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.BOLD,
                  fontSize: 12),
            ),
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
