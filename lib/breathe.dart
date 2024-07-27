import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; //마이크
import 'package:flutter/services.dart';

void main() => runApp(BreatheGameApp());

class BreatheGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: BreatheGameScreen(),
    );
  }
}

class BreatheGameScreen extends StatefulWidget {
  @override
  _BreatheGameScreenState createState() => _BreatheGameScreenState();
}

class _BreatheGameScreenState extends State<BreatheGameScreen> {
  MethodChannel _methodChannel = MethodChannel('microphone');
  String _breathStatus = "Not Detecting Breath";

  @override
  void initState() {
    super.initState();
    startMicrophone();
  }

  // 마이크 레코더를 초기화하고 녹음을 시작
  Future<void> startMicrophone() async {
    try {
      await _methodChannel.invokeMethod('startMicrophone');
      _methodChannel.setMethodCallHandler(_handleMicrophoneData);
    } on PlatformException catch (e) {
      print("Failed to start microphone: '${e.message}'.");
    }
  }

  Future<dynamic> _handleMicrophoneData(MethodCall call) async {
    if (call.method == "microphoneData") {
      // Handle microphone data received from platform
      // You need to implement audio processing logic here to detect breath sounds
      // For simplicity, let's assume the platform sends a boolean value indicating breath detection
      bool isBreathing = call.arguments['isBreathing'];
      setState(() {
        _breathStatus =
            isBreathing ? "Breathing Detected" : "Not Detecting Breath";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Breath Detection'),
        ),
        body: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //상단 스테이지번호
          Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                'assets/images/stage_background.png',
                width: 150, 
                height: 150,
              ),
            ),
            Positioned(
              left: 36, 
              top: 65,
              child: Text(
                '#stage 5',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _breathStatus,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ]));
  }
}
