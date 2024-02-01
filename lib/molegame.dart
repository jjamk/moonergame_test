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
  int duration = 10;
  List<bool> moles = List.generate(9, (index) => false);
  Timer? gameTimer;
  bool isGameActive = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //myBanner = GoogleAdMob.loadBannerAd();
    //myBanner.load();
    startGame();
  }

  void startGame() {
    gameTimer = Timer.periodic(Duration(seconds: duration), (timer) {
    setState(() {
      timer.cancel();
      gameTimer = null;
      isGameActive = false;

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
            if (!isGameActive)
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