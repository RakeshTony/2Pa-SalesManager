import 'package:twopa_sales_manager/Utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/AppImage.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Utils/preferences_handler.dart';
import 'package:twopa_sales_manager/Ux/Home/ViewModel/view_model_home.dart';
import 'package:twopa_sales_manager/main.dart';

import '../../Locale/locales.dart';
import '../../Utils/app_decorations.dart';
import '../Dialog/dialog_change_language.dart';

class DrawerMenu extends StatefulWidget {
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends BasePageState<DrawerMenu, ViewModelHome> {
  @override
  void initState() {
    super.initState();
    viewModel.responseStream.listen((event) {
      if (event.getStatus) {
        mPreference.value.clear();
        Phoenix.rebirth(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Drawer(
        child: Container(
        decoration: decorationBackground,
      child: ListView(
        children: [
          ValueListenableBuilder(
            valueListenable: mPreference,
            builder: (context, PreferencesHandler data, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Align(alignment: Alignment.topLeft,
                    child: Icon(Icons.arrow_back_ios,color: kColor11,),) ,),
                  AppImage(
                    data.userData.icon,
                    72,
                    defaultImage: DEFAULT_PERSON,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Text(
                      data.userData.name,
                      style: TextStyle(
                        color:kMainTextColor,
                        fontWeight: RFontWeight.BOLD,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      data.userData.email,
                      style: TextStyle(
                        color: kMainTextColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            //decoration: mItemDecoration,
            child: ListTile(
              minLeadingWidth: 10,
              title: Text("${locale.profile}" ,style: mItemTextStyle,),
              leading: Icon(Icons.person_outlined, color: kColor11, size: 24),
              onTap: () {
                Navigator.popAndPushNamed(context, PageRoutes.profile);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: const Divider(
              height: 1,
              thickness: 1,
              indent: 20,
              endIndent: 0,
              color: kTextInputInactive,
            ),
          ),
          Container(
            //decoration: mItemDecoration,
            child: ListTile(
              minLeadingWidth: 10,
              title: Text("${locale.changeLanguage}", style: mItemTextStyle),
              leading:
              Icon(Icons.language, color: kColor11, size: 24),
                onTap: () async {
                  var dialog = DialogChangeLanguage();
                  var status = await showDialog(
                      context: context, builder: (context) => dialog);
                  if (status == "UPDATE") {
                    viewModel.requestProfileUpdate(
                        mPreference.value.selectedLanguage.equalsIgnoreCase("en")
                        ? "3"
                        : "8");
                  }
                },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: const Divider(
              height: 1,
              thickness: 1,
              indent: 20,
              endIndent: 0,
              color: kTextInputInactive,
            ),
          ),
          Container(
           // margin: EdgeInsets.only(top: 6),
            //decoration: mItemDecoration,
            child: ListTile(
              minLeadingWidth: 10,
              title: Text("${locale.changePassword}", style: mItemTextStyle),
              leading: Icon(Icons.lock_outlined, color: kColor11, size: 24),
              onTap: () {
                Navigator.popAndPushNamed(context, PageRoutes.changePassword);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: const Divider(
              height: 1,
              thickness: 1,
              indent: 20,
              endIndent: 0,
              color: kTextInputInactive,
            ),
          ),
          Container(
           // decoration: mItemDecoration,
            child: ListTile(
              minLeadingWidth: 10,
              title: Text("${locale.logout}", style: mItemTextStyle),
              leading: Icon(Icons.logout, size: 24, color: kColor11),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("${locale.loggingOut}"),
                        content: Text("${locale.areYouSure}"),
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        actions: <Widget>[
                          Container(
                            child: MaterialButton(
                              child: Text("${locale.no}"),
                              textColor: kMainTextColor,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: kMainTextColor)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Container(
                            child: MaterialButton(
                              child: Text("${locale.yes}"),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: kMainTextColor)),
                              textColor: kMainTextColor,
                              onPressed: () {
                                viewModel.requestLogout();
                              },
                            ),
                          )
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
        ),
    );
  }

  var mItemDecoration = BoxDecoration(
     color: kMainButtonColor.withOpacity(.10),
     borderRadius: BorderRadius.all(Radius.circular(4))
  );
  var mItemTextStyle = TextStyle(
    color: kMainTextColor,
    fontWeight: RFontWeight.BOLD,
    fontSize: 15,
  );
}
