import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:open_ag_mobile/routes/CreateRecipe.dart';
import 'package:open_ag_mobile/routes/Home.dart';
import 'package:open_ag_mobile/routes/Onboarding.dart';
import 'package:open_ag_mobile/routes/Setup.dart';
import 'package:open_ag_mobile/routes/Splash.dart';
import 'package:open_ag_mobile/routes/ViewRecipe.dart';

import 'package:screentheme/screentheme.dart';



void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ScreenTheme.darkStatusBar();
  ScreenTheme.darkNavigationBar();
  ScreenTheme.updateNavigationBarColor(Colors.grey[50]);
  runApp(OpenAgMobileApp());
}

class OpenAgMobileApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    final Color primary = Colors.green;
    //Theme data
    ThemeData theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      accentColor: Color.lerp(primary, Colors.white, 0.5),
      primaryColorBrightness: Brightness.light,

      //button theme
      highlightColor: Colors.transparent,
      splashColor: Colors.black26,
      disabledColor: Colors.black12,
      toggleableActiveColor: primary,
      cursorColor: primary,
      buttonColor: primary,
      textTheme: TextTheme(button: TextStyle(color: primary, fontSize: 20.0, fontWeight: FontWeight.normal)),
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary, colorScheme: ColorScheme.fromSwatch(primarySwatch: primary)),
      primaryIconTheme: IconThemeData(color: Colors.black),

      //card & canvas theme
      cardColor: Colors.grey[50],
//      canvasColor: Colors.transparent,

      //enlarge icons for visibility
      iconTheme: IconThemeData(size: 24.0),
    );
    return MaterialApp(
        title: "OpenAg Mobile",
        color: Colors.grey[200],
        home: Splash(),
        routes: {
          "/onboarding": (_) => Onboarding(),
          "/setup": (_) => Setup(),
          "/home": (_) => Home(),
          "/createrecipe": (_) => CreateRecipe(),
          "/viewrecipe": (_) => ViewRecipe(),
        },
        theme: theme,
        debugShowCheckedModeBanner: false
    );
  }
}

