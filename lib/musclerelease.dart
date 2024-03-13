import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; //플러터에서 lotti 애니메이션을 표시하기 위한 패키지

void main() => runApp(MusclereleaseGameApp());

class MusclereleaseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusclereleaseGameScreen(),
    );
  }
}

class MusclereleaseGameScreen extends StatefulWidget {
  @override
  _MusclereleaseGameScreenState createState() => _MusclereleaseGameScreenState();
}

class _MusclereleaseGameScreenState extends State<MusclereleaseGameScreen> {
  bool isLongPressed = false;
  late Offset _startPosition;
  int countdown = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPressStart: (details) {
          // 길게 눌렀을 때
          setState(() {
            isLongPressed = true;
            _startPosition = details.globalPosition; // 드래그의 시작 위치 저장
          });

          startCountdown();
        },
        onLongPressEnd: (details) {
          // 눌렀다 뗐을 때
          if (isLongPressed) {
            double verticalDistance = details.globalPosition.dy - _startPosition.dy;
            double horizontalDistance = details.globalPosition.dx - _startPosition.dx;

            if (verticalDistance > 0 && countdown == 0) {
              // 아래로 이동한 경우 및 5초 동안 누르고 있었을 때
              showNotification('화가 풀렸어요!');
            }  else if (verticalDistance > 0 && countdown != 0) {
              // 아래로 이동한 경우
              showNotification('아래쪽으로 이동했어요! 5초 동안 누르고 있어야해요!');
            } else if (verticalDistance < 0 && countdown != 0) {
              // 위로 이동한 경우
              showNotification('위쪽으로 이동했어요! 5초 동안 누르고 있어야해요!');
            } else if (horizontalDistance > 0 && countdown != 0) {
              // 오른쪽으로 이동한 경우
              showNotification('오른쪽으로 이동했어요! 5초 동안 누르고 있어야해요!');
            } else if (horizontalDistance < 0 && countdown != 0) {
              // 왼쪽으로 이동한 경우
              showNotification('왼쪽으로 이동했어요! 5초 동안 누르고 있어야해요!');
            }

            setState(() {
              isLongPressed = false;
              countdown = 5; // 초기화
            });
          }
        },
        child: Stack(
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
              child: Image.asset(
                'assets/images/mooner.png',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            if (isLongPressed) // isLongPressed가 true일 때만 countdown을 표시
              Positioned(
                top: 20.0,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '$countdown',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);

    Timer.periodic(oneSecond, (timer) {
      if (!isLongPressed) {
        timer.cancel(); // 누르는 도중에 눌린 것이 해제된 경우 카운트 다운 중단
      } else if (countdown == 0) {
        timer.cancel();
        // 5초 동안 누르고 있었을 때
        setState(() {
          isLongPressed = false;
        });
        showNotification('5초 동안 눌렀어요!');
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  void showNotification(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

