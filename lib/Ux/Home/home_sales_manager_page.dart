import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/DataBeans/BalanceDataModel.dart';
import 'package:twopa_sales_manager/Database/hive_boxes.dart';
import 'package:twopa_sales_manager/Database/models/balance.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_bottom_menu_item.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_helper.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Utils/firebase_node.dart';
import 'package:twopa_sales_manager/Ux/Home/home_drawer_menu.dart';
import 'package:twopa_sales_manager/Ux/Wallet/ViewModel/view_model_wallet.dart';
import 'package:twopa_sales_manager/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Locale/locales.dart';
import '../../Utils/app_decorations.dart';

class HomeSalesManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeSalesManagerBody();
  }
}

class HomeSalesManagerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeSalesManagerBodyState();
}

class _HomeSalesManagerBodyState
    extends BasePageState<HomeSalesManagerBody, ViewModelWallet> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var _wallet = HiveBoxes.getBalanceWallet();

  @override
  void initState() {
    super.initState();
    databaseReference
        .child(FirebaseNode.USERS)
        .child(mPreference.value.userData.firebaseId)
        .child(FirebaseNode.WALLET)
        .onValue
        .listen((data) {
      if (data.snapshot.value is Map) {
        var walletData = BalanceData.fromJson(toMaps(data.snapshot.value));
        final box = HiveBoxes.getBalance();
        box.put("BAL", walletData.toBalance);
      }
    });
    //viewModel.requestBalanceEnquiry();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Container(
        decoration: decorationBackground,
        child: Scaffold(
          key: scaffoldKey,
          /*appBar: AppBarDashboardWidget(
          scaffoldKey,
          elevation: 0,
        ),*/
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                if (scaffoldKey.currentState?.hasDrawer == true) {
                  if (scaffoldKey.currentState?.isDrawerOpen == true) {
                    Navigator.of(scaffoldKey.currentState!.context).pop();
                  } else {
                    scaffoldKey.currentState!.openDrawer();
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                width: 24,
                height: 24,
                child: Center(
                  child: Image.asset(
                    IC_MENU,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            title: Image.asset(
              LOGO,
              height: 33,
              fit: BoxFit.fitHeight,
            ),
          ),
          backgroundColor: kTransparentColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: kColor6,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                      color: kColor11,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(
                          "${locale.hiWelcome} ${mPreference.value.userData.name}",
                          style: TextStyle(
                            color: kWhiteColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontSize: 16,
                            fontWeight: RFontWeight.BOLD,
                          ),
                        ),
                        InkWell(onTap: (){
                            viewModel.requestBalanceEnquiry();
                          },
                            child: Icon(Icons.sync,color: kWhiteColor,),)
                      ],),),
                    SizedBox(
                    height: 20),
                    Stack(
                      children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        ValueListenableBuilder(
                            valueListenable:
                            HiveBoxes.getBalance().listenable(),
                            builder: (context, Box<Balance> data, _) {
                              var mWallet = data.values.isNotEmpty
                                  ? data.values.first
                                  : null;
                              return  Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    "${mWallet?.currencySign ?? ""} ${(mWallet?.balance ?? 0.0).toSeparatorFormat()}",
                                    style: TextStyle(
                                      color: kWhiteColor,
                                      fontFamily: RFontFamily.POPPINS,
                                      fontSize: 24,
                                      fontWeight: RFontWeight.BOLD,
                                    ),
                                  ),
                                );
                            }),
                        SizedBox(height: 3,),
                        Text(
                          "${locale.yourWalletBalance}",
                          style: TextStyle(
                            color: kWhiteColor,
                            fontFamily: RFontFamily.POPPINS,
                            fontSize: 14,
                            fontWeight: RFontWeight.REGULAR,
                          ),
                        ),
                      ],),
                      Align(alignment: Alignment.centerRight,
                      child:  Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kColor11,
                        ),
                        child: InkWell(onTap: (){
                          //viewModel.requestBalanceEnquiry();
                        },
                          child: Icon(Icons.wallet,color: kWhiteColor,size: 40,),),),)
                    ],),
                    Container(
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${locale.myDue}",
                              style: TextStyle(
                                color: kWhiteColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontSize: 18,
                                fontWeight: RFontWeight.BOLD,
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable:
                                HiveBoxes.getBalance().listenable(),
                                builder: (context, Box<Balance> data, _) {
                                  var mWallet = data.values.isNotEmpty
                                      ? data.values.first
                                      : null;
                                  return Flexible(
                                    flex: 1,
                                    child: Text(
                                      "${mWallet?.currencySign ?? ""} ${(mWallet?.dueCredits ?? 0.0).toSeparatorFormat()}",
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontFamily: RFontFamily.POPPINS,
                                        fontSize: 18,
                                        fontWeight: RFontWeight.BOLD,
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        )),
                    Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: kTextInputInactive,
                          ),
                        ),
                    Container(
                      margin: EdgeInsets.only(top: 10,bottom: 5),
                      child:Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${locale.customerDue}",
                              style: TextStyle(
                                color: kWhiteColor,
                                fontFamily: RFontFamily.POPPINS,
                                fontSize: 18,
                                fontWeight: RFontWeight.BOLD,
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable:
                                HiveBoxes.getBalance().listenable(),
                                builder: (context, Box<Balance> data, _) {
                                  var mWallet = data.values.isNotEmpty
                                      ? data.values.first
                                      : null;
                                  return Flexible(
                                    flex: 1,
                                    child: Text(
                                      "${mWallet?.currencySign ?? ""} ${(mWallet?.dueCustomerCredits ?? 0.0).toSeparatorFormat()}",
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontFamily: RFontFamily.POPPINS,
                                        fontSize: 18,
                                        fontWeight: RFontWeight.BOLD,
                                      ),
                                    ),
                                  );
                                }),

                          ],
                        )),
                  ],),),

                  /*SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 60,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, PageRoutes.myAgents);
                              },
                              child: Container(
                                height: 70,
                                margin: EdgeInsets.only(left: 16, right: 16, bottom: 0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                    color: kSecondTextColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: Stack(
                                  children: [
                                    Align(alignment: Alignment.centerRight,
                                      child: Icon(Icons.keyboard_arrow_right_sharp,color: kWhiteColor,),),
                                    Align(alignment: Alignment.centerLeft,
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.supervised_user_circle,color: kWhiteColor,),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "MY AGENTS",
                                            style: TextStyle(
                                              color: kWhiteColor,
                                              fontFamily: RFontFamily.POPPINS,
                                              fontSize: 14,
                                              fontWeight: RFontWeight.MEDIUM,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ) ,)
                                    ,],
                                ),

                              ),
                            ),
                          ),
                          */
                  /*Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageRoutes.memberShipPlan);
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 8, right: 16, bottom: 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  MEMBERSHIP_PLAN,
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(
                                    "MEMBERSHIP PLAN",
                                    style: TextStyle(
                                      color: kMainButtonColor,
                                      fontFamily: RFontFamily.POPPINS,
                                      fontSize: 14,
                                      fontWeight: RFontWeight.MEDIUM,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),*/
                  /*
                        ],
                      )
                  ),*/
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                   alignment: Alignment.center,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     InkWell(
                       onTap: () {
                         Navigator.pushNamed(
                             context, PageRoutes.creditTransfer);
                       },
                       child: Stack(
                           children:[
                             Container(
                           width: 150,
                           height: 150,
                           margin: EdgeInsets.only(left: 16, right: 16, bottom: 0),
                           padding: EdgeInsets.all(10),
                           decoration: BoxDecoration(
                               color: kMainButtonColor,
                               borderRadius:
                               BorderRadius.all(Radius.circular(100))),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Image.asset(
                                 SEND_CREDIT,
                                 width: 60,
                                 height: 60,
                               ),
                               SizedBox(
                                 height: 10,
                               ),
                               Text(
                                 "${locale.creditTransfer}",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   color: kWhiteColor,
                                   fontFamily: RFontFamily.POPPINS,
                                   fontSize: 16,
                                   fontWeight: RFontWeight.MEDIUM,
                                 ),
                               ),
                             ],
                           ),
                         ),
                             Container(
                               width: 180, height: 170,
                           alignment: Alignment.bottomCenter,
                           child: Container(
                             width: 40,
                             height: 40,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                                 color:  kTextAmountCR,
                                 borderRadius:
                                 BorderRadius.all(Radius.circular(100))),
                             child: Icon(Icons.arrow_forward_ios_rounded,color: kWhiteColor),),),
                           ]),

                     ),
                     InkWell(
                       onTap: () {
                         Navigator.pushNamed(
                             context, PageRoutes.cashCollection);
                       },
                       child:Stack(
                           children:[
                             Container(
                         width: 150,
                         height: 150,
                         margin: EdgeInsets.only(left: 16, right: 16, bottom: 0),
                         padding: EdgeInsets.all(10),
                         decoration: BoxDecoration(
                             color: kMainButtonColor,
                             borderRadius:
                             BorderRadius.all(Radius.circular(100))),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Image.asset(
                               COLLECT_CREDIT,
                               width: 60,
                               height: 60,
                             ),
                             SizedBox(
                               height: 10,
                             ),
                            Text(
                                 "${locale.creditCollection}",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   color: kWhiteColor,
                                   fontFamily: RFontFamily.POPPINS,
                                   fontSize: 16,
                                   fontWeight: RFontWeight.MEDIUM,
                                 ),
                               ),
                           ],
                         ),
                       ),
                             Container(
                       width: 180, height: 170,
                       alignment: Alignment.bottomCenter,
                       child: Container(
                         width: 40,
                         height: 40,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                             color:  kTextAmountCR,
                             borderRadius:
                             BorderRadius.all(Radius.circular(100))),
                         child: Icon(Icons.arrow_forward_ios_rounded,color: kWhiteColor),),),
                   ]),
                     ),
                   ],
                 ),),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageRoutes.customersList);
                            },
                            child: Stack(
                                children:[
                                  Container(
                              width: 150,
                              height: 150,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 16, right: 16, bottom: 0),
                              padding: EdgeInsets.all(
                                 10),
                              decoration: BoxDecoration(
                                  color: kMainButtonColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    MANAGE_USERS,
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "${locale.myCustomer}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontFamily: RFontFamily.POPPINS,
                                        fontSize: 16,
                                        fontWeight: RFontWeight.MEDIUM,
                                      ),
                                    ),

                                ],
                              ),
                            ),
                                  Container(
                        width: 180, height: 170,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color:  kTextAmountCR,
                              borderRadius:
                              BorderRadius.all(Radius.circular(100))),
                          child: Icon(Icons.arrow_forward_ios_rounded,color: kWhiteColor),),),
                      ]),
                          ),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, PageRoutes.reports);
                            },

                            child: Stack(
                                children:[
                                  Container(
                              width: 150,
                              height: 150,
                              alignment: Alignment.center,
                              margin:
                              EdgeInsets.only(left: 16, right: 16, bottom: 0),
                              padding: EdgeInsets.all(
                                  10),
                              decoration: BoxDecoration(
                                  color: kMainButtonColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    TXN,
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "${locale.summaryReport}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontFamily: RFontFamily.POPPINS,
                                        fontSize: 16,
                                        fontWeight: RFontWeight.MEDIUM,
                                      ),
                                    ),

                                ],
                              ),
                            ),
                                  Container(
                              width: 180, height: 170,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color:  kTextAmountCR,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                                child: Icon(Icons.arrow_forward_ios_rounded,color: kWhiteColor),),),
                            ]),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: DrawerMenu(),
        ),
      ),
    );
  }
}