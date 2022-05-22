import 'package:firebase_app/SCREENS/student/login.dart';
import 'package:firebase_app/SCREENS/student/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: 'avenir'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentpage = 0;
  PageController _pageController =
      new PageController(initialPage: 0, keepPage: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView(
                controller: _pageController,
                children: [
                  onBoardBage("logo", "Welcome to M learning",
                      "Come to learning easily ! "),
                  onBoardBage("onboard2", "Learn Happens",
                      "The Learning online made you happy."),
                  onBoardBage("onboard3", "Lecture and Assigments",
                      "Do the Assigments and watch the Lecture "),
                ],
                onPageChanged: (value) => {setcurrentpage(value)},
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => getInicator(index)),
            )
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/path1.png'), fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onLoginpage,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 9),
                          blurRadius: 20,
                          spreadRadius: 3)
                    ]),
                    child: Text(
                      "Get Started",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: openlogin,
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  AnimatedContainer getInicator(int pageNo) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: 10,
      width: (currentpage == pageNo) ? 20 : 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: (currentpage == pageNo) ? Colors.black : Colors.grey,
      ),
    );
  }

  Column onBoardBage(String img, String title, String txt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/$img.png'))),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Text(
            "$txt",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  setcurrentpage(int value) {
    currentpage = value;
    setState(() {});
  }

  onLoginpage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  openlogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }
}
