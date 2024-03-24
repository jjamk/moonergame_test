import 'package:flutter/material.dart';
import 'package:mooner_interface/breathe.dart';
import 'package:mooner_interface/piano.dart';
import 'dart:async';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

void main() => runApp(HealingGameApp());

class HealingGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HealingGameScreen(),
    );
  }
}

class HealingGameScreen extends StatefulWidget {
  @override
  _HealingGameScreenState createState() => _HealingGameScreenState();
}

class _HealingGameScreenState extends State<HealingGameScreen> {
  bool areWidgetsOverlapping = false;
  bool isShowingNotification = false;
  bool woundTreated = false;
  bool ointmentApplied = false;
  Timer? _timer;
  final int _timeLimit = 30;
  double _progress = 1.0;

  double hookLeft = 180; // 낚싯대의 초기 왼쪽 위치
  double hookTop = 260; // 낚싯대의 초기 위쪽 위치

  @override
  void initState() {
    super.initState();
    startTimer(); // initState에서 타이머 시작
  }

  // 타이머 시작 메서드
  void startTimer() {
    const tick = Duration(milliseconds: 100); // 매초마다 타이머 갱신
    const totalDuration = Duration(seconds: 30); // 30초로 설정
    int ticksElapsed = 0; // 경과된 초 카운트 변수

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        //ratioVal();
        _progress -= 1 / _timeLimit; // 매 초마다 진행률 감소

        if (_progress <= 0) {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    // 위젯이 dispose 될 때 타이머를 정리
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 배경 이미지를 표시하는 컨테이너
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 중앙에 플레이어 이미지를 표시
          Positioned(
            child: Center(
                child: Image.asset('assets/images/mooner.png',
                    width: 300, height: 300, fit: BoxFit.cover)),
          ),
          // 문어 이미지를 표시하고 사용자가 갈고리를 빼주는 기능 추가
          if (!woundTreated)
            Positioned(
              width: 70,
              height: 70,
              left: hookLeft,
              top: hookTop,
              child: Draggable(
                onDragUpdate: (details) {
                  // 드래그가 업데이트 될 때마다 위치 업데이트
                  setState(() {
                    hookLeft += details.delta.dx;
                    hookTop += details.delta.dy;
                  });

                  // 겹치는지 확인
                  checkOverlap();
                },
                child:
                    Image.asset('assets/images/gralgori-removebg-preview.png'),
                //크기 유지
                feedback: Material(
                  child: Image.asset(
                    'assets/images/hook.png', //드래그 중인 이미지
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                onDragEnd: (details) {
                  // 문어에 갈고리가 걸린 후에 상처를 표시
                  setState(() {
                    woundTreated = true;
                  });
                },
                childWhenDragging: Container(), // 드래그 중에 대체할 위젯
              ),
            ),
          // 상처 이미지 표시
          if (woundTreated)
            Positioned(
              left: 180,
              top: 260,
              child: Image.asset(
                'assets/images/상처.png',
                width: 70,
                height: 70,
              ),
            ),
          // 연고 및 붕대 이미지를 표시하고 사용자가 상처에 적용할 수 있도록 함
          if (woundTreated && !isShowingNotification)
            Positioned(
              left: 240,
              top: 650,
              child: Draggable(
                child: Image.asset(
                  'assets/images/ointmentt.png',
                  width: 70,
                  height: 70,
                ),
                feedback: Image.asset(
                  'assets/images/ointmentt.png',
                  width: 50,
                  height: 50,
                ),
                data: 'ointment', // 드래그 데이터 설정
                onDragEnd: (details) {
                  applyOintemt(); // 연고를 상처에 적용
                },
              ),
            ),
          if (woundTreated && !isShowingNotification)
            Positioned(
              left: 90,
              top: 650,
              child: Draggable(
                child: Image.asset(
                  'assets/images/붕대.png',
                  width: 70,
                  height: 70,
                ),
                feedback: Image.asset(
                  'assets/images/붕대.png',
                  width: 50,
                  height: 50,
                ),
                data: 'bandage', // 드래그 데이터 설정
                onDragEnd: (details) {
                  applyBandage(); // 붕대를 상처에 적용
                },
              ),
            ),
          Positioned(
            left: 360,
            bottom: 250,
            child: SimpleAnimationProgressBar(
              height: 300,
              width: 15,
              backgroundColor: Colors.grey,
              foregrondColor: Colors.red,
              ratio: _progress,
              direction: Axis.vertical,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 1), // 여기서는 타이머의 시간과 맞춰줍니다.
              borderRadius: BorderRadius.circular(10),
              gradientColor: const LinearGradient(
                colors: [Colors.red, Colors.orange],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          if (_progress <= 0)
            Positioned.fill(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    resetGame();
                  }, // 다시 시작 버튼을 누르면 resetGame 함수를 호출합니다.
                  child: Text('다시 시작'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void bend() {
    Positioned(
      left: 180,
      top: 260,
      child: Image.asset(
        'assets/images/bend.png',
        width: 70,
        height: 70,
      ),
    );
  }

  void applyOintemt() {
    setState(() {
      ointmentApplied = true; // 연고를 발라줌
      isShowingNotification = true; // 알림 표시
    });

    if (woundTreated && ointmentApplied) {
      setState(() {
        isShowingNotification = false; // 상태가 변경되면 알림을 닫음
      });
    }
  }

  void applyBandage() {
    if (!ointmentApplied) {
      // 연고를 발라주지 않은 상태에서 붕대를 적용하려고 시도한 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('치료'),
            content: Text('연고를 먼저 발라야 합니다!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isShowingNotification = false;
                  });
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      // 연고를 발라준 후에 붕대를 적용하는 경우
      setState(() {
        woundTreated = true; // 상처를 치료함
        isShowingNotification = true; // 알림 표시
        ointmentApplied = false;
      });

      // 제한 시간 내에 붕대를 적용한 경우
      if (_progress > 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('너무너'),
              content: Text('날 치료해줘서 너무 고마고!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isShowingNotification = false;
                    });
                    incrementScore();
                  },
                  child: Text('다음'),
                ),
              ],
            );
          },
        );
      } else {
        resetGame(); // 제한 시간 내에 붕대를 적용하지 못한 경우, 게임 초기화
      }
    }
  }

  void resetGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HealingGameScreen()),
    ); // 타이머 재시작
  }

  // void navigateToMainScreen() {
  //   Navigator.of(context).pop();
  // }

  //겹치는 지 확인하는 메소드
  void checkOverlap() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset(hookLeft, hookTop));

    setState(() {
      // 겹치는 지 여부를 확인하고 상태 업데이트
      areWidgetsOverlapping =
          position.dx >= MediaQuery.of(context).size.width - 100 &&
              position.dy >= 400 &&
              position.dy <= 1000;
    });

    if (!areWidgetsOverlapping && !isShowingNotification) {
      // 겹치지 않고 알림을 표시하지 않았을 경우 알림 표시
      showNotification();
    } else {
      // 겹치거나 이미 알림을 표시한 경우 초기 위치로 재설정
      hookLeft = 300;
      hookTop = 400;
    }
  }

  void incrementScore() {
    setState(() {
      // 게임 승리
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GameWinScreen(),
        ),
      );
    });
  }

  // 알림을 표시하는 메소드
  void showNotification() {
    setState(() {
      isShowingNotification = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('너무너'),
          content: Text('이제 내 상처에 연고를 발라주고\n 붕대로 감싸줘!\n 이 순서대로 해죠야대!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isShowingNotification = false;
                });

                //navigateToMainScreen();
              },
              child: Text('다음'),
            ),
          ],
        );
      },
    );
  }
}

class GameWinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('축하해요!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '문어가 화가 단단히 났어요!',
              style: TextStyle(fontSize: 24.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PianoGameApp()),
                );
              },
              child: Text('다음 스테이지로...'),
            ),
          ],
        ),
      ),
    );
  }
}
