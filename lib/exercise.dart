import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(ExerciseGameApp());

class ExerciseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExerciseGameScreen(),
    );
  }
}

class ExerciseGameScreen extends StatefulWidget {
  @override
  _ExerciseGameScreenState createState() => _ExerciseGameScreenState();
}

class _ExerciseGameScreenState extends State<ExerciseGameScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
          child: Lottie.asset(
            'assets/json/loading.json',
          ),
        ),
        ]
     ) );
  }
  
}