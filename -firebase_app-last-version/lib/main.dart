import 'package:firebase_app/SCREENS/intro_screen.dart';
import 'package:firebase_app/SCREENS/student/login.dart';
import 'package:firebase_app/SCREENS/student/register.dart';
import 'package:firebase_app/SCREENS/student/tab_screen_student.dart';
import 'package:firebase_app/SCREENS/teacher/course_detail.dart';
import 'package:firebase_app/SCREENS/teacher/feed.dart';

import 'Home/main_nav.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.deepPurpleAccent),
      ),
      home: SplashScreenPage(),
      routes: {
        CourseDetail.routeName: (ctx) => const CourseDetail(),
        MainNav.routeName: (ctx) => const MainNav(),
        Login.routeName: (ctx) => const Login(),
        TabScreenStudent.routeName: (ctx) => const TabScreenStudent(),
        Register.routeName: (ctx) => const Register(),
        Dashboard.routeName: (ctx) => const Dashboard(),
      },
    );
  }
}
