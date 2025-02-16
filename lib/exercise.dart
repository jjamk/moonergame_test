//복싱 덤벨 스쿼트
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sensors/sensors.dart';
import 'package:mooner_interface/stage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:lottie/lottie.dart';

class BackgroundScreen extends StatefulWidget {
  final VoidCallback onBackgroundTap; // 배경 클릭 시 호출되는 콜백 함수

  BackgroundScreen({required this.onBackgroundTap});

  @override
  _BackgroundScreenState createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends State<BackgroundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 이미지(bg_stage.png)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_stage.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 클릭 가능한 result_background.png
          GestureDetector(
            onTap: widget.onBackgroundTap,
            child: Stack(
              alignment: Alignment.center, // 텍스트를 이미지 중앙에 위치
              children: [
                // result_background.png 이미지
                Container(
                  width: 400, 
                  height: 300, 
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/result_background.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // 이미지 위에 표시할 텍스트
                Positioned(
                  top: 135, 
                  child: Text(
                    'STAGE 4', 
                    style: TextStyle(
                      fontSize: 25, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 165, 
                  child: Text(
                    '운동하기', 
                    style: TextStyle(
                      fontSize: 25, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
                Positioned(
                  top: 200, 
                  child: Text(
                    '\t 운동을 시켜 \n 문찌를 힘들게 하자.', 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white
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

class ExerciseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: BackgroundScreen(
        onBackgroundTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseSelectionScreen(),
            ),
          );
        },
      ),
    );
  }
}

// 다이얼로그 + 운동 선택 화면
class ExerciseSelectionScreen extends StatefulWidget {
  @override
  _ExerciseSelectionScreenState createState() => _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState extends State<ExerciseSelectionScreen> {
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;

  List<String> dialogues = [
    "어부\n 문찌의 기분을 풀어주기 위해 \n 같이 운동을 해보자",
    "어부\n 다음 화면에 나오는 운동 중에 \n 마음에 드는 운동을 클릭해봐",
  ];

  @override
  void initState() {
    super.initState();
  }

  // 다이얼로그 진행 함수
  void nextDialogue() {
    setState(() {
      dialogueIndex++;
      if (dialogueIndex >= dialogues.length) {
        isDialogueActive = false;
        startGame();
      }
    });
  }

  // 게임 시작 함수
  void startGame() {
    setState(() {
      isGameActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 배경 이미지 표시
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 상단 스테이지 번호
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
              '#stage 4',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            left: 150, 
            top: 65, 
            child: Text(
              '운동하기', 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Colors.black),
            )
          ),         
          // 문찌 이미지 중앙에 표시
          Positioned(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/3angry_mooner_o.svg',
                width: 200,
                height: 270,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 다이얼로그가 활성화된 경우
          if (isDialogueActive)
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
                      SvgPicture.asset(
                        'assets/images/fisherman_front.svg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Container(
                          width: 200,
                          height: 130,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/dialog_background.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                            dialogues[dialogueIndex],
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // 게임이 활성화된 경우 운동 선택 화면
          if (isGameActive)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 40), // Mooner 이미지와 버튼 사이의 간격
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 가로로 배치
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BoxingGameScreen()),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/boxing.svg',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      SizedBox(width: 20), // 버튼들 사이의 간격
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DumbelGameScreen()),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/dumbbell.svg',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      SizedBox(width: 20), // 버튼들 사이의 간격
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JumpRopeGameScreen()),
                          );
                        },
                        child: Text('스쿼트'),
                      ),
                    ],
                  ),
                  SizedBox(height: 80), // 버튼들 아래의 여백
                ],
              ),
            ),
        ],
      ),
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
            //color: Colors.grey,
          );
        }
      }),
    );
  }
}

//복싱
class BoxingGameScreen extends StatefulWidget {
  @override
  _BoxingGameScreenState createState() => _BoxingGameScreenState();
}

class _BoxingGameScreenState extends State<BoxingGameScreen> {
  int stars = 0;
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  int exCount = 0; // 운동 횟수 = 퍼칭 수
  double threshold = 30.0; // 흔들림을 감지하기 위한 임계값
  bool isShaking = false;
  late Timer _timer;
  int _countDown = 30;
  late AudioPlayer _audioPlayer;

  List<String> dialogues = [
    "어부\n 문찌의 행동을 따라서 \n 같이 움직여보자",
    "어부\n 3분 안에 000개를 채우면 \n 문찌를 진정시킬 수 있어",
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();    
    _startListening();
  }

  void nextDialogue() {
    setState(() {
      dialogueIndex++;
      if (dialogueIndex >= dialogues.length) {
        isDialogueActive = false;
        startGame(); //다이얼로그가 끝나면 게임 시작
        _startTimer();
      }
    });
  }

  void startGame() {
    setState(() {
      isGameActive = true;
    });
  }

  void restartGame() {
    setState(() {
      stars = 0;
      exCount = 0;
      _countDown = 30;
      isGameActive = true;
      isDialogueActive = true;
      dialogueIndex = 0;
      _startTimer();
    });
  }

  void _startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      // 가속도 데이터를 받아와 흔들림 감지
      double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
      if (magnitude > threshold && !isShaking) {
        setState(() {
          exCount++;
          isShaking = true;

          _audioPlayer.play(AssetSource('audio/boxing.mp3'));

          // 운동 횟수에 따라 별 업데이트
          if (exCount >= 20) {
            stars = 3;
          } else if (exCount >= 15) {
            stars = 2;
          } else if (exCount >= 10) {
            stars = 1;
          } else {
            stars = 0;
          }

          if (stars == 3) {
            // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
            _timer.cancel();
            Navigator.push(
              context,
            MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
            );
          }

        });
      } 
      else if (magnitude <= threshold) {
        isShaking = false;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countDown == 0) {
        timer.cancel();
        if (stars == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
          );
        }
      } else {
        setState(() {
          _countDown--;
        });
      }
    });
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
          //상단 스테이지번호
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
              '#stage 4',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
            Positioned(
              left: 150, 
              top: 65, 
              child: Text(
                '운동하기-복싱', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black),)),
                  // 별 프로그레스 바
                  Positioned(
                    left: 30,
                    top: 150,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            child: SimpleAnimationProgressBar(
                              height: 30,
                              width: 300,
                              backgroundColor: Colors.grey,
                              foregrondColor: Colors.red,
                              ratio: (exCount / 30).clamp(0.0, 1.0), // 0~100% 채워지는거 이 부분을 수정했습니다.
                              //ratio: _progress,  // 100~0% 줄어드는거 성공 및 실패에 따라 업데이트되는 비율
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
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                          Positioned(
                            left: 105,
                            top: -40, // 중앙 별 이미지의 위치
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                          Positioned(
                            right: -45,
                            top: -40, // 오른쪽 끝 별 이미지의 위치
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                  ],
                ),
              ),
            ), 
          // 중앙에 플레이어 이미지를 표시
          // Positioned(
          //   child: Center(
          //     child: SvgPicture.asset('assets/images/3angry_mooner_o.svg',
          //         width: 200, height: 270, fit: BoxFit.cover),
          //   ),
          // ),
          Positioned(
            left: 30, top: 250,
            child: Center(child: Lottie.asset(
              'assets/json/exercise_boxing.json',
              width: 200, height: 270, fit: BoxFit.cover
              ),
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
                    children: [SvgPicture.asset(
                      'assets/images/fisherman_front.svg',
                      width: 120, // Set the width as needed
                      height: 120, // Set the height as needed
                      fit: BoxFit.cover,), // Add some space between the image and the dialog background
                      Expanded(
                        child: Container(
                          width: 200,
                          height: 130,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/dialog_background.png"),
                              fit: BoxFit.cover,
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
              Positioned(
                top: 200,
                right: 20,
                child: Text(
                  '남은 시간: $_countDown 초',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Positioned(
                top: 220,
                //left: MediaQuery.of(context).size.width / 2 - 150,
                right: 20,
                child: Column(
                  children: <Widget>[
                    Text(
                      '운동 횟수: $exCount', 
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

//스쿼트
class JumpRopeGameScreen extends StatefulWidget {
  @override
  _JumpRopeGameScreenState createState() => _JumpRopeGameScreenState();
}

class _JumpRopeGameScreenState extends State<JumpRopeGameScreen> {
  int stars = 0;
  bool isGameActive = false;
  int dialogueIndex = 0;
  int jumpCount = 0;
  double threshold = 2.0; // 점프 감지 임계값
  bool isJumping = false;
  bool isDialogueActive = true;
  late Timer _timer;
  int _countDown = 30;

  List<String> dialogues = [
    "어부\n 문찌의 행동을 따라서 \n 같이 움직여보자",
    "어부\n 3분 안에 000개를 채우면 \n 문찌를 진정시킬 수 있어",
  ];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void nextDialogue() {
    setState(() {
      dialogueIndex++;
      if (dialogueIndex >= dialogues.length) {
        isDialogueActive = false;
        startGame();
        _startTimer();
      }
    });
  }

  void startGame() {
    setState(() {
      isGameActive = true;
    });
  }

  void restartGame() {
    setState(() {
      stars = 0;
      jumpCount = 0;
      _countDown = 30;
      isGameActive = true;
      _startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }  

  void _startListening() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      // Y축 가속도를 이용하여 점프 감지
      if (event.y > threshold && !isJumping) {
        setState(() {
          jumpCount++;
          isJumping = true;

          // 점프 횟수에 따라 별 업데이트
          if (jumpCount >= 20) {
            stars = 3;
          } else if (jumpCount >= 15) {
            stars = 2;
          } else if (jumpCount >= 10) {
            stars = 1;
          } else {
            stars = 0;
          }

          if (stars == 3) {
            // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
            _timer.cancel();
            MaterialPageRoute(builder: (context) => GameWinScreen(restartGame));
          }
        });
      } else if (event.y <= threshold) {
        isJumping = false;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countDown == 0) {
        timer.cancel();
        if (stars == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
          );
        }
      } else {
        setState(() {
          _countDown--;
        });
      }
    });
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
          // 상단 스테이지 번호
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
              '#stage 4',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
            Positioned(
              left: 150, 
              top: 65, 
              child: Text(
                '운동하기 - 스쿼트', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black),)),
                  // 별 프로그레스 바
                  Positioned(
                    left: 30,
                    top: 150,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            child: SimpleAnimationProgressBar(
                              height: 30,
                              width: 300,
                              backgroundColor: Colors.grey,
                              foregrondColor: Colors.red,
                              ratio: (jumpCount / 30).clamp(0.0, 1.0), // 0~100% 채워지는거 이 부분을 수정했습니다.
                              //ratio: _progress,  // 100~0% 줄어드는거 성공 및 실패에 따라 업데이트되는 비율
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
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                          Positioned(
                            left: 105,
                            top: -40, // 중앙 별 이미지의 위치
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                          Positioned(
                            right: -45,
                            top: -40, // 오른쪽 끝 별 이미지의 위치
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                  ],
                ),
              ),
            ),          
          // 중앙에 플레이어 이미지를 표시
          Positioned(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/normal_mooner_o.svg',
                width: 200,
                height: 270,
                fit: BoxFit.cover,
              ),
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
                    children: [SvgPicture.asset(
                      'assets/images/fisherman_front.svg',
                      width: 120, // Set the width as needed
                      height: 120, // Set the height as needed
                      fit: BoxFit.cover,), // Add some space between the image and the dialog background
                      Expanded(
                        child: Container(
                          width: 200,
                          height: 130,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/dialog_background.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                          dialogues[dialogueIndex],
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
              Positioned(
                top: 200,
                right: 20,
                child: Text(
                  '남은 시간: $_countDown 초',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Positioned(
                top: 220,
                //left: MediaQuery.of(context).size.width / 2 - 150,
                right: 20,
                child: Column(
                  children: <Widget>[
                    Text(
                      '운동 횟수: $jumpCount', 
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class DumbelGameScreen extends StatefulWidget {
  @override
  _DumbelGameScreenState createState() => _DumbelGameScreenState();
}

class _DumbelGameScreenState extends State<DumbelGameScreen> {
  int stars = 0;
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  int dumbelcount = 0; // 운동 횟수
  double threshold = 20.0; // 흔들림을 감지하기 위한 임계값
  bool isShaking = false;
  late Timer _timer;
  int _countDown = 30;

  List<String> dialogues = [
    "어부\n 문찌의 행동을 따라서 \n 같이 움직여보자",
    "어부\n 3분 안에 000개를 채우면 \n 문찌를 진정시킬 수 있어",
  ];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void nextDialogue() {
    setState(() {
      dialogueIndex++;
      if (dialogueIndex >= dialogues.length) {
        isDialogueActive = false;
        startGame();
        _startTimer();

      }
    });
  }

  void startGame() {
    setState(() {
      isGameActive = true;
    });
  }

  void restartGame() {
    setState(() {
      stars = 0;
      dumbelcount = 0;
      _countDown = 30;
      isGameActive = true;
      isDialogueActive = true;
      dialogueIndex = 0;
      _startTimer();
    });
  }

  void _startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      // 가속도 데이터를 받아와 흔들림 감지
      double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
      if (magnitude > threshold && !isShaking) {
        setState(() {
          dumbelcount++;
          isShaking = true;

          // 운동 횟수에 따라 별 업데이트
          if (dumbelcount >= 20) {
            stars = 3;
          } else if (dumbelcount >= 15) {
            stars = 2;
          } else if (dumbelcount >= 10) {
            stars = 1;
          } else {
            stars = 0;
          }

          if (stars == 3) {
            // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
            _timer.cancel();
            Navigator.push(
              context,
            MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
            );
          }

        });
      } 
      else if (magnitude <= threshold) {
        isShaking = false;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countDown == 0) {
        timer.cancel();
        if (stars == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
          );
        }
      } else {
        setState(() {
          _countDown--;
        });
      }
    });
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
          //상단 스테이지번호
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
              '#stage 4',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
            Positioned(
              left: 150, 
              top: 65, 
              child: Text(
                '운동하기 - 덤벨', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black),)),
                  // 별 프로그레스 바
                  Positioned(
                    left: 30,
                    top: 150,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            child: SimpleAnimationProgressBar(
                              height: 30,
                              width: 300,
                              backgroundColor: Colors.grey,
                              foregrondColor: Colors.red,
                              ratio: (dumbelcount / 30).clamp(0.0, 1.0), // 0~100% 채워지는거 이 부분을 수정했습니다.
                              //ratio: _progress,  // 100~0% 줄어드는거 성공 및 실패에 따라 업데이트되는 비율
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
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                          Positioned(
                            left: 105,
                            top: -40, // 중앙 별 이미지의 위치
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                          Positioned(
                            right: -45,
                            top: -40, // 오른쪽 끝 별 이미지의 위치
                            child: SvgPicture.asset(
                              'assets/images/star.svg', // 별 이미지 경로
                              width: 110,
                              height: 110,
                            ),
                          ),
                  ],
                ),
              ),
            ),          
          // 중앙에 플레이어 이미지를 표시
            Positioned(
              left: 30, top: 250,
              child: Center(child: Lottie.asset(
                'assets/json/exercise_dumbbell.json',
                width: 200, height: 270, fit: BoxFit.cover
                ),
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
                    children: [SvgPicture.asset(
                      'assets/images/fisherman_front.svg',
                      width: 120, // Set the width as needed
                      height: 120, // Set the height as needed
                      fit: BoxFit.cover,), // Add some space between the image and the dialog background
                      Expanded(
                        child: Container(
                          width: 200,
                          height: 130,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/dialog_background.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                          dialogues[dialogueIndex],
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
              Positioned(
                top: 200,
                right: 20,
                child: Text(
                  '남은 시간: $_countDown 초',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Positioned(
                top: 220,
                //left: MediaQuery.of(context).size.width / 2 - 150,
                right: 20,
                child: Column(
                  children: <Widget>[
                    Text(
                      '운동 횟수: $dumbelcount', 
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}


class GameOverScreen extends StatelessWidget {

  final VoidCallback restartGame;
  GameOverScreen(this.restartGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_stage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Stack to place text and button inside the image
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/big_ink.svg',
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
                          fontSize: 30.0,
                          color: Colors.white,
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
                      SizedBox(height: 5.0), // Space between text and button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewStage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
                          minimumSize: Size(100, 40), // Reduce button size
                        ),
                        child: Text('홈으로 돌아가기'),
                      ),
                      SizedBox(height: 5.0), // Space between buttons
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExerciseGameApp()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
                          minimumSize: Size(100, 40), // Reduce button size
                        ),
                        child: Text('광고보고 재도전하기'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameWinScreen extends StatelessWidget {
  final VoidCallback restartGame;

  GameWinScreen(this.restartGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_stage.png"), // 배경 이미지 추가
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0), // 텍스트 아래로 내리기 위해 여백 추가
                        child: Text(
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
                      ),
                      SizedBox(height: 5.0), // Space between text and button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewStage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Button padding
                          minimumSize: Size(100, 40), // Reduce button size
                        ),
                        child: Text('다음 스테이지로'),
                      ),
                      SizedBox(height: 5.0), // Space between buttons
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExerciseGameApp()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Button padding
                          minimumSize: Size(80, 20), // Reduce button size
                        ),
                        child: Text('광고보고 재도전하기'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
