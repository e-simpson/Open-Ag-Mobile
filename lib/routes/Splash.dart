import 'dart:async';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/routes/Home.dart';
import 'package:open_ag_mobile/routes/Onboarding.dart';
import 'package:open_ag_mobile/tools/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  Future<bool> hasExistingFoodComputer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(foodComputerNamePreference) != null ? true : false;
  }

  void startApp(BuildContext c) async {
    bool hasExisting = await hasExistingFoodComputer();
    Timer(const Duration(milliseconds: 50), () {
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
