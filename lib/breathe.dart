import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(BreatheGameApp());

class BreatheGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BreatheGameScreen(),
    );
  }
}

class BreatheGameScreen extends StatefulWidget {
  @override
  _BreatheGameScreenState createState() => _BreatheGameScreenState();
}

class _BreatheGameScreenState extends State<BreatheGameScreen> {
  
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
            'assets/json/animation_example.json',
          ),
        ),
        ]
     ) );
  }
  
}