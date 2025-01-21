import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mooner_interface/exercise.dart';
import 'package:mooner_interface/stage.dart';
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
                    'STAGE 3', 
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
                    '근육 이완하기', 
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
                    '문찌의 근육을 풀어주자!', 
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

class MusclereleaseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: BackgroundScreen(
        onBackgroundTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusclereleaseGameScreen(),
            ),
          );
        },
      ),
    );
  }
}


class MusclereleaseGameScreen extends StatefulWidget {
  @override
  _MusclereleaseGameScreenState createState() =>
      _MusclereleaseGameScreenState();
}

class _MusclereleaseGameScreenState extends State<MusclereleaseGameScreen> with SingleTickerProviderStateMixin {
  bool isLongPressed = false;
  late Offset _startPosition;
  //late Offset _lottiePosition;  // Lottie 애니메이션 위치를 저장할 변수
  int countdown = 7;
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  Timer? _countdownTimer;
  int successCount = 0; // 성공 횟수
  int stars = 0; // 별 갯수
  int failCount = 0; // 실패 횟수
  double _progress = 1.0;
  bool _isFailed = false; // 실패 상태를 나타내는 변수
  bool _isSuccess = false; //성공 상태를 나타내는 변수
  String _notificationText = ''; // 실패 알림 텍스트를 담는 변수
  String _successnotificationText=''; //성공 텍스트를 담는 변수
  Offset _redCirclePosition = Offset(60, 420); // 초기 빨간색 원 위치


  // 원의 크기를 저장할 변수
  double _circleSize = 60.0; // 초기 원 크기
  Offset _circlePosition = Offset(0, 0); // 초기 위치

  late AnimationController _animationController;


  List<String> dialogues = [
    '어부\n 문찌가 화를 내다가 다리가 다 꼬였어\n 근육을 풀어줘야 할 것 같아',
    '어부\n 꼬인 다리는 급하게 풀려고 하면 더 안 풀려! \n 힘을 천천히 줬다가 한번에 툭!하고 풀어보자',
    '어부\n 문찌의 다리를 7초 동안 꾹 눌렀다가 아래로 툭 내려서 힘을 풀어줄거야. \n 한번 해보자'
    '어부\n 꾹 눌러서 문찌가 팔에 힘을 주게 할거야!',
  ];

   //성공 메시지 목록
   List<String> successMessages = [
    '어부\n 잘했어!\n문찌의 화가 누그러지는 것 같은데?',
    '어부\n 문찌의 다른 팔들도 편하게 풀어줘 볼까?',
    '어부\n 좋아!\n문찌가 진정되는게 보여!',
    ''
   ];

    //실패 메시지 목록
    List<String> failMessages = [
    '귀찮게 뭐하는거야?',
    '방금은 도움이 하나도 안 됐어!',
    '저리가!',
  ]; 


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 7),
      );
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
      isGameActive = true; //게임시작
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
      _progress = 1.0; // 프로그레스 초기화
      _isFailed = false; // 실패 상태 초기화
      _isSuccess = false; // 성공 상태 초기화
      startGame();
    });
  }

  void startCountdown() {
    setState(() {
      countdown = 7;
      _circleSize = 60.0; // 원의 크기를 초기화
      //_animationController.repeat(); // Lottie 애니메이션 시작
    });

    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
          // 7초가 끝날 때 원을 0으로 만들기
          if (countdown == 0) {
            _circleSize = 0;
            //_animationController.stop(); // Lottie 애니메이션 정지
          }
        });
      } else {
        timer.cancel();
        if (isLongPressed) {
          setState(() {
            isLongPressed = false;
          });
        }
      }
    });
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

    void updateRedCirclePosition() {
    // 성공 횟수에 따라 위치 변경
    setState(() {
      switch (successCount) {
        case 1:
          _redCirclePosition = Offset(130, 430);
          break;
        case 2:
          _redCirclePosition = Offset(200, 420);
          break;
        case 3:
          _redCirclePosition = Offset(240, 400);
          break;
        default:
          _redCirclePosition = Offset(60, 420); // 초기 위치
      }
    });
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

          if (isDialogueActive) return;  // 대화가 끝나지 않았다면 동작을 막음

          setState(() {
            isLongPressed = true;
            _startPosition = details.globalPosition;
            _circlePosition = _startPosition; // 원의 위치도 터치 시작 위치로 설정
            startCountdown();
          });
        },
        onLongPressMoveUpdate: (details) {
          if (isDialogueActive) return;  // 대화가 끝나지 않았다면 동작을 막음


          if (isLongPressed) {
            setState(() {
              // 터치 위치에 따라 원의 위치 업데이트
              _circlePosition = details.localPosition;
              // countdown이 0보다 클 때만 크기 변화
              if (countdown > 0) {
                // 7초 동안 누를 때마다 원이 커짐
                _circleSize = 60 + (90 * (1 - (countdown / 7)));
              }
            });
          }
        },

        onLongPressEnd: (details) {
          if (isDialogueActive) return;  // 대화가 끝나지 않았다면 동작을 막음

          if (isLongPressed) {
            double verticalDistance = details.globalPosition.dy - _startPosition.dy;

            if (verticalDistance > 0 && countdown == 0) {
              setState(() {
                successCount++;
                _isFailed = false; // 성공 시 실패 상태 해제
                _isSuccess = true;
                _notificationText = ''; // 성공 시 알림 텍스트 제거
                _successnotificationText = successMessages[successCount - 1]; // 성공 메시지 출력                                

              });

              // 성공 시 빨간색 원 위치 업데이트
              updateRedCirclePosition();

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
              }
            } else {
              setState(() {
                failCount++;
                _isFailed = true; // 실패 상태 설정
                _isSuccess = false; // 실패 시 성공 상태 해제
                // 실패 시 프로그레스바 감소
                _progress -= 0.25;  // 4번 시도 중 한 번 실패하면 25% 감소
                if (_progress < 0) _progress = 0;
                _notificationText = failMessages[failCount - 1]; // 실패 메시지 출력
                _successnotificationText = ''; // 실패 시 성공 알림 텍스트 제거
                                
              });

              if (failCount >= 3) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GameOverScreen(),
                  ),
                );
              }
            }

            setState(() {
              isLongPressed = false;
            _circleSize = 0; // 손을 떼면 원을 없앰
            //_animationController.stop(); // Lottie 애니메이션 정지
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

            // Lottie 애니메이션 표시
            // if (isLongPressed)
            //   Positioned(
            //     left: _circlePosition.dx - 50,
            //     top: _circlePosition.dy - 50,
            //     child: Lottie.asset(
            //       'assets/json/musclerelease_effect.json',
            //       width: 200,
            //       height: 200,
            //       controller: _animationController,
            //       repeat: true,
            //     ),
            //   ),

            // 터치한 위치에 원을 그리는 부분
            Positioned(
              left: _circlePosition.dx - _circleSize / 2,
              top: _circlePosition.dy - _circleSize / 2,
              child: Container(
                width: _circleSize,
                height: _circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.yellow,  // 테두리 색상
                    width: 4.0,  // 테두리 두께
                  ),
                ),
              ),
            ),

            // 중앙에 문어 이미지를 표시
            Positioned(
              child: Center(
                child: SvgPicture.asset(
                  _isSuccess
                      ? (successCount == 1
                          ? 'assets/images/2angry_mooner_o.svg' // 첫 번째 성공 시 이미지
                          : successCount == 2
                              ? 'assets/images/1angry_mooner_o.svg' // 두 번째 성공 시 이미지
                              : 'assets/images/normal_mooner_o.svg') // 세 번째 성공 이후 이미지
                      : 'assets/images/3angry_mooner_o.svg', // 기본 이미지
                  width: 200,
                  height: 270,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //성공 알림 텍스트 표시
            if (_successnotificationText.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                //onTap: nextDialogue,
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
                            _successnotificationText,
                            style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            ), 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),

            //실패 알림 텍스트 표시
            if (_notificationText.isNotEmpty)
              Positioned(
                top: 200,
                child: Text(
                  _notificationText,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (!isLongPressed & !isDialogueActive) // 게임이 시작되기 전일 때만 빨간색 원과 화살표 표시
                Positioned(
                  left: _redCirclePosition.dx, // 동적으로 위치 지정
                  top: _redCirclePosition.dy,
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
                  left: _redCirclePosition.dx + 7, // 화살표 위치 조정
                  top: _redCirclePosition.dy + 51,
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
                '#stage 3',
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
                '근육 이완하기', 
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
                              //ratio: (successCount / 4).clamp(0.0, 1.0), // 0~100% 채워지는거 이 부분을 수정했습니다.
                              ratio: _progress,  // 100~0% 줄어드는거 성공 및 실패에 따라 업데이트되는 비율
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
            if (isLongPressed)
              Positioned(
                top: 230,
                right: 20,
                child: Text(
                  '남은 시간: $countdown 초',
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
                                builder: (context) => MusclereleaseGameApp()),
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
  final int stars;
  GameWinScreen({required this.stars});

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
                        child: Text('다음 스테이지로'),
                      ),
                      SizedBox(height: 5.0), // Space between buttons
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusclereleaseGameApp()),
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
