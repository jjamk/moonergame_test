import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';

void main() => runApp(MoleGame());

class MoleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: MoleGameScreen(),
    );
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
  List<bool> moles = List.generate(3, (index) => false);
  Timer? gameTimer;
  bool isGameActive = false; // 게임 시작 전 대화 모드로 설정
  bool isDialogueActive = true; // 대화 상태 표시
  int dialogueIndex = 0; // 현재 대화 인덱스
  bool bossAppeared = false; // 보스 문어가 등장했는지 여부

  // 대화 스크립트 정의 (여기서는 예시로 간단한 대화만 추가)
  List<String> dialogues = [
    "어부\n     이제 문어 잡을 시간이야.\n    다른 생물은 잡으면 안 돼.",
    "어부\n     잡는 방법은 튀어나오는 \n     문어를 터치만 하면 돼.\n     쉽지? 한번 해볼래?",
    "어부\n     3번 잘못 잡는다면 문어들이\n     다 도망가서 다시 잡아야 해.",
  ];

  @override
  void initState() {
    super.initState();
  }

  void nextDialogue() {
    if (!mounted) return;
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
    if (!isGameActive) {
      return;
    }
    // // 게임 타이머 설정
    // gameTimer = Timer(Duration(seconds: duration), () {
    //   if (!mounted) return;
    //   setState(() {
    //     gameTimer?.cancel();
    //     gameTimer = null;
    //     isGameActive = false; // 게임 종료
    //     showEndDialog();
    //   });
    // });

    // 1초마다 두더지 생성
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (isGameActive) {
        spawnMole();
      } else {
        timer.cancel();
      }
    });
  }

  void spawnMole() {
    if (!mounted) return;
    if (score >= 5) {
      gameTimer?.cancel();
        // gameTimer = null;
        // isGameActive = false; // 게임 종료
      showBossDialogue();
      return;
    }

    Random random = Random();
    int molePosition = random.nextInt(3);

    setState(() {
      moles = List.generate(3, (index) => index == molePosition);
    });
  }

  void handleMoleTap(int index) {
    if (!mounted) return;
    setState(() {
      if (moles[index]) {
        score++;
        if (score >= 5) {
          gameTimer?.cancel();
        gameTimer = null;
        isGameActive = false; // 게임 종료
          showBossDialogue();
        }
      } else {
        // 클릭을 잘못했을 때 하트 감소
        decrementHearts();
      }
    });
  }

  void restartGame() {
    if (!mounted) return;
    setState(() {
      score = 0;
      hearts = 3; // 하트 초기화
      isGameActive = true;
      bossAppeared = false;
      startGame();
    });
    Navigator.of(context).pop(); // 다이얼로그 닫기
  }

  void decrementHearts() {
    if (!mounted) return;
    setState(() {
      hearts--;
      if (hearts == 0) {
        gameTimer?.cancel();
        gameTimer = null;
        isGameActive = false; // 게임 종료
        showEndDialog();
      }
    });
  }

  void showEndDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Dialog의 배경을 투명하게 설정
          child: Container(
            width: 500,
            height: 400,
            decoration: BoxDecoration(
              // Container의 배경으로 이미지 설정
              image: DecorationImage(
                image: AssetImage('assets/images/result_background.png'), // 이미지 파일 경로
                fit: BoxFit.cover, // 이미지를 Container 크기에 맞게 조정
              ),
              borderRadius: BorderRadius.circular(12), // 모서리를 둥글게
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 0), // 패딩 추가
                  child: Text(
                    '문어가 도망가버렸어요...',
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewStage()),
                );
                      },
                      child: Text('홈으로 돌아가기'),
                    ),
                    SizedBox(width: 10), // Add some space between the buttons
                    ElevatedButton(
                      onPressed: () {
                        restartGame(); // 게임 재시작
                      },
                      child: Text('다시하기'),
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

  void waitForHearts() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (hearts == 0) {
        timer.cancel();
        showEndDialog();
      }
    });
  }

  void showBossDialogue() {
    setState(() {
      isGameActive = false;
      bossAppeared = true;
      isDialogueActive = true;
      dialogues = [
        '아앗! 보스 문어가 화났다!!',
        '우리가 너무 많이 잡았나봐!!',
        '화난 보스 문어를 달래주자!'
      ];
      dialogueIndex = 0;
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
                '#stage 1',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              left: 180,
              top: 200,
              child: Text(
                  '점수: $score',
                  style: TextStyle(fontSize: 24),
                ),),
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                if (!bossAppeared)
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(180, 350, 0,300),
                        child: GestureDetector(
                          onTap: () {
                            if (isGameActive) {
                              handleMoleTap(0);
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white, // Set the circle background to white
                              image: DecorationImage(
                                image: AssetImage(
                                  moles[0]
                                      ? 'assets/images/normal_mooner_x.png'
                                      : 'assets/images/jellyfish.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(80, 470, 80,100),
                        child: GestureDetector(
                          onTap: () {
                            if (isGameActive) {
                              handleMoleTap(1);
                            }
                          },
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white, // Set the circle background to white
                              image: DecorationImage(
                                image: AssetImage(
                                  moles[1]
                                      ? 'assets/images/normal_mooner_x.png'
                                      : 'assets/images/jellyfish.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 350, 150,300),
                        child: GestureDetector(
                          onTap: () {
                            if (isGameActive) {
                              handleMoleTap(2);
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white, // Set the circle background to white
                              image: DecorationImage(
                                image: AssetImage(
                                  moles[2]
                                      ? 'assets/images/normal_mooner_x.png'
                                      : 'assets/images/jellyfish.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (bossAppeared)
              Center(
                child: Image.asset('assets/images/normal_mooner_x.png', width: 200, height: 200),
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
  child: GestureDetector(
    onTap: nextDialogue,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/fisher.png',
            width: 130, // Set the width as needed
            height: 130, // Set the height as needed
            fit: BoxFit.cover,
          ), // Add some space between the image and the dialog background
          Expanded(
            child: Container(
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/dialog_background.png"),
                  fit: BoxFit.contain,
                ),
              ),
              child: Text(
                dialogues[dialogueIndex],
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
)



                  ],
                ),
        )
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
