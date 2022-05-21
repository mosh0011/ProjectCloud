import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class MyTeacherCourse extends StatefulWidget {
  @override
  static const routeName = '/MyTeacherCourse';

  const MyTeacherCourse({Key? key}) : super(key: key);
  @override
  _MyTeacherCourseState createState() => _MyTeacherCourseState();
}

class _MyTeacherCourseState extends State<MyTeacherCourse> {
  @override
  void dispose() {
    super.dispose();
  }

  double borderRadius = 10, padding = 10;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("videos")
              .where("teacher_id", isEqualTo: auth.currentUser!.uid)
              //.doc(auth.currentUser!.uid)
              //.collection("teacherCourses")
              .snapshots(),

          //.snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final data = snapshot.data!.docs;
              if (data.isEmpty) {
                return const Center(child: Text("No Courses Found"));
              }
              return SizedBox(
                height: 777,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        title: Text(
                          data[index]["name_video"],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                        subtitle: Text(
                          data[index]["descripstion_video"],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                        ),
                        leading: Image.asset("assets/download.jpg"),
                        trailing: GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance.runTransaction(
                                (Transaction myTransaction) async {
                              myTransaction
                                  .delete(snapshot.data!.docs[index].reference);
                            });
                          },
                          child: const Card(
                              child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.close),
                          )),
                        ),
                        // leading: Text(
                        //   data[index]["time"].toString(),
                        //   style: const TextStyle(
                        //       color: Colors.white, fontSize: 12),
                        // ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
