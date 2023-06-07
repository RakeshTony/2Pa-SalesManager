import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';

import '../../DataBeans/MyUserResponseDataModel.dart';
import '../../Locale/locales.dart';
import '../../Utils/Widgets/AppImage.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';
import '../../Utils/Widgets/input_field_widget.dart';
import 'ViewModel/view_model_customer.dart';

class CustomersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomersBody();
  }
}

class CustomersBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomersBodyState();
}

class _CustomersBodyState
    extends BasePageState<CustomersBody, ViewModelCustomers> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  List<MyUserDataModel> mUsers = List<MyUserDataModel>.empty(growable: true);
  List<MyUserDataModel> filterData = [];

  void doSearchListener() {
    var key = _searchController.text;
    if (filterData.isNotEmpty) filterData.clear();
    if (key.isNotEmpty) {
      filterData.addAll(
          mUsers.where((element) => element.name.searchAnyWhere(key)).toList());
    } else {
      filterData.addAll(mUsers);
    }
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
    viewModel.requestMyUser();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarCommonTitleWidget(
          backgroundColor: kMainColor,
          title: "${locale.myCustomer}".toUpperCase(),
          isShowNotification: false),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 220),
                  decoration: new BoxDecoration(
                      color: kColor6,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                      onTap: () async {
                        var status = await Navigator.pushNamed(
                            context, PageRoutes.customerAddEdit,
                            arguments: new MyUserDataModel());
                        if (status == "RELOAD") {
                          viewModel.requestMyUser();
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: kWhiteColor,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "${locale.addNewCustomer}",
                            style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: RFontWeight.BOLD),
                          )
                        ],
                      )),
                ),
              ),
            ),
            InputFieldWidget.text("${locale.searchByName}",
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
            Expanded(
              child: ListView.builder(
                itemCount: filterData.length, //mData.length,
                itemBuilder: (context, index) => _itemWidget(filterData[index]),
              ),
            )
          ],
        ),
      ),
    );
  }

  _itemWidget(MyUserDataModel user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kColor6,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImage(
            "data.userData.icon",
            72,
            defaultImage: DEFAULT_PERSON,
          ),
          SizedBox(width: 10,),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  user.name,
                  //textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: kWhiteColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.BOLD,
                      fontSize: 18),
                ),
                Text(
                  user.mobile,
                  style: TextStyle(
                      color: kWhiteColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.LIGHT,
                      fontSize: 14),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                      color: kWhiteColor,
                      fontFamily: RFontFamily.POPPINS,
                      fontWeight: RFontWeight.LIGHT,
                      fontSize: 14),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              var status = await Navigator.pushNamed(
                  context, PageRoutes.customerAddEdit,
                  arguments: user);
              if (status == "RELOAD") {
                viewModel.requestMyUser();
              }
            },
            child: Container(
              decoration: new BoxDecoration(
                color: kColor11,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.edit_outlined,
                color: kWhiteColor,
              ),
            ),
          ),
        ],
      ),
        Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10),
            child: const Divider(
              height: 1,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: kTextInputInactive,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              user.totalBalance.toString(),
              //textAlign: TextAlign.justify,
              style: TextStyle(
                  color: kWhiteColor,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.BOLD,
                  fontSize: 24),
            ),
            Text(
              "Avail. Balance",
              style: TextStyle(
                  color: kWhiteColor,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.LIGHT,
                  fontSize: 14),
            ),
          ],),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            Text(
              user.totalCredits.toString(),
              //textAlign: TextAlign.justify,
              style: TextStyle(
                  color: kWhiteColor,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.BOLD,
                  fontSize: 24),
            ),
            Text(
              "Due Balance",
              style: TextStyle(
                  color: kWhiteColor,
                  fontFamily: RFontFamily.POPPINS,
                  fontWeight: RFontWeight.LIGHT,
                  fontSize: 14),
            ),
          ],),

        ],)
      ],),
    );
  }
}
