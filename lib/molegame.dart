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

class MoleGameScreen extends StatefulWidget {
  @override
  State<MoleGameScreen> createState() => _MoleGameScreenState();
}

class _MoleGameScreenState extends State<MoleGameScreen> {
  int score = 0;
  int hearts = 3;
  int retry= 0;
  int duration = 10;
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
    // TODO: implement initState
    super.initState();
    //myBanner = GoogleAdMob.loadBannerAd();
    //myBanner.load();
    //startGame();
  }

  void nextDialogue() {
    setState(() {
      dialogueIndex++;
      if (dialogueIndex >= dialogues.length) {
        isDialogueActive = false; // 대화 종료
        startGame(); // 게임 시작
      }
    });
  }

  void startGame() {
    gameTimer = Timer.periodic(Duration(seconds: duration), (timer) {
    setState(() {
      timer.cancel();
      gameTimer = null;
      isGameActive = true;
      

      // 점수가 5 이상인 경우
      if (score >= 5) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameWinScreen(),
          ),
        );
      }
      // 하트가 0개 이하인 경우
      else if (hearts <= 0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameOverScreen(),
          ),
        );
      }
      // 하트가 0개 이상인 경우
      else {
        decrementHearts();
      }
    });
  });

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
      }
    });
  }

  void restartGame() {
    setState(() {
      score = 0;
      isGameActive = true;
      startGame();
    });
  }

  

  @override
  void dispose() {
    // TODO: implement dispose
    gameTimer?.cancel();
    //_banner.dispose();

    super.dispose();
  }

  void incrementScore() {
    setState(() {
      score++;
      if (score >= 5) {
        // 게임 승리
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameWinScreen(),
          ),
        );
      }
    });
  }
  void decrementHearts() {
    setState(() {
      hearts--;
      if (hearts == 0) {
        // 게임 종료
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameOverScreen(),
          ),
        );
      }
    });
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
                      crossAxisCount: 3),
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
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              restartGame();
                            },
                            child: Text('다시하기'),
                          )
                        ]),
                  )),
            Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                children: <Widget>[
                       HeartWidget(hearts),   // 두 번째 아이콘
                ]),
              backgroundColor: Colors.transparent, // AppBar 배경을 투명하게 설정
              elevation: 0, // 그림자 제거
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    // 설정 버튼 클릭 시 실행할 액션
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
          ]
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