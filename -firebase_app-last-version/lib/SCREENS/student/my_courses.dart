import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../sharepref/user_share_pref.dart';
import '../teacher/course_detail.dart';

class MyCourses extends StatefulWidget {
  static const routeName = '/MyCourses';

  const MyCourses({Key? key}) : super(key: key);
  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  final int _data = 0;
  int numberEnrollCourses = 0;
  late final data;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("numberEnrollCourses  = " + numberEnrollCourses.toString());

    return Stack(
      children: [
        getMyEnrollCourses(),
      ],
    );
  }

  Future<void> enrollCourse(
    String studentId,
    String descripstionVideo,
    String nameVideo,
    String videoUrl,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });

      int d = await SharedPrefUser().getNumberEnrollCourses();
      log("s $d");
      int s = await SharedPrefUser().saveId(numberEnrollCourses + 1);
      log("s $s");

      //  .then((value) => {log("value $value"), numberEnrollCourses = value});
      FirebaseFirestore.instance
          .collection("Enroll_Courses")
          .doc(auth.currentUser!.uid)
          .collection("MyEnrollCourses")
          .doc(nameVideo.trim())
          .set({
        "student_id": auth.currentUser!.email,
        "isEnroll": true,
        "Enroll_time": DateTime.now(),
        "name_video": nameVideo,
        "descripstion_video": descripstionVideo,
        "video_url": videoUrl,
      });
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully subscribed to the course")));
    } on FirebaseAuthException {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred while signing up")));
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Stream<QuerySnapshot> getData() {
    return FirebaseFirestore.instance
        .collection("Enroll_Courses")
        .doc(auth.currentUser!.uid)
        .collection("MyEnrollCourses")
        .where("student_id", isEqualTo: auth.currentUser!.email)
        .snapshots();
  }

  getMyEnrollCourses() {
    return SizedBox(
      height: double.infinity,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Enroll_Courses")
            .doc(auth.currentUser!.uid)
            .collection("MyEnrollCourses")
            .where("student_id", isEqualTo: auth.currentUser!.email)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("");
          } else {
            final data = snapshot.data!.docs;
            numberEnrollCourses = data.length;

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Enroll_Courses")
                  .doc(auth.currentUser!.uid)
                  .collection("MyEnrollCourses")
                  .where("student_id", isEqualTo: auth.currentUser!.email)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final data = snapshot.data!.docs;
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
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => CourseDetail(
                                            description: data[index]
                                                ["descripstion_video"],
                                            title: data[index]["name_video"],
                                            // title: data[index]["video_url"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Text(
                                          "view course",
                                          //data[index]["descripstion_video"],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
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
            );
          }
        },
      ),
    );
  }
}
