import 'package:firebase_app/Home/main_nav.dart';
import 'package:firebase_app/user_share_pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register.dart';
import 'tab_screen_student.dart';

class Login extends StatefulWidget {
  const Login({Key? key, this.type = 0}) : super(key: key);
  static const routeName = 'login';
  final int type;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double? sizeBetweenFeiled = 50.0;

  final _form = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        // decoration: InputDecoration(
                        //     border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(50),
                        // )),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          controller: _userNameController,
                          decoration: InputDecoration(
                              labelText: 'email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
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
                      const SizedBox(height: 25),
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
            const SizedBox(height: 30),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black))
                : ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                    onPressed: () {
                      final isValid = _form.currentState!.validate();
                      if (!isValid) {
                        return;
                      }
                      _form.currentState!.save();
                      loginUser(
                          _userNameController.text, _passwordController.text);
                    },
                  ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Register.routeName);
              },
              child: const Text(
                'Do not have account? SignUp',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginUser(String name, String password) async {
    var pref = SharedPrefUser();
    try {
      setState(() {
        isLoading = true;
      });
      await auth.signInWithEmailAndPassword(email: name, password: password);
      if (widget.type == 1) {
        Navigator.of(context).pushNamed(TabScreenStudent.routeName);
      } else {
        Navigator.of(context).pushNamed(MainNav.routeName);
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = "";
      if (error.code == "user-not-found") {
        errorMessage = error.code;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found for that email")));
      } else if (error.code == "wrong-password") {
        errorMessage = error.code;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong password provided for that user")));
      } else if (error.code == "invalid-email") {
        errorMessage = error.code;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("invalid email")));
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
