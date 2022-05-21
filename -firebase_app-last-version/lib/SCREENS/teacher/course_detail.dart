import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../sharepref/user_share_pref.dart';
import '../student/lesson_detail.dart';

class CourseDetail extends StatefulWidget {
  static const routeName = '/courseDetail';
  final title;
  final description;

  const CourseDetail({Key? key, this.title, this.description})
      : super(key: key);

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  int nextLesson = 0;

  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    log(widget.title);
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
                tag: "",
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Image.asset("assets/download.jpg"),
                )),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Course: ${widget.title}',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Taked By  ${auth.currentUser!.email.toString()}",
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        widget.description.toString(),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w300),
                      )),
                  const SizedBox(
                    width: double.infinity,
                    // child:
                  )
                ],
              ),
            ),
            SizedBox(
              height: 400,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("lessons")
                    // .doc(auth.currentUser!.uid)
                    // .collection("video_details")
                    .where("video_id", isEqualTo: widget.title)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final data = snapshot.data!.docs;
                    log(data.length.toString());
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: double.infinity,
                        child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics,
                          // scrollDirection: NeverScrollableScrollPhysics,
                          itemCount: data.length,
                          itemBuilder: (ctx, index) {
                            int i = index + 1;
                            var nameLessons = data[index]["name_lessons"];
                            var descripstionLessons =
                                data[index]["descripstion_lessons"];
                            Map<String, dynamic> user = {
                              'one': false,
                              'two': false,
                              'three': false,
                              'hore': false,
                              'hife': false,
                            };

                            SharedPrefUser().saveUser(user);
                            return GestureDetector(
                              onTap: () {
                                if (data.length == 1) {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return LessonDetail(
                                      index: index,
                                      description: data[index]
                                          ["descripstion_lessons"],
                                      title: data[index]["name_lessons"],
                                      url: data[index]["lessons_url"],
                                      lessonUpdate: data[index]["lessons_url"],
                                    );
                                  }));
                                } else {
                                  if (index == data.length - 1) {
                                    if (data[index]["is_show"] == true) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (ctx) {
                                          return LessonDetail(
                                            index: index,
                                            description: data[index]
                                                ["descripstion_lessons"],
                                            title: data[index]["name_lessons"],
                                            url: data[index]["lessons_url"],
                                            lessonUpdate: data[index]
                                                ["lessons_url"],
                                          );
                                        }),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Watch the previous lesson first")));
                                    }
                                    log("this is a Last index ");
                                  } else {
                                    index == 0 || data[index]["is_show"] == true
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(builder: (ctx) {
                                              index + 1;
                                              FirebaseFirestore.instance
                                                  .collection('lessons')
                                                  .doc(data[index + 1]
                                                          ["name_lessons"] +
                                                      data[index + 1][
                                                          "descripstion_lessons"])
                                                  .update({
                                                'is_show': true,
                                              });

                                              return LessonDetail(
                                                index: index,
                                                description: data[index]
                                                    ["descripstion_lessons"],
                                                title: data[index]
                                                    ["name_lessons"],
                                                url: data[index]["lessons_url"],
                                                lessonUpdate: data[index]
                                                    ["lessons_url"],
                                              );
                                            }),
                                          )
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Watch the previous lesson first")));
                                  }
                                }
                              },
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "lessons :${i.toString()}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 10),

                                        Text(
                                          "lessons name :$nameLessons", //
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "descripstion :$descripstionLessons",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        // const SizedBox(height: 20),
                                      ]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        )),
        bottomNavigationBar: Container(
          width: double.infinity,
          color: Colors.black,
          height: 50,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Ads").snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("");
                } else {
                  final data = snapshot.data!.docs;

                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (ctx, index) {
                        log("feedg " + data[index]["image_url"].toString());

                        return SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: Image.network(
                            data[index]["image_url"],
                          ),
                        );
                      });
                }
              }),
        ));
  }
}
