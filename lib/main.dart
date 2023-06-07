import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:twopa_sales_manager/Database/hive_database.dart';
import 'package:twopa_sales_manager/Locale/language_cubit.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Routes/routes.dart';
import 'package:twopa_sales_manager/Service/PushNotificationService.dart';
import 'package:twopa_sales_manager/Theme/style.dart';
import 'package:twopa_sales_manager/Utils/preferences_handler.dart';

ValueNotifier<PreferencesHandler> mPreference =
    ValueNotifier(PreferencesHandler());
final databaseReference = FirebaseDatabase.instance.ref();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  mPreference.value = await PreferencesHandler.init();
  await HiveDatabase.init();
  await PushNotificationService().setupInteractedMessage();

  runApp(
      Phoenix(
        child: BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(mPreference.value.selectedLanguage), child: MyApp()),
      ),
  );
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) => MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("en"),
          const Locale("ar"),
        ],
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        locale: locale,
        initialRoute: PageRoutes.splash,
        onGenerateRoute: PageRoutes.generateRoute,
        // routes: PageRoutes().routes(),
      ),
    );
  }
}
