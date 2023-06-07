import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/DataBeans/WalletStatementResponseDataModel.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Ux/Agent/ViewModel/view_model_agent.dart';
import '../../BaseClasses/base_state.dart';
import '../../DataBeans/MyUserResponseDataModel.dart';
import '../../Routes/routes.dart';
import '../../Theme/colors.dart';
import '../../Utils/Enum/enum_r_font_family.dart';
import '../../Utils/Enum/enum_r_font_weight.dart';
import '../Dialog/dialog_success.dart';

class AgentActivePage extends StatelessWidget {
  final bool isActiveUser;

  AgentActivePage(this.isActiveUser);

  @override
  Widget build(BuildContext context) {
    return AgentActiveBody(isActiveUser);
  }
}

class AgentActiveBody extends StatefulWidget {
  final bool isActiveUser;

  @override
  State<StatefulWidget> createState() => _AgentActiveBodyState();

  AgentActiveBody(this.isActiveUser);
}

class _AgentActiveBodyState
    extends BasePageState<AgentActiveBody, ViewModelAgent> {
  var defaultUser =
      UserItem(id: "", name: "Select Customer(Default: All Customers)");
  List<UserItem> users = [UserItem(id: "101", name: "name")];
  late String fromDate = "", toDate = "";
  late UserItem mSelectedUser;
  TextEditingController _searchController = TextEditingController();
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
    mSelectedUser = defaultUser;
    if (!users.contains(defaultUser)) {
      users.insert(0, defaultUser);
    }
    super.initState();
    _searchController.addListener(doSearchListener);
    viewModel.userStream.listen((event) {
      mUsers.clear();
      filterData.clear();
      mUsers.addAll(
          event.where((element) => element.status == widget.isActiveUser));
      filterData.addAll(mUsers);
      setState(() {});
    });
    viewModel.responseStream.listen((map) {
      if (mounted) {
        var dialog = DialogSuccess(
            title: "Success",
            message: map.getMessage,
            actionText: "Continue",
            isCancelable: false,
            onActionTap: () {
              if(mUsers.length==1){
                mUsers.clear();
                filterData.clear();
                setState(() {});
              }
              apiCall();
            });
        showDialog(context: context, builder: (context) => dialog);
      }
    }, cancelOnError: false);
    apiCall();
  }

  apiCall() {
    viewModel.requestAgents(widget.isActiveUser ? "1" : "0");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 170),
                    decoration: new BoxDecoration(
                        color: kColor8,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                        onTap: () async {
                          var status = await Navigator.pushNamed(
                              context, PageRoutes.agentAddEdit,
                              arguments: new MyUserDataModel());
                          if (status == "RELOAD") {
                            apiCall();
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
                              "ADD NEW AGENT",
                              style: TextStyle(
                                  color: kWhiteColor,
                                  fontWeight: RFontWeight.BOLD),
                            )
                          ],
                        )),
                  ),
                ),
              ),
              Stack(
                children: [
                  InputFieldWidget.text(
                    "Search by name",
                    margin:
                        EdgeInsets.only(top: 0, left: 16, right: 50, bottom: 0),
                    textEditingController: _searchController,
                    enableColor: kColor8,
                    focusColor: kColor8,
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: RFontWeight.REGULAR,
                      color: kMainTextColor,
                      height: 1.5,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: RFontWeight.REGULAR,
                      color: kColor8,
                    ),
                    suffixAsset: IC_SEARCH_BLACK,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 50,
                      height: 60,
                      child: Center(
                        child: InkWell(
                          child: Icon(
                            Icons.filter_list,
                            size: 36,
                            color: kColor8,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filterData.length, //mData.length,
                  itemBuilder: (context, index) =>
                      _itemWidget(filterData[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemWidget(MyUserDataModel user) {
    bool _switchValue = false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    user.name,
                    //textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: kMainTextColor,
                        fontFamily: RFontFamily.POPPINS,
                        fontWeight: RFontWeight.BOLD,
                        fontSize: 16),
                  ),
                ),
                Switch(
                  value: user.status,
                  onChanged: (value) {
                    _switchValue = value;
                    setState(() {});
                    viewModel.requestUpdateAgentStatus(
                        user.status ? "0" : "1", user.id);
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              var status = await Navigator.pushNamed(
                  context, PageRoutes.agentAddEdit,
                  arguments: user);
              if (status == "RELOAD") {
                apiCall();
              }
            },
            child: Container(
              decoration: new BoxDecoration(
                color: kColor8,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.edit_outlined,
                color: kWhiteColor,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
