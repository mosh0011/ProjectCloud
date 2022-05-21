import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../sharepref/user_share_pref.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static const routeName = 'Register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  double? sizeBetweenFeiled = 10.0;
  File? _storedImage;
  final _form = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          color: Theme.of(context).colorScheme.onPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: SizedBox(
                    height: 251,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            controller: _userNameController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                labelText: 'username',
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
                                return 'Username must be entered';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                        ),
                        SizedBox(height: sizeBetweenFeiled),
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: 'email',
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
                                return 'Email must be entered';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                        ),
                        SizedBox(height: sizeBetweenFeiled),
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                labelText: 'password',
                                focusColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                )
                                //hintText: 'password',
                                ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password must be entered';
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
              const SizedBox(height: 70),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              'Register as a teacher',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          onPressed: () {
                            registerUser(
                                _emailController.text,
                                _userNameController.text,
                                _passwordController.text,
                                0);
                          },
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              'Register as a student',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          onPressed: () {
                            registerUser(
                                _emailController.text,
                                _userNameController.text,
                                _passwordController.text,
                                1);
                          },
                        ),
                      ],
                    ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Login.routeName);
                },
                child: const Text(
                  'Already have account? SignIn',
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUser(
      String email, String name, String password, int typeAccount) async {
    try {
      setState(() {
        isLoading = true;
      });
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseFirestore.instance
          .collection(typeAccount == 0 ? "teacher" : "student")
          .doc(userCredential.user!.uid)
          .set({
        "username": name.trim(),
        "email": email.trim(),
        "uid": auth.currentUser!.uid,
        "timeCreated": DateTime.now(),
        "typeAccount": typeAccount == 0 ? "student" : "teacher",
        "Enrolied_course": 0,
      });
      setState(() {
        isLoading = false;
      });
      await SharedPrefUser().saveId(typeAccount);
      await SharedPrefUser().login();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Account created successfully, log in")));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => Login(type: typeAccount)));
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      String errorMessage = "";
      switch (error.code) {
        case "weak-password":
          errorMessage = "The password provided is too weak.";
          break;
        case "email-already-in-use":
          errorMessage = "The account already exists for that email.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
