import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/SCREENS/teacher/course_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'add_lessons.dart';

//Dashboard
class Dashboard extends StatefulWidget {
  @override
  static const routeName = '/Dashboard';

  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final auth = FirebaseAuth.instance;
  @override
  final bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SizedBox(
        height: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("videos")
              .where("teacher_id", isEqualTo: auth.currentUser!.uid)
              // .doc(auth.currentUser!.uid)
              // .collection("teacherCourses")
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final data = snapshot.data!.docs;

              if (data.isEmpty) {
                return const Center(
                    child: Text("No Courses Found... add some"));
              }
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: double.infinity,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 10,
                        child: Column(children: [
                          SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Image.asset("assets/download.jpg")),
                          Text(
                            //"title",
                            data[index]["name_video"],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            //"descripstion_video",
                            data[index]["descripstion_video"],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => CourseDetail(
                                            description: data[index]
                                                ["descripstion_video"],
                                            title: data[index]["name_video"],
                                          )));
                                },
                                child: const Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      "view course",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => AddLessons(
                                          idCourse: data[index]
                                              ["name_video"]))));
                                },
                                child: const Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      "Add Lessons",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 5, 46, 122),
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ]),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
