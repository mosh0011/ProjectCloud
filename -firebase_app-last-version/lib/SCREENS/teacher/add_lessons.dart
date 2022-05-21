import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class AddLessons extends StatefulWidget {
  const AddLessons({Key? key, required this.idCourse}) : super(key: key);
  static const routeName = "add_les";
  final idCourse;

  @override
  State<AddLessons> createState() => _AddLessonsState();
}

class _AddLessonsState extends State<AddLessons> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final _form = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _videoNameController = TextEditingController();
  final _descripstionController = TextEditingController();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    } else {
      return;
    }
  }

  Future uplaodFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return null;
      }
      _form.currentState!.save();
      final path = "file/${pickedFile!.name}";
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() => {});
      var url = "";

      final urlDownload = snapshot.ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection("lessons")
            .doc(_videoNameController.text + _descripstionController.text)
            .set(
          {
            "name_lessons": _videoNameController.text,
            "descripstion_lessons": _descripstionController.text,
            "lessons_url": value.toString(),
            "time": DateTime.now(),
            "video_id": widget.idCourse,
            "is_show": false
          },
        );
        setState(() {
          log(value);

          value = url;
        });
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Lesson uploaded")));
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred while uploading the lesson")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add leasson"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: SizedBox(
                        height: 180,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              color: Colors.white,
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                controller: _videoNameController,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                    labelText: 'title lessons',
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    )),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocus);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Lesson title must be entered';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              color: Colors.white,
                              child: TextFormField(
                                textAlign: TextAlign.left,
                                controller: _descripstionController,
                                decoration: InputDecoration(
                                    labelText: 'decoration lessons',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    )),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocus);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Description must be entered';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 30),
                  pickedFile != null
                      ? GestureDetector(
                          onTap: () {
                            selectFile();
                          },
                          child: Container(
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 45,
                                ),
                                SizedBox(width: 5),
                                Text("The file has been uploaded successfully"),
                              ],
                            )),
                            color: Colors.grey,
                            height: 200,
                            width: double.infinity,
                          ),
                        )
                      : const SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image(
                            image: AssetImage('assets/placeholder.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                  ElevatedButton(
                      onPressed: selectFile,
                      child: const Text("Choose the video")),
                  ElevatedButton(
                      onPressed: uplaodFile, child: const Text("Create the lesson")),
                ],
              ),
            ),
    );
  }
}
