import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart'; // 마이크
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

// 1) 나무판자 클래스 BreatheGameScreen
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
          // 배경화면
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 중앙에 이미지와 텍스트 배치
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BreatheGamesScreen()), // BreatheGamesScreen으로의 이동
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/result_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 400, // 이미지의 너비 설정
                    height: 300, // 이미지의 높이 설정
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Spacer(), 
                        SizedBox(height: 90),// 위쪽 공간을 비워 텍스트를 아래로 이동
                        const Text(
                          '문찌의 \n화를 가라앉혀보자!',
                          style: TextStyle(
                            fontSize: 24,
                   
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10), // 텍스트 간의 간격을 추가
                        const Text(
                          '문찌와 함께 심호흡을 해보자!!!',
                          style: TextStyle(
                            fontSize: 18,
                           
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(), // 하단 공간을 비워서 여백을 조절
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 2) main 게임 클래스 BreatheGamesScreen
class BreatheGamesScreen extends StatefulWidget {
  @override
  _BreatheGamesScreenState createState() => _BreatheGamesScreenState();
}

class _BreatheGamesScreenState extends State<BreatheGamesScreen> {
  Timer? _timer;
  int _start = 180; // 3분 타이머를 초 단위로 설정
  int _setCount = 0; // 현재 세트 카운트
  String _instruction = "준비 됐어?"; // 화면에 표시할 텍스트
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _startBreatheCycle() async {
    for (int i = 0; i < 10; i++) {
      await breathe(); // breathe 메소드를 10회 실행
    }
    _navigateToEndScreen(); // 10세트 완료 후 종료 화면으로 이동
  }

  Future<void> breathe() async {
    setState(() {
      _instruction = "4초 동안 \n 숨을 마셔줘";
      _progress = 0.0;
    });
    await _runTimer(4);

    setState(() {
      _instruction = "6초 동안 \n 숨을 뱉어줘";
      _progress = 0.0;
    });
    await _runTimer(6); 

    setState(() {
      _instruction = "휴식 시간이야~";
      _progress = 0.0;
    });
    await _runTimer(3); 

    setState(() {
      _setCount++;
    });
  }

  Future<void> _runTimer(int seconds) async {
  for (int i = 0; i < seconds; i++) {
    await Future.delayed(Duration(seconds: 2));  // 1초마다 대기
    setState(() {
      _instruction = "${seconds - i}초 남았어요!";  // 남은 시간 업데이트
    });
  }
  setState(() {
    _instruction = "타이머 종료!";
  });
}

  void _navigateToEndScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EndBreatheGameScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = (seconds % 60);
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 배경화면
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 상단 스테이지번호
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
            child: const Text(
              'STAGE 2',
              style: TextStyle(
                fontSize: 18,
         
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 130,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '4-6-3 법칙',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 중단 상단에 타이머와 문어 이미지
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "문찌와 함께 완료한 횟수 : $_setCount / 10 세트!",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // 문어 이미지
                    Image.asset(
                      'assets/images/normal_mooner_x.png',
                      width: 300,
                      height: 280,
                    ),
                    // 마이크 아이콘
                    Positioned(
                      top: 180, // 마이크 위치 조정
                      child: Image.asset(
                        'assets/images/microphone.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 100),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,  // Row 크기를 내용에 맞춤
                      children: [
                        SvgPicture.asset(
                          'assets/images/fisherman_front.svg', // 추가된 이미지
                          width: 0,
                          height: 120,
                        ),
                        Image.asset(
                          'assets/images/dialog_background.png',
                          width: 270,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0), // Fisher 이미지에 겹치지 않도록 텍스트를 오른쪽으로 이동
                      child: GestureDetector(
                        onTap: _startBreatheCycle, // "준비 됐어?" 텍스트 클릭 시 게임 시작
                        child: Text(
                          _instruction,
                          style: const TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
      
    );
  }
}

// 3) 게임 종료 화면 클래스 EndBreatheGameScreen
class EndBreatheGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 배경화면
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 중앙에 이미지와 텍스트 배치
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '게임 종료!',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '문찌의 화를 모두 가라앉혔어!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BreatheGameScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    '다시 하기',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
