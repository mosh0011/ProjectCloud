import 'package:firebase_app/SCREENS/student/register.dart';
import 'package:firebase_app/user_share_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_courses.dart';
import 'my_courses.dart';

class TabScreenStudent extends StatefulWidget {
  const TabScreenStudent({Key? key}) : super(key: key);
  static const routeName = "TabScreenStudent";

  @override
  State<TabScreenStudent> createState() => _TabScreenStudentState();
}

class _TabScreenStudentState extends State<TabScreenStudent> {
  int _selectIndex = 0;
  late SharedPreferences prefs;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  DateTime timeBackPressed = DateTime.now();
  final auth = FirebaseAuth.instance;

  final List<Widget> _pages = [
    const AllCourses(),
    const MyCourses(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: WillPopScope(
              onWillPop: () async {
                final differenc = DateTime.now().difference(timeBackPressed);
                final exitApp = differenc >= const Duration(seconds: 2);

                timeBackPressed = DateTime.now();

                if (exitApp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: const Duration(seconds: 2),
                      content: const Text(
                        "Press again to exit",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  );
                  return false;
                } else {
                  return true;
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => const Register())));
                          SharedPrefUser().logout();
                          prefs.clear();

                          auth.signOut();
                          setState(() {});
                        },
                        icon: const Icon(Icons.logout))
                  ],
                ),
                body: _pages[_selectIndex],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectIndex,
                  onTap: _navigateBottomBar,
                  items: const [
                    BottomNavigationBarItem(
                      backgroundColor: Color(0xff2A1B6E),
                      icon: Icon(Icons.video_camera_back),
                      label: 'All Course',
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: Color(0xff2A1B6E),
                      icon: Icon(Icons.person),
                      label: 'Your Courses',
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
