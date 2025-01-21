import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(WalkGameapp());

class WalkGameapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: WalkGame(),
    );
  }
}

class WalkGame extends StatefulWidget {
  @override
  _WalkGameState createState() => _WalkGameState();
}

class _WalkGameState extends State<WalkGame> {
  bool _isDialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDialogShown) {
      _isDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_stage.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SvgPicture.asset(
                'assets/images/stage_background.svg',
                width: 150,
                height: 150,
              ),
            ),
            Positioned(
              left: 36,
              top: 65,
              child: Text(
                '#stage 1',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 600,
            height: 430,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/result_background.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                  child: Text(
                    '  너무너의 화를 가라앉혀보자! \n너무너와 함께 바다산책을 해줘',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    nextDialog();
                  },
                  child: Text('알겠어'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> nextDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 600,
            height: 430,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/result_background.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                  child: Text(
                    '지금 몸을 자유롭게 움직일 수 있어?',
                    style: TextStyle(fontSize: 21.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FirstOptionScreen()),
                        );
                      },
                      child: Text('응'),
                    ),
                    SizedBox(width: 20), // 버튼 사이의 간격 추가
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SecondOptionScreen()),
                        );
                      },
                      child: Text('아니'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FirstOptionScreen extends StatefulWidget {
  @override
  _FirstOptionScreenState createState() => _FirstOptionScreenState();
}

class _FirstOptionScreenState extends State<FirstOptionScreen> {
  int _stepCount = 0;
  late StreamSubscription<StepCount> _subscription;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    _subscription = Pedometer.stepCountStream.listen(
      (StepCount event) {
        setState(() {
          _stepCount = event.steps;
        });
      },
      onError: (error) {
        print("Error: $error");
      },
      onDone: () {
        print("Pedometer done.");
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_stage.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SvgPicture.asset(
                'assets/images/stage_background.svg',
                width: 150,
                height: 150,
              ),
            ),
            Positioned(
              left: 36,
              top: 65,
              child: Text(
                '#stage 1',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            
            Center(
              child: Image.asset(
                'assets/images/normal_mooner_x.png',
                width: 250,
                height: 270,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 280,
              child: Text(
                '문찌와 같이 걸으면서 화를 달래주자!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              bottom: 180,
              child: Text(
                '걸음 수: $_stepCount',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondOptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_stage.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SvgPicture.asset(
                'assets/images/stage_background.svg',
                width: 150,
                height: 150,
              ),
            ),
            Positioned(
              left: 36,
              top: 65,
              child: Text(
                '#stage 1',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/normal_mooner_x.png',
                width: 200,
                height: 270,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
