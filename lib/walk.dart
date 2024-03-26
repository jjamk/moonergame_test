import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: walkGame(),
    );
  }
}

class walkGame extends StatefulWidget {
  @override
  _walkGameState createState() => _walkGameState();
}

class _walkGameState extends State<walkGame> {
  double yPos = 0; // T-Rex의 수직 위치
  bool isJumping = false;
  double gravity = -3.0;
  double velocity = 0;
  Timer? _jumpTimer;
  double obstacleX = 1; // 장애물의 위치
  int score = 0; // 점수
  bool isGameOver = false; // 게임 오버 상태

  void startJump() {
  if (!isJumping && !isGameOver) {
    isJumping = true;
    velocity = 50; // 초기 점프 속도를 증가
    _jumpTimer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      final double newVelocity = velocity + gravity; // 속도 업데이트
      setState(() {
        yPos += velocity + 0.5 * gravity;
        velocity = newVelocity;
      });
      if (yPos <= 0) { // 바닥에 닿으면 점프 중지
        yPos = 0;
        isJumping = false;
        timer.cancel();
      }
    });
  }
}

  void startGame() {
    isGameOver = false;
    yPos = 0;
    score = 0;
    obstacleX = 1;
    _jumpTimer?.cancel();
    startObstacleMovement();
  }

  void startObstacleMovement() {
  Timer.periodic(Duration(milliseconds: 20), (timer) {
    if (!isGameOver) {
      setState(() {
        obstacleX -= 0.02; // 장애물의 이동 속도 증가
      });
      if (obstacleX < -0.2) {
        obstacleX = 1;
        score += 10; // 장애물을 피할 때마다 점수 증가
      }

      // 충돌 검사
      if (obstacleX < 0.2 && obstacleX > 0 && yPos < 50) {
        timer.cancel();
        isGameOver = true;
        // 게임 오버 시 추가적인 처리를 여기에 구현할 수 있습니다.
      }
    } else {
      timer.cancel();
    }
  });
}


  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter T-Rex Game"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 장애물
                AnimatedContainer(
                  alignment: Alignment(obstacleX, 1),
                  duration: Duration(milliseconds: 0),
                  child: Container(
                    width: 20,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
                // T-Rex
                AnimatedPositioned(
                  duration: Duration(milliseconds: 0),
                  bottom: yPos,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Text("Score: $score", style: TextStyle(fontSize: 20)),
          if (isGameOver)
            Text(
              "Game Over",
              style: TextStyle(color: Colors.red, fontSize: 24),
            ),
          ElevatedButton(
            onPressed: isGameOver ? startGame : startJump,
            child: Text(isGameOver ? 'Restart' : 'Jump'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _jumpTimer?.cancel();
    super.dispose();
  }
}
