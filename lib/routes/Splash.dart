import 'dart:async';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/models/FoodComputer.dart';
import 'package:open_ag_mobile/routes/Home.dart';
import 'package:open_ag_mobile/routes/Onboarding.dart';
import 'package:open_ag_mobile/tools/DatabaseProvider.dart';
import 'package:open_ag_mobile/tools/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  Future<bool> hasExistingFoodComputer() async {
    DatabaseProvider dbp = DatabaseProvider();
    await dbp.open();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt(foodComputerIdPreference);
    if (id == null) return false;
    FoodComputer fc = await dbp.fetchFoodComputer(prefs.getInt(foodComputerIdPreference));
    return fc != null ? true : false;
  }

  void startApp(BuildContext c) async {
    bool hasExisting = await hasExistingFoodComputer();
    Timer(const Duration(milliseconds: 100), () {
      Navigator.of(c).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => hasExisting ? Home() : Onboarding()));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => startApp(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(child: Icon(Icons.nature, color: Theme.of(context).accentColor, size: 50.0)),
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}
