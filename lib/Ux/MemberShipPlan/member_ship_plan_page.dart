import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_family.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Ux/MemberShipPlan/ViewModel/view_model_member_ship_plan.dart';

import '../../BaseClasses/base_state.dart';
import '../../DataBeans/UserRanksPlansDataModel.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_title_widget.dart';
import '../../Utils/app_action.dart';
import '../../Utils/app_log.dart';

class MemberShipPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MemberShipPlanPageBody();
  }
}

class MemberShipPlanPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemberShipPlanPageBodyState();
}

class _MemberShipPlanPageBodyState
    extends BasePageState<MemberShipPlanPageBody, ViewModelMemberShipPlan> {
  List<PlansData> itemsPlans = [];

  @override
  void initState() {
    super.initState();
    viewModel.requestPlansList();
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommonTitleWidget(
          backgroundColor: kMainColor,
          title: "Price Plan".toUpperCase(),
          isShowNotification: false),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 170),
                    decoration: new BoxDecoration(
                        color: kMainColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: kWhiteColor,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        InkWell(
                            onTap: (){
                              var data = Map<String, dynamic>();
                              data["planData"] = new PlansData();
                              Navigator.pushNamed(context, PageRoutes.memberShipPlanAddEdit,arguments: data);
                            },
                            child:Text(
                          "ADD NEW PLAN",
                          style: TextStyle(
                              color: kWhiteColor, fontWeight: RFontWeight.BOLD),
                        )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: viewModel.plansStream,
                initialData: List<PlansData>.empty(growable: true),
                builder: (context, AsyncSnapshot<List<PlansData>> snapshot) {
                  var items = List<PlansData>.empty(growable: true);
                  if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data ?? [];
                    for (PlansData item in data) {
                      items.add(item);
                    }
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        _itemWidget(items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _itemWidget(PlansData plansData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          new BoxShadow(
            color: kColor8,
            blurRadius: .5,
          ),
        ],
      ),
      child: ListTile(
        title: Text(plansData.name,
            style: TextStyle(
                color: kMainColor,
                fontSize: 16,
                fontWeight: RFontWeight.MEDIUM,
                fontFamily: RFontFamily.SOFIA_PRO)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){
                var data = Map<String, dynamic>();
                data["planData"] = plansData;
                Navigator.pushNamed(context, PageRoutes.memberShipPlanCommission,arguments: data);
              },
              child: Container(
                decoration: new BoxDecoration(
                    color: kMainColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text("COMMISSION".toUpperCase(),
                    style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 12,
                        fontWeight: RFontWeight.REGULAR,
                        fontFamily: RFontFamily.SOFIA_PRO)),
              ),
            ),
            SizedBox(width: 8,),
            InkWell(
              onTap: (){
                var data = Map<String, dynamic>();
                data["planData"] = plansData;
                Navigator.pushNamed(context, PageRoutes.memberShipPlanAddEdit,arguments: data);
              },
              child: Container(
                decoration: new BoxDecoration(
                    color: kMainColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text("EDIT".toUpperCase(),
                    style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 12,
                        fontWeight: RFontWeight.REGULAR,
                        fontFamily: RFontFamily.SOFIA_PRO)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
