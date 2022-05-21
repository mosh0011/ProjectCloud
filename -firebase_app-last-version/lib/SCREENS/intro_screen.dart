import 'dart:developer';
import 'package:firebase_app/Home/main_nav.dart';
import 'package:firebase_app/SCREENS/student/tab_screen_student.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import '../sharepref/user_share_pref.dart';
import 'student/register.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getUserStatus();
  }

  bool userStatus = false;
  int _id = 5;

  getUserStatus() async {
    SharedPrefUser prefs = SharedPrefUser();
    bool currentStatus = await prefs.isLogin();
    int id = await prefs.getID();

    if (currentStatus) {}
    setState(() {
      _id = id;
      userStatus = currentStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("id   " + _id.toString());
    return Container(
      color: Colors.white,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.10),
        child: Center(
          child: EasySplashScreen(
            durationInSeconds: 3,
            navigator: _id == 0
                ? const MainNav()
                : _id == 1
                    ? const TabScreenStudent()
                    : const Register(),
            logo: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fill,
            ),
            logoSize: 120,
            backgroundColor: Colors.white,
            loaderColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
