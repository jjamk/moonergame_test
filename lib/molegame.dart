import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';

void main() => runApp(MoleGame());
class MoleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new MoleGameScreen());
  }
}

class MoleGameScreen extends StatefulWidget {
  @override
  State<MoleGameScreen> createState() => _MoleGameScreenState();
}

class _MoleGameScreenState extends State<MoleGameScreen> {
  int score = 0;
  int hearts = 3;
  int retry = 0;
  int duration = 30; // 게임 시간
  List<bool> moles = List.generate(9, (index) => false);
  Timer? gameTimer;
  bool isGameActive = false; // 게임 시작 전 대화 모드로 설정
  bool isDialogueActive = true; // 대화 상태 표시
  int dialogueIndex = 0; // 현재 대화 인덱스

  // 대화 스크립트 정의 (여기서는 예시로 간단한 대화만 추가)
  List<String> dialogues = [
    "이제 문어 잡을 시간이야. 다른 생물은 잡으면 안 돼.",
    "잡는 방법은 튀어나오는 문어를 클릭만 하면 돼. 쉽지? 한번 해볼래?",
    "3번 잘못 잡는다면 문어들이 다 도망가서 다시 잡아야 해.",
  ];

  @override
  void initState() {
    super.initState();
  }

  void nextDialogue() {
  setState(() {
    dialogueIndex++;
    if (dialogueIndex >= dialogues.length) {
      isDialogueActive = false; // 대화 종료
      isGameActive = true; // 게임 시작
      startGame();
    }
  });
}

  void startGame() {
    if (!isGameActive)
    {
      return ;
    }
    // 게임 타이머 설정
    gameTimer = Timer.periodic(Duration(seconds: duration), (timer) {
      setState(() {
        timer.cancel();
        gameTimer = null;
        isGameActive = false; // 게임 종료
        // 점수가 5 이상이면 게임 승리
        if (score >= 5) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => GameWinScreen(),
            ),
          );
        }
        // 점수가 5 미만이면 하트가 0이 될 때까지 기다림
        else {
          waitForHearts();
        }
      });
    });

    // 1초마다 두더지 생성
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (isGameActive) {
        spawnMole();
      } else {
        timer.cancel();
      }
    });
  }

  void spawnMole() {
    Random random = Random();
    int molePosition = random.nextInt(9);

    setState(() {
      moles = List.generate(9, (index) => index == molePosition);
    });
  }

  void handleMoleTap(int index) {
    setState(() {
      if (moles[index]) {
        score++;
      } else {
        // 클릭을 잘못했을 때 하트 감소
        decrementHearts();
      }
    });
  }

  void restartGame() {
  setState(() {
    score = 0;
    hearts = 3; // 하트 초기화
    isGameActive = true;
    startGame();
  });
}


  void decrementHearts() {
    setState(() {
      hearts--;
      if (hearts == 0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameOverScreen(),
          ),
        );
      }
    });
  }

  void waitForHearts() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (hearts == 0) {
        timer.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameOverScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
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
                '#stage 0',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '점수: $score',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (isGameActive) {
                          handleMoleTap(index);
                        }
                      },
                      child: Image.asset(
                        moles[index]
                            ? 'assets/images/mooner.png'
                            : 'assets/images/doodeo.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  itemCount: 9,
                ),
              ],
            ),
            if (!isGameActive && !isDialogueActive)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Game Over\n score: $score',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          restartGame();
                        },
                        child: Text('다시하기'),
                      )
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HeartWidget(hearts), // 두 번째 아이콘
                  ],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      print('Settings button pressed');
                    },
                  ),
                ],
              ),
            ),
            if (isDialogueActive) // 대화 창 표시
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dialogues[dialogueIndex],
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: nextDialogue,
                        child: Text('다음'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class GameOverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '문어가 도망가버렸어요...',
              style: TextStyle(fontSize: 24.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewStage()),
                      );
              },
              child: Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameWinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Congratulations!'),
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
                        MaterialPageRoute(builder: (context) => NewStage()),
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

class HeartWidget extends StatelessWidget {
  final int heartsCount;
  HeartWidget(this.heartsCount);
  

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        if (index < heartsCount) {
          return Icon(
            Icons.favorite,
            color: Colors.red,
          );
        } else {
          return Icon(
            Icons.favorite_border,
            color: Colors.grey,
          );
        }
      }),
    );
  }
}