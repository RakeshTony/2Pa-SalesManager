import 'dart:collection';
import 'dart:convert';
import 'package:collection/src/iterable_extensions.dart';

import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/DataBeans/MemberPlanCommissionResponseDataModel.dart';
import 'package:twopa_sales_manager/DataBeans/UserRanksPlansDataModel.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_success.dart';
import 'package:twopa_sales_manager/Ux/MemberShipPlan/ViewModel/view_model_member_ship_plan.dart';

import '../../BaseClasses/base_state.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';
import '../../Utils/Widgets/input_field_widget.dart';
import '../../Utils/app_action.dart';
import '../../Utils/app_log.dart';

class MemberShipPlanCommissionPage extends StatelessWidget {
  final PlansData plansData;

  MemberShipPlanCommissionPage({required this.plansData});

  @override
  Widget build(BuildContext context) {
    return MemberShipPlanCommissionPageBody(plansData);
  }
}

class MemberShipPlanCommissionPageBody extends StatefulWidget {
  final PlansData plansData;

  MemberShipPlanCommissionPageBody(this.plansData);

  @override
  State<StatefulWidget> createState() =>
      _MemberShipPlanCommissionPageBodyState();
}

class _MemberShipPlanCommissionPageBodyState extends BasePageState<
    MemberShipPlanCommissionPageBody, ViewModelMemberShipPlan> {
  List<MemberPlanCommissionDataModel> mOperators =
      List<MemberPlanCommissionDataModel>.empty(growable: true);
  List<PlanItemWidget> mForm = List<PlanItemWidget>.empty(growable: true);
  int mSelectedOperatorIndex = -1;
  MemberPlanCommissionDataModel? mSelectedOperator;
  bool status = false;

  @override
  void initState() {
    super.initState();
    viewModel.requestPlansDetails(widget.plansData.id);

    viewModel.responseStream.listen((event) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: event.getMessage,
            actionText: "Continue",
            isCancelable: false,
            onActionTap: () {
              viewModel.requestPlansDetails(widget.plansData.id);
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    });

    viewModel.commissionStream.listen((event) {
      mOperators.clear();
      mOperators.addAll(event.operators);
      setSelectedIndex(mOperators.firstOrNull == null ? -1 : 0);
    });
  }

  void setSelectedIndex(int index) {
    if (index >= 0 && index < mOperators.length) {
      mSelectedOperatorIndex = index;
      mSelectedOperator = mOperators[index];
      status = mSelectedOperator?.status ?? false;
      mForm.clear();
      mSelectedOperator?.denominations.forEach((element) {
        mForm.add(PlanItemWidget(element));
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommonTitleWidget(
          backgroundColor: kMainColor,
          title: widget.plansData.name.toUpperCase(),
          isShowNotification: false),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Visibility(
          visible: mSelectedOperator != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        status = !status;
                        setState(() {});
                      },
                      child: Icon(
                          status
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank,
                          color: kMainColor),
                    ),
                    SizedBox(width: 10,),
                    Text(mSelectedOperator?.operatorTitle ?? "",
                        style: TextStyle(
                            color: kMainTextColor,
                            fontSize: 16,
                            fontWeight: RFontWeight.BOLD,
                            fontFamily: RFontFamily.SOFIA_PRO)),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (mSelectedOperatorIndex > 0) {
                          setSelectedIndex(mSelectedOperatorIndex - 1);
                        }
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: kMainColor.withOpacity(
                            (mSelectedOperatorIndex == 0) ? 0.3 : 1.0),
                        size: 30,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: 50,
                          minHeight: 50,
                          maxHeight: 50,
                          minWidth: 50),
                      child: Image.network(
                          mSelectedOperator?.operatorLogo ?? "",
                          width: 50,
                          height: 50),
                    ),
                    InkWell(
                      onTap: () {
                        if (mSelectedOperatorIndex < mOperators.length - 1) {
                          setSelectedIndex(mSelectedOperatorIndex + 1);
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: kMainColor.withOpacity(
                            (mSelectedOperatorIndex == mOperators.length - 1)
                                ? 0.3
                                : 1.0),
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: kMainColor.withOpacity(.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "PRODUCT",
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
                        "COST",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kMainColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.BOLD,
                            fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: Text(
                        "SEALING RATE",
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
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: ListView.builder(
                    itemCount: mForm.length,
                    itemBuilder: (context, index) => mForm[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: mSelectedOperator != null,
        child: InkWell(
          onTap: () {
            var error = "";
            var mOperators = [];
            var operator = HashMap();
            operator["id"] = mSelectedOperator?.operatorId ?? "";
            operator["commission"] = mSelectedOperator?.commission ?? "";
            operator["status"] = status ? "1" : "0";
            mOperators.add(operator);
            var mDenominations = [];
            for (int index = 0; index < mForm.length; index++) {
              var field = mForm[index];
              var denominations = HashMap();
              var sellingRate = field.getText();
              if (sellingRate.isNotEmpty) {
                denominations["id"] = field.getId().toString();
                denominations["commission"] = sellingRate;
                denominations["status"] = field.status ? "1" : "0";
                mDenominations.add(denominations);
              }
              error = field.getErrorMessage() ?? "";
              if (error.isNotEmpty) {
                AppAction.showGeneralErrorMessage(context, error);
                break;
              }
            }
            var requestDataOperators = jsonEncode(mOperators);
            var requestDataDenominations = jsonEncode(mDenominations);
            if (error.isNotEmpty) {
              AppAction.showGeneralErrorMessage(context, error);
            } else {
              viewModel.savePlanCommission(widget.plansData.id,requestDataOperators,requestDataDenominations);
            }
          },
          child: Container(
            decoration: new BoxDecoration(
                color: kMainColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            margin: EdgeInsets.all(8),
            child: Text("SAVE " + widget.plansData.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 16,
                    fontWeight: RFontWeight.BOLD,
                    fontFamily: RFontFamily.SOFIA_PRO)),
          ),
        ),
      ),
    );
  }
}

class PlanItemWidget extends StatefulWidget {
  final MemberPlanDenominationModel item;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool status = false;

  PlanItemWidget(this.item) {
    status = item.status;
    _textEditingController.text = item.commission.toString();
  }

  bool getStatus() {
    return status;
  }

  String getId() {
    return item.id;
  }

  String getText() {
    return _textEditingController.text.toString().trim();
  }

  getErrorMessage() {
    if (_textEditingController.text.toString().trim().isEmpty)
      return "Please Enter Selling Rate";
    var mRateText = _textEditingController.text.toString().trim();
    if (isNumeric(mRateText)) {
      var rate = toDouble(mRateText);
      if (rate >= item.myCommission && rate <= item.maxCommission) {
        return null;
      } else {
        return "Please Enter Selling Rate in range";
      }
    } else {
      return "Please Enter Valid Amount";
    }
    return null;
  }

  @override
  State<PlanItemWidget> createState() => _PlanItemWidgetState();
}

class _PlanItemWidgetState extends State<PlanItemWidget> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0, bottom: 10, top: 0, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      widget.status = !widget.status;
                      setState(() {});
                    },
                    child: Icon(
                        widget.status
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank,
                        color: kMainColor),
                  ),
                  Flexible(
                    child: Text(
                      widget.item.title,
                      style: TextStyle(
                          color: kTextColor3,
                          fontFamily: RFontFamily.POPPINS,
                          fontWeight: RFontWeight.REGULAR,
                          fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Text(
                widget.item.myCommission.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: kMainColor,
                    fontFamily: RFontFamily.POPPINS,
                    fontWeight: RFontWeight.BOLD,
                    fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 90,
                  height: 40,
                  child: TextField(
                    controller: widget._textEditingController,
                    focusNode: widget._focusNode,
                    keyboardType: TextInputType.number,
                    cursorColor: kMainColor,
                    style: TextStyle(color: kMainColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 2),
                  child: Row(
                    children: [
                      Text(
                        "Max Rate: ${widget.item.maxCommission}",
                        style: TextStyle(
                            color: kTextColor3,
                            fontFamily: RFontFamily.POPPINS,
                            fontWeight: RFontWeight.REGULAR,
                            fontSize: 10),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
