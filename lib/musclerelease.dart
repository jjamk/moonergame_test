//할 일: 실패시 프로그래스바 감소

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mooner_interface/exercise.dart';
import 'package:mooner_interface/stage.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

void main() => runApp(MusclereleaseGameApp());

//글씨체
class MusclereleaseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: MusclereleaseGameScreen(),
    );
  }
}

class StarWidget extends StatelessWidget {
  final int starsCount;
  StarWidget(this.starsCount);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        if (index < starsCount) {
          return Icon(
            Icons.star,
            color: Colors.yellow,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: Colors.grey,
          );
        }
      }),
    );
  }
}

class MusclereleaseGameScreen extends StatefulWidget {
  @override
  _MusclereleaseGameScreenState createState() =>
      _MusclereleaseGameScreenState();
}

class _MusclereleaseGameScreenState extends State<MusclereleaseGameScreen> {
  bool isLongPressed = false;
  late Offset _startPosition;
  int countdown = 7;
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  Timer? _countdownTimer;
  int successCount = 0; // 성공 횟수
  int stars = 0; // 별 갯수
  int failCount = 0; // 실패 횟수
  double _progress = 1.0;

  List<String> dialogues = [
    '문찌가 화를 내다가 다리가 다 꼬였어\n 근육을 풀어줘야 할 것 같아',
    '꼬인 다리는 급하게 풀려고 하면 더 안 풀려! \n 힘을 천천히 줬다가 한번에 툭!하고 풀어보자',
    '문찌의 다리르 7초 동안 꾹 눌렀다가 아래로 툭 내려서 힘을 풀어줄거야. \n 한번 해보자',
  ];

  @override
  void initState() {
    super.initState();
  }

  void nextDialogue() {
    setState(() {
      dialogueIndex++;
      if (dialogueIndex >= dialogues.length) {
        isDialogueActive = false;
        startGame();  // 다이얼로그가 끝나면 게임이 시작됩니다.
      }
    });
  }

  void startGame() {
    setState(() {
      isGameActive = true;
    });
  }

  void resetGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MusclereleaseGameScreen()),
    ); // 타이머 재시작
  }  

  void restartGame() {
    setState(() {
      successCount = 0; // 성공 횟수 초기화
      stars = 0; // 별 갯수 초기화
      failCount = 0; // 실패 횟수 초기화
      isGameActive = true;
      startGame();
    });
  }

  void startCountdown() {
    setState(() {
      countdown = 7;
    });

    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        if (isLongPressed) {
          setState(() {
            isLongPressed = false;
            showNotification("7초 동안 누르고 아래로 이동하세요!");
          });
        }
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

  void updateStars() {
    if (successCount >= 4) {
      stars = 3;
    } else if (successCount >= 3) {
      stars = 2;
    } else if (successCount >= 2) {
      stars = 1;
    } else {
      stars = 0;
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPressStart: (details) {
          setState(() {
            isLongPressed = true;
            _startPosition = details.globalPosition;
            startCountdown();
          });
        },
        onLongPressEnd: (details) {
          if (isLongPressed) {
            double verticalDistance = details.globalPosition.dy - _startPosition.dy;

            if (verticalDistance > 0 && countdown == 0) {
              setState(() {
                successCount++;
              });

              if (successCount >= 4) {
                // Move to GameWinScreen
                updateStars();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GameWinScreen(stars: stars),
                  ),
                );
              } else {
                updateStars();
                showNotification('성공했어요!');
              }
            } else {
              setState(() {
                failCount++;
                // 실패 시 프로그레스바 감소
                _progress -= 0.25;  // 4번 시도 중 한 번 실패하면 25% 감소
                if (_progress < 0) _progress = 0;                
              });

              if (failCount >= 3) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GameOverScreen(),
                  ),
                );
              } else {
                showNotification('7초 동안 누르고 이동해야해요! 다시 한 번 해보세요!');
              }
            }

            setState(() {
              isLongPressed = false;
            });
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //배경 이미지
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_stage.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 중앙에 문어 이미지를 표시
            Positioned(
              child: Center(
                child: SvgPicture.asset('assets/images/normal_mooner_o.svg',
                    width: 200, height: 270, fit: BoxFit.cover),
              ),
            ),
              if (!isLongPressed & !isDialogueActive) // 게임이 시작되기 전일 때만 빨간색 원과 화살표 표시
                Positioned(
                  left: 120, // 조정이 필요할 수 있습니다.
                  top: 420, // 조정이 필요할 수 있습니다.
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.5),
                    ),
                  ),
                ),
              if (!isLongPressed & !isDialogueActive) // 게임이 시작되기 전일 때만 빨간색 화살표 표시
                Positioned(
                  left: 127, // 조정이 필요할 수 있습니다.
                  top: 471, // 조정이 필요할 수 있습니다.
                  child: Transform.rotate(
                    angle: -0.0, // 화살표 회전 (필요에 따라 조정)
                    child: Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),

            //상단 스테이지 배경 내용            
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
                '#stage 4',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              left: 200, 
              top: 65, 
              child: Text(
                '근육 이완하기', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black),)),
            // 별 프로그레스 바
            Positioned(
              left: 56,
              top: 200,
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      child: SimpleAnimationProgressBar(
                        height: 30,
                        width: 330,
                        backgroundColor: Colors.grey,
                        foregrondColor: Colors.red,
                        ratio: (successCount / 4).clamp(0.0, 1.0), // 이 부분을 수정했습니다.
                        //ratio: _progress,  // 성공 및 실패에 따라 업데이트되는 비율
                        direction: Axis.horizontal,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(seconds: 1),
                        borderRadius: BorderRadius.circular(10),
                        gradientColor: const LinearGradient(
                          colors: [Colors.red, Colors.orange],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -45,
                      top: -40, // 별 이미지를 약간 위로 올리기 위해 top 값 조정
                      child: Image.asset(
                        'assets/images/star.png', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      left: 105,
                      top: -40, // 중앙 별 이미지의 위치
                      child: Image.asset(
                        'assets/images/star.png', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      right: -45,
                      top: -40, // 오른쪽 끝 별 이미지의 위치
                      child: Image.asset(
                        'assets/images/star.png', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    ),
                  ],
                ),
              ),
            ),                       
            if (!isGameActive && !isDialogueActive)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TRY\n AGAIN',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: restartGame,
                        child: Text('다시하기'),
                      ),                          
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 10,
              left: 50,
              right: 0,
              child: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StarWidget(stars)
                  ],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false, // 이 부분을 추가하여 뒤로가기 화살표 없앰
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
                    children: [Image.asset(
                      'assets/images/fisher.png',
                      width: 130, // Set the width as needed
                      height: 130, // Set the height as needed
                      fit: BoxFit.cover,), // Add some space between the image and the dialog background
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
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
            if (isLongPressed)
              Text(
                '남은 시간: $countdown 초',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
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
            // Stack to place text and button inside the image
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/ink.png',
                  width: 600,
                  height: 700,
                  fit: BoxFit.contain,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TRY \n AGAIN',
                      style: TextStyle(
                        fontSize: 48.0, // Adjust the font size as needed
                        color: Colors.white, // Text color
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0), // Space between text and button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewStage()),
                        );
                      },
                      child: Text('홈으로 돌아가기'),
                    ),
                    SizedBox(height: 10.0), // Space between buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusclereleaseGameApp()),
                        );
                      },
                      child: Text('광고보고 재도전하기'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GameWinScreen extends StatelessWidget {
  final int stars;
  GameWinScreen({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Stack to place text and button inside the image
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/result_background.png',
                  width: 400,
                  height: 500,
                  fit: BoxFit.contain,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '! STAGE CLEAR !',
                      style: TextStyle(
                        fontSize: 30.0, // Adjust the font size as needed
                        color: Colors.white, // Text color
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0), // Space between text and button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewStage()),
                        );
                      },
                      child: Text('다음 스테이지로'),
                    ),
                    SizedBox(height: 10.0), // Space between buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusclereleaseGameApp()),
                        );
                      },
                      child: Text('광고보고 재도전하기'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}