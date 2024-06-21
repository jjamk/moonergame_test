// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:mooner_interface/stage.dart';
// import 'package:sensors/sensors.dart';

// void main() => runApp(ExerciseGameApp());

// class ExerciseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ExerciseGameScreen(),
//     );
//   }
// }

// class StarWidget extends StatelessWidget {
//   final int starsCount;
//   StarWidget(this.starsCount);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(3, (index) {
//         if (index < starsCount) {
//           return Icon(
//             Icons.star,
//             color: Colors.yellow,
//           );
//         } else {
//           return Icon(
//             Icons.star_border,
//             color: Colors.grey,
//           );
//         }
//       }),
//     );
//   }
// }

// class ExerciseGameScreen extends StatefulWidget {
//   @override
//   _ExerciseGameScreenState createState() => _ExerciseGameScreenState();
// }

// class _ExerciseGameScreenState extends State<ExerciseGameScreen> {
//   int stars = 0;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   int exCount = 0; // 운동 횟수 = 걸음 수
//   double threshold = 20.0; // 흔들림을 감지하기 위한 임계값
//   bool isShaking = false;
//   late Timer _timer;
//   int _countDown = 30;

//   List<String> dialogues = [
//     "30초 안에 20개를 채우면 너문어를 진정시킬 수 있어!",
//     "이제 한 번 시작해볼까?",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _startListening();
//   }

//   void nextDialogue() {
//     setState(() {
//       dialogueIndex++;
//       if (dialogueIndex >= dialogues.length) {
//         isDialogueActive = false;
//         startGame();
//         _startTimer(); // 다이얼로그가 끝난 후 타이머 시작
//       }
//     });
//   }

//   void startGame() {
//     setState(() {
//       isGameActive = true;
//     });
//   }

//   void restartGame() {
//     setState(() {
//       stars = 0;
//       exCount = 0;
//       _countDown = 30;
//       isGameActive = true;
//       isDialogueActive = true;
//       dialogueIndex = 0;
//       _startTimer(); // 게임 재시작 시 타이머 시작
//     });
//   }

//   void _startListening() {
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       // 가속도 데이터를 받아와 흔들림 감지
//       double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
//       if (magnitude > threshold && !isShaking) {
//         setState(() {
//           exCount++;
//           isShaking = true;

//           // 운동 횟수에 따라 별 업데이트
//           if (exCount >= 20) {
//             stars = 3;
//           } else if (exCount >= 15) {
//             stars = 2;
//           } else if (exCount >= 10) {
//             stars = 1;
//           } else {
//             stars = 0;
//           }

//           if (stars == 3) {
//             // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
//             _timer.cancel();
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => GameWinScreen()),
//             );
//           }
//         });
//       } else if (magnitude <= threshold) {
//         isShaking = false;
//       }
//     });
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_countDown == 0) {
//         timer.cancel();
//         if (stars == 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameOverScreen()),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameWinScreen()),
//           );
//         }
//       } else {
//         setState(() {
//           _countDown--;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           // 배경 이미지를 표시하는 컨테이너
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/bg_stage.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           //상단 스테이지번호
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Image.asset(
//               'assets/images/stage_background.png',
//               width: 150,
//               height: 150,
//             ),
//           ),
//           Positioned(
//             left: 36,
//             top: 65,
//             child: Text(
//               '#stage 6',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           // 중앙에 플레이어 이미지를 표시
//           Positioned(
//             child: Center(
//               child: Image.asset('assets/images/mooner.png',
//                   width: 300, height: 300, fit: BoxFit.cover),
//             ),
//           ),
//           if (!isGameActive && !isDialogueActive)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Game Over',
//                       style: TextStyle(fontSize: 24, color: Colors.white),
//                     ),
//                     ElevatedButton(
//                       onPressed: restartGame,
//                       child: Text('다시하기'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 10,
//             left: 50,
//             right: 0,
//             child: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   StarWidget(stars),
//                 ],
//               ),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               actions: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.settings),
//                   onPressed: () {
//                     print('Settings button pressed');
//                   },
//                 ),
//               ],
//             ),
//           ),
//           if (isDialogueActive)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 color: Colors.black.withOpacity(0.7),
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       dialogues[dialogueIndex],
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     ElevatedButton(
//                       onPressed: nextDialogue,
//                       child: Text('다음'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Text(
//               '남은 시간: $_countDown 초',
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//           Positioned(
//             bottom: 50,
//             left: MediaQuery.of(context).size.width / 2 - 150,
//             child: Column(
//               children: <Widget>[
//                 Text(
//                   '운동 횟수:',
//                   style: TextStyle(fontSize: 24.0),
//                 ),
//                 Text(
//                   '$exCount',
//                   style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GameOverScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '문어가 도망가버렸어요...',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NewStage()),
//                 );
//               },
//               child: Text('홈으로 돌아가기'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GameWinScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Congratulations!'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '문어의 화가 풀렸어요!',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NewStage()),
//                 );
//               },
//               child: Text('다음 스테이지로...'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



  
//초기화 ㅇㅇ 덤벨
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:mooner_interface/stage.dart';
// import 'package:sensors/sensors.dart';

// void main() => runApp(ExerciseGameApp());

// class ExerciseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ExerciseGameScreen(),
//     );
//   }
// }

// class StarWidget extends StatelessWidget {
//   final int starsCount;
//   StarWidget(this.starsCount);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(3, (index) {
//         if (index < starsCount) {
//           return Icon(
//             Icons.star,
//             color: Colors.yellow,
//           );
//         } else {
//           return Icon(
//             Icons.star_border,
//             color: Colors.grey,
//           );
//         }
//       }),
//     );
//   }
// }

// class ExerciseGameScreen extends StatefulWidget {
//   @override
//   _ExerciseGameScreenState createState() => _ExerciseGameScreenState();
// }

// class _ExerciseGameScreenState extends State<ExerciseGameScreen> {
//   int stars = 0;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   int exCount = 0; // 운동 횟수 = 걸음 수
//   double threshold = 20.0; // 흔들림을 감지하기 위한 임계값
//   bool isShaking = false;
//   late Timer _timer;
//   int _countDown = 30;

//   List<String> dialogues = [
//     "30초 안에 20개를 채우면 너문어를 진정시킬 수 있어!",
//     "이제 한 번 시작해볼까?",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _startListening();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void nextDialogue() {
//     setState(() {
//       dialogueIndex++;
//       if (dialogueIndex >= dialogues.length) {
//         isDialogueActive = false;
//         startGame();
//         _startTimer(); // 다이얼로그가 끝난 후 타이머 시작
//       }
//     });
//   }

//   void startGame() {
//     setState(() {
//       isGameActive = true;
//     });
//   }

//   void restartGame() {
//     setState(() {
//       stars = 0;
//       exCount = 0;
//       _countDown = 30;
//       isGameActive = true;
//       isDialogueActive = true;
//       dialogueIndex = 0;
//       _startTimer(); // 게임 재시작 시 타이머 시작
//     });
//   }

//   void _startListening() {
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       // 가속도 데이터를 받아와 흔들림 감지
//       double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
//       if (magnitude > threshold && !isShaking) {
//         setState(() {
//           exCount++;
//           isShaking = true;

//           // 운동 횟수에 따라 별 업데이트
//           if (exCount >= 20) {
//             stars = 3;
//           } else if (exCount >= 15) {
//             stars = 2;
//           } else if (exCount >= 10) {
//             stars = 1;
//           } else {
//             stars = 0;
//           }

//           if (stars == 3) {
//             // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
//             _timer.cancel();
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//             );
//           }
//         });
//       } else if (magnitude <= threshold) {
//         isShaking = false;
//       }
//     });
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_countDown == 0) {
//         timer.cancel();
//         if (stars == 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//           );
//         }
//       } else {
//         setState(() {
//           _countDown--;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           // 배경 이미지를 표시하는 컨테이너
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/bg_stage.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // 상단 스테이지 번호
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Image.asset(
//               'assets/images/stage_background.png',
//               width: 150,
//               height: 150,
//             ),
//           ),
//           Positioned(
//             left: 36,
//             top: 65,
//             child: Text(
//               '#stage 6',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           // 중앙에 플레이어 이미지를 표시
//           Positioned(
//             child: Center(
//               child: Image.asset('assets/images/mooner.png',
//                   width: 300, height: 300, fit: BoxFit.cover),
//             ),
//           ),
//           if (!isGameActive && !isDialogueActive)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Game Over',
//                       style: TextStyle(fontSize: 24, color: Colors.white),
//                     ),
//                     ElevatedButton(
//                       onPressed: restartGame,
//                       child: Text('다시하기'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 10,
//             left: 50,
//             right: 0,
//             child: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   StarWidget(stars),
//                 ],
//               ),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               actions: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.settings),
//                   onPressed: () {
//                     print('Settings button pressed');
//                   },
//                 ),
//               ],
//             ),
//           ),
//           if (isDialogueActive)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 color: Colors.black.withOpacity(0.7),
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       dialogues[dialogueIndex],
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     ElevatedButton(
//                       onPressed: nextDialogue,
//                       child: Text('다음'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Text(
//               '남은 시간: $_countDown 초',
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//           Positioned(
//             bottom: 50,
//             left: MediaQuery.of(context).size.width / 2 - 150,
//             child: Column(
//               children: <Widget>[
//                 Text(
//                   '운동 횟수:',
//                   style: TextStyle(fontSize: 24.0),
//                 ),
//                 Text(
//                   '$exCount',
//                   style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GameOverScreen extends StatelessWidget {
//   final VoidCallback restartGame;

//   GameOverScreen(this.restartGame);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '문어가 도망가버렸어요...',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 restartGame();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NewStage()),
//                 );
//               },
//               child: Text('홈으로 돌아가기'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GameWinScreen extends StatelessWidget {
//   final VoidCallback restartGame;

//   GameWinScreen(this.restartGame);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Congratulations!'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '문어의 화가 풀렸어요!',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 restartGame();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NewStage()),
//                 );
//               },
//               child: Text('다음 스테이지로...'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(ExerciseGameApp());

class ExerciseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExerciseGameScreen(),
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

class ExerciseGameScreen extends StatefulWidget {
  @override
  _ExerciseGameScreenState createState() => _ExerciseGameScreenState();
}

class _ExerciseGameScreenState extends State<ExerciseGameScreen> {
  int stars = 0;
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  int exCount = 0; // 운동 횟수 = 걸음 수
  double threshold = 20.0; // 흔들림을 감지하기 위한 임계값
  bool isShaking = false;
  late Timer _timer;
  int _countDown = 30;

  List<String> dialogues = [
    "30초 안에 핸든폰을 흔들어 20개를 채우면 너문어를 진정시킬 수 있어!",
    "이제 한 번 시작해볼까?",
  ];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void nextDialogue() {
    setState(() {
      dialogueIndex++;
      if (dialogueIndex >= dialogues.length) {
        isDialogueActive = false;
        startGame();
        _startTimer(); // 다이얼로그가 끝난 후 타이머 시작
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
      _startTimer(); // 게임 재시작 시 타이머 시작
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
      } else if (magnitude <= threshold) {
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
          // 상단 스테이지 번호
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
              '#stage 6',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // 중앙에 플레이어 이미지를 표시
          Positioned(
            child: Center(
              child: Image.asset('assets/images/mooner.png',
                  width: 300, height: 300, fit: BoxFit.cover),
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
                      'Game Over',
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
                  StarWidget(stars),
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
          if (isDialogueActive)
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
          Positioned(
            top: 30,
            right: 20,
            child: Text(
              '남은 시간: $_countDown 초',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: Column(
              children: <Widget>[
                Text(
                  '운동 횟수:',
                  style: TextStyle(fontSize: 24.0),
                ),
                Text(
                  '$exCount',
                  style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
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
                restartGame();
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
  final VoidCallback restartGame;

  GameWinScreen(this.restartGame);

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
              '문어의 화가 풀렸어요!',
              style: TextStyle(fontSize: 24.0),
            ),
            ElevatedButton(
              onPressed: () {
                restartGame();
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




//초기화 ㄴㄴ 복싱 줄넘기 아령
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:sensors/sensors.dart';
// import 'package:mooner_interface/stage.dart';

// void main() => runApp(ExerciseGameApp());

// class ExerciseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: '/',
//       routes: {
//         '/': (context) => ExerciseSelectionScreen(),
//         '/boxing': (context) => BoxingGameScreen(),
//         '/jumpRope': (context) => JumpRopeGameScreen(),
//         '/dumbel':(context)=> DumbelGameScreen(),
//         '//':(context)=>NewStageScreen()
//       },
//     );
//   }
// }

// class ExerciseSelectionScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('운동 선택'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/boxing');
//               },
//               child: Text('복싱하기'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/jumpRope');
//               },
//               child: Text('줄넘기하기'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/dumbel');
//               },
//               child: Text('아령하기'),
//             )            
//           ],
//         ),
//       ),
//     );
//   }
// }

// class StarWidget extends StatelessWidget {
//   final int starsCount;
//   StarWidget(this.starsCount);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(3, (index) {
//         if (index < starsCount) {
//           return Icon(
//             Icons.star,
//             color: Colors.yellow,
//           );
//         } else {
//           return Icon(
//             Icons.star_border,
//             color: Colors.grey,
//           );
//         }
//       }),
//     );
//   }
// }

// class BoxingGameScreen extends StatefulWidget {
//   @override
//   _BoxingGameScreenState createState() => _BoxingGameScreenState();
// }

// class _BoxingGameScreenState extends State<BoxingGameScreen> {
//   int stars = 0;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   int exCount = 0; // 운동 횟수 = 퍼칭 수
//   double threshold = 20.0; // 흔들림을 감지하기 위한 임계값
//   bool isShaking = false;
//   late Timer _timer;
//   int _countDown = 30;

//   List<String> dialogues = [
//     "30초 안에 20개를 채우면 너문어를 진정시킬 수 있어!",
//     "이제 한 번 시작해볼까?",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _startListening();
//   }

//   void nextDialogue() {
//     setState(() {
//       dialogueIndex++;
//       if (dialogueIndex >= dialogues.length) {
//         isDialogueActive = false;
//         startGame();
//         _startTimer();

//       }
//     });
//   }

//   void startGame() {
//     setState(() {
//       isGameActive = true;
//     });
//   }

//   void restartGame() {
//     setState(() {
//       stars = 0;
//       exCount = 0;
//       _countDown = 30;
//       isGameActive = true;
//       isDialogueActive = true;
//       dialogueIndex = 0;
//       _startTimer();
//     });
//   }

//   void _startListening() {
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       // 가속도 데이터를 받아와 흔들림 감지
//       double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
//       if (magnitude > threshold && !isShaking) {
//         setState(() {
//           exCount++;
//           isShaking = true;

//           // 운동 횟수에 따라 별 업데이트
//           if (exCount >= 20) {
//             stars = 3;
//           } else if (exCount >= 15) {
//             stars = 2;
//           } else if (exCount >= 10) {
//             stars = 1;
//           } else {
//             stars = 0;
//           }

//           if (stars == 3) {
//             // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
//             _timer.cancel();
//             Navigator.push(
//               context,
//             MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//             );
//           }

//         });
//       } 
//       else if (magnitude <= threshold) {
//         isShaking = false;
//       }
//     });
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_countDown == 0) {
//         timer.cancel();
//         if (stars == 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//           );
//         }
//       } else {
//         setState(() {
//           _countDown--;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           // 배경 이미지를 표시하는 컨테이너
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/bg_stage.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           //상단 스테이지번호
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Image.asset(
//               'assets/images/stage_background.png',
//               width: 150,
//               height: 150,
//             ),
//           ),
//           Positioned(
//             left: 36,
//             top: 65,
//             child: Text(
//               '#stage 6',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           // 중앙에 플레이어 이미지를 표시
//           Positioned(
//             child: Center(
//               child: Image.asset('assets/images/mooner.png',
//                   width: 300, height: 300, fit: BoxFit.cover),
//             ),
//           ),
//           if (!isGameActive && !isDialogueActive)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Game Over',
//                       style: TextStyle(fontSize: 24, color: Colors.white),
//                     ),
//                     ElevatedButton(
//                       onPressed: restartGame,
//                       child: Text('다시하기'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 10,
//             left: 50,
//             right: 0,
//             child: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   StarWidget(stars),
//                 ],
//               ),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               actions: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.settings),
//                   onPressed: () {
//                     print('Settings button pressed');
//                   },
//                 ),
//               ],
//             ),
//           ),
//           if (isDialogueActive)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 color: Colors.black.withOpacity(0.7),
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       dialogues[dialogueIndex],
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     ElevatedButton(
//                       onPressed: nextDialogue,
//                       child: Text('다음'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Text(
//               '남은 시간: $_countDown 초',
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//           Positioned(
//             bottom: 50,
//             left: MediaQuery.of(context).size.width / 2 - 150,
//             child: Column(
//               children: <Widget>[
//                 Text(
//                   '운동 횟수:',
//                   style: TextStyle(fontSize: 24.0),
//                 ),
//                 Text(
//                   '$exCount',
//                   style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class JumpRopeGameScreen extends StatefulWidget {
//   @override
//   _JumpRopeGameScreenState createState() => _JumpRopeGameScreenState();
// }

// class _JumpRopeGameScreenState extends State<JumpRopeGameScreen> {
//   int stars = 0;
//   bool isGameActive = false;
//   int jumpCount = 0;
//   double threshold = 2.0; // 점프 감지 임계값
//   bool isJumping = false;
//   late Timer _timer;
//   int _countDown = 30;

//   void startGame() {
//     setState(() {
//       isGameActive = true;
//     });
//   }

//   void restartGame() {
//     setState(() {
//       stars = 0;
//       jumpCount = 0;
//       _countDown = 30;
//       isGameActive = true;
//       _startTimer();
//     });
//   }

//   void _startListening() {
//     userAccelerometerEvents.listen((UserAccelerometerEvent event) {
//       // Y축 가속도를 이용하여 점프 감지
//       if (event.y > threshold && !isJumping) {
//         setState(() {
//           jumpCount++;
//           isJumping = true;

//           // 점프 횟수에 따라 별 업데이트
//           if (jumpCount >= 20) {
//             stars = 3;
//           } else if (jumpCount >= 15) {
//             stars = 2;
//           } else if (jumpCount >= 10) {
//             stars = 1;
//           } else {
//             stars = 0;
//           }

//           if (stars == 3) {
//             // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
//             _timer.cancel();
//             MaterialPageRoute(builder: (context) => GameWinScreen(restartGame));
//           }
//         });
//       } else if (event.y <= threshold) {
//         isJumping = false;
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _startListening();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _timer.cancel();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_countDown == 0) {
//         timer.cancel();
//         if (stars == 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//           );
//         }
//       } else {
//         setState(() {
//           _countDown--;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           // 배경 이미지를 표시하는 컨테이너
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/bg_stage.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // 상단 스테이지 번호
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Image.asset(
//               'assets/images/stage_background.png',
//               width: 150,
//               height: 150,
//             ),
//           ),
//           Positioned(
//             left: 36,
//             top: 65,
//             child: Text(
//               '#stage 3',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           // 중앙에 플레이어 이미지를 표시
//           Positioned(
//             child: Center(
//               child: Image.asset(
//                 'assets/images/mooner.png',
//                 width: 300,
//                 height: 300,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // 게임 종료 화면
//           if (!isGameActive)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Game Over',
//                       style: TextStyle(fontSize: 24, color: Colors.white),
//                     ),
//                     ElevatedButton(
//                       onPressed: restartGame,
//                       child: Text('다시하기'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           // 앱 바
//           Positioned(
//             top: 10,
//             left: 50,
//             right: 0,
//             child: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   StarWidget(stars),
//                 ],
//               ),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               actions: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.settings),
//                   onPressed: () {
//                     print('Settings button pressed');
//                   },
//                 ),
//               ],
//             ),
//           ),
//           // 남은 시간 표시
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Text(
//               '남은 시간: $_countDown 초',
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//           // 점프 수 표시
//           Positioned(
//             bottom: 50,
//             left: MediaQuery.of(context).size.width / 2 - 150,
//             child: Column(
//               children: <Widget>[
//                 Text(
//                   '점프 수:',
//                   style: TextStyle(fontSize: 24.0),
//                 ),
//                 Text(
//                   '$jumpCount',
//                   style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DumbelGameScreen extends StatefulWidget {
//   @override
//   _DumbelGameScreenState createState() => _DumbelGameScreenState();
// }

// class _DumbelGameScreenState extends State<DumbelGameScreen> {
//   int stars = 0;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   int dumbelcount = 0; // 운동 횟수
//   double threshold = 20.0; // 흔들림을 감지하기 위한 임계값
//   bool isShaking = false;
//   late Timer _timer;
//   int _countDown = 30;

//   List<String> dialogues = [
//     "30초 안에 20개를 채우면 너문어를 진정시킬 수 있어!",
//     "이제 한 번 시작해볼까?",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _startListening();
//   }

//   void nextDialogue() {
//     setState(() {
//       dialogueIndex++;
//       if (dialogueIndex >= dialogues.length) {
//         isDialogueActive = false;
//         startGame();
//         _startTimer();

//       }
//     });
//   }

//   void startGame() {
//     setState(() {
//       isGameActive = true;
//     });
//   }

//   void restartGame() {
//     setState(() {
//       stars = 0;
//       dumbelcount = 0;
//       _countDown = 30;
//       isGameActive = true;
//       isDialogueActive = true;
//       dialogueIndex = 0;
//       _startTimer();
//     });
//   }

//   void _startListening() {
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       // 가속도 데이터를 받아와 흔들림 감지
//       double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
//       if (magnitude > threshold && !isShaking) {
//         setState(() {
//           dumbelcount++;
//           isShaking = true;

//           // 운동 횟수에 따라 별 업데이트
//           if (dumbelcount >= 20) {
//             stars = 3;
//           } else if (dumbelcount >= 15) {
//             stars = 2;
//           } else if (dumbelcount >= 10) {
//             stars = 1;
//           } else {
//             stars = 0;
//           }

//           if (stars == 3) {
//             // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
//             _timer.cancel();
//             Navigator.push(
//               context,
//             MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//             );
//           }

//         });
//       } 
//       else if (magnitude <= threshold) {
//         isShaking = false;
//       }
//     });
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_countDown == 0) {
//         timer.cancel();
//         if (stars == 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//           );
//         }
//       } else {
//         setState(() {
//           _countDown--;
//         });
//       }
//     });
//   }

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           // 배경 이미지를 표시하는 컨테이너
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/bg_stage.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           //상단 스테이지번호
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Image.asset(
//               'assets/images/stage_background.png',
//               width: 150,
//               height: 150,
//             ),
//           ),
//           Positioned(
//             left: 36,
//             top: 65,
//             child: Text(
//               '#stage 6',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           // 중앙에 플레이어 이미지를 표시
//           Positioned(
//             child: Center(
//               child: Image.asset('assets/images/mooner.png',
//                   width: 300, height: 300, fit: BoxFit.cover),
//             ),
//           ),
//           if (!isGameActive && !isDialogueActive)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Game Over',
//                       style: TextStyle(fontSize: 24, color: Colors.white),
//                     ),
//                     ElevatedButton(
//                       onPressed: restartGame,
//                       child: Text('다시하기'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 10,
//             left: 50,
//             right: 0,
//             child: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   StarWidget(stars),
//                 ],
//               ),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               actions: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.settings),
//                   onPressed: () {
//                     print('Settings button pressed');
//                   },
//                 ),
//               ],
//             ),
//           ),
//           if (isDialogueActive)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 color: Colors.black.withOpacity(0.7),
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       dialogues[dialogueIndex],
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     ElevatedButton(
//                       onPressed: nextDialogue,
//                       child: Text('다음'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Text(
//               '남은 시간: $_countDown 초',
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//           Positioned(
//             bottom: 50,
//             left: MediaQuery.of(context).size.width / 2 - 150,
//             child: Column(
//               children: <Widget>[
//                 Text(
//                   '운동 횟수:',
//                   style: TextStyle(fontSize: 24.0),
//                 ),
//                 Text(
//                   '$dumbelcount',
//                   style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class GameOverScreen extends StatelessWidget {

//   final VoidCallback restartGame;
//   GameOverScreen(this.restartGame);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Game Over'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '문어가 도망가버렸어요...',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '//');
//               },
//               child: Text('홈으로 돌아가기'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GameWinScreen extends StatelessWidget {

//   final VoidCallback restartGame;

//   GameWinScreen(this.restartGame);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('축하합니다!'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '문어의 화가 풀렸어요!',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '//');
//               },
//               child: Text('다음 스테이지로...'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }