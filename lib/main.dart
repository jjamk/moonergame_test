//rkdtjgus qkqh
import 'package:flutter/material.dart';
import 'stage.dart';



//yoyooyoyyyoydnd.
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyAppScreen());
  }
}

class MyAppScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewStage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_home_test.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

