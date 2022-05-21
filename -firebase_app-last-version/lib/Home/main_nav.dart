import 'package:firebase_app/SCREENS/student/register.dart';
import 'package:firebase_app/SCREENS/teacher/enrolled_course.dart';
import 'package:firebase_app/SCREENS/teacher/feed.dart';
import 'package:firebase_app/SCREENS/teacher/upload_video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SCREENS/teacher/my_teacher_course.dart';
import '../user_share_pref.dart';

class MainNav extends StatefulWidget {
  const MainNav({Key? key}) : super(key: key);
  static const routeName = "MainNav";

  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  final auth = FirebaseAuth.instance;
  late SharedPreferences prefs;

  DateTime timeBackPressed = DateTime.now();
  final List<Widget> _pages = [
    const Dashboard(),
    EnrolledCourse(),
    const MyTeacherCourse(),
    //   List<Widget> pages = [Feed(), EnrolledCourse(), EnrolledCourse()];MainNav
  ];
  int _currentPage = 0;
  void _selectedPage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
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
                        "اضغط مرة أخري للخروج",
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
                  body: _pages[_currentPage],
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    onTap: _selectedPage,
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.white,
                    currentIndex: _currentPage,
                    items: [
                      //['Dashboard', 'Enrolled courses', 'Your courses'];
                      BottomNavigationBarItem(
                        label: "Dashboard",
                        backgroundColor: Colors.white,
                        icon: Icon(
                          Icons.dashboard,
                          color:
                              _currentPage == 0 ? Colors.black : Colors.white,
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: "Enrolled Course",
                        backgroundColor: Colors.white,
                        icon: Icon(
                          Icons.video_camera_back_rounded,
                          color:
                              _currentPage == 1 ? Colors.black : Colors.white,
                        ),
                      ),
                      const BottomNavigationBarItem(
                          label: "Your courses",
                          backgroundColor: Colors.white,
                          icon: CircleAvatar(
                            radius: 15,
                            foregroundColor: Colors.cyan,
                            child: Text("Y"),
                          ))
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return const UploadVideo();
                      })));
                      // Navigator.pushNamed(context, CreateCourse.routeName);
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
