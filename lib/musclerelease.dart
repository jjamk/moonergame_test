// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:ui' show lerpDouble;

// void main() => runApp(MusclereleaseGameApp());

// //글씨체
// class MusclereleaseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(fontFamily: 'BMJUA'),
//       home: MusclereleaseGameScreen(),
//     );
//   }
// }

// //문어
// class OctopusImage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SvgPicture.asset(
//       'assets/images/new_mooner.svg', //문어 이미지 경로
//       fit: BoxFit.contain, // 이미지가 위젯에 맞게 조정
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

// class MusclereleaseGameScreen extends StatefulWidget {
//   @override
//   _MusclereleaseGameScreenState createState() =>
//       _MusclereleaseGameScreenState();
// }

// class _MusclereleaseGameScreenState extends State<MusclereleaseGameScreen> {
//   bool isLongPressed = false;
//   late Offset _startPosition;
//   int countdown = 7;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   Timer? _countdownTimer;
//   int successCount = 0; // 성공 횟수
//   int stars = 0; // 별 갯수
//   int failCount = 0; // 실패 횟수

//   List<String> dialogues = [
//     "이제 문어의 꼬인 다리를 풀어줄거야",
//     "문어를 7초 동안 누르고 있다가 빠르게 아래로 내리면 돼!",
//     "기회는 4번! 실패하면 문어의 화가 더 날거야.",
//   ];

//   @override
//   void initState() {
//     super.initState();
//   }

//   void nextDialogue() {
//     setState(() {
//       dialogueIndex++;
//       if (dialogueIndex >= dialogues.length) {
//         isDialogueActive = false;
//         startGame();
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
//       successCount = 0; // 성공 횟수 초기화
//       stars = 0; // 별 갯수 초기화
//       failCount = 0; // 실패 횟수 초기화
//       isGameActive = true;
//       startGame();
//     });
//   }

//   void startCountdown() {
//     setState(() {
//       countdown = 7;
//     });

//     _countdownTimer?.cancel();

//     _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (countdown > 0) {
//         setState(() {
//           countdown--;
//         });
//       } else {
//         timer.cancel();
//         if (isLongPressed) {
//           setState(() {
//             isLongPressed = false;
//             showNotification("7초 동안 누르고 아래로 이동하세요!");
//           });
//         }
//       }
//     });
//   }

//   void showNotification(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('알림'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void updateStars() {
//     if (successCount >= 4) {
//       stars = 3;
//     } else if (successCount >= 3) {
//       stars = 2;
//     } else if (successCount >= 2) {
//       stars = 1;
//     } else {
//       stars = 0;
//     }
//   }

//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onLongPressStart: (details) {
//           setState(() {
//             isLongPressed = true;
//             _startPosition = details.globalPosition;
//             startCountdown();
//           });
//         },
//         onLongPressEnd: (details) {
//           if (isLongPressed) {
//             double verticalDistance = details.globalPosition.dy - _startPosition.dy;

//             if (verticalDistance > 0 && countdown == 0) {
//               setState(() {
//                 successCount++;
//               });

//               if (successCount >= 4) {
//                 // Move to GameWinScreen
//                 updateStars();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => GameWinScreen(stars: stars),
//                   ),
//                 );
//               } else {
//                 updateStars();
//                 showNotification('성공했어요!');
//               }
//             } else {
//               setState(() {
//                 failCount++;
//               });

//               if (failCount >= 3) {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => GameOverScreen(),
//                   ),
//                 );
//               } else {
//                 showNotification('7초 동안 누르고 이동해야해요! 다시 한 번 해보세요!');
//               }
//             }

//             setState(() {
//               isLongPressed = false;
//             });
//           }
//         },
//         child: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             //배경 이미지
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/images/new_bg_stage_test.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             //문어 출력
//             OctopusImage(),
//             SizedBox(height: 20),
                           
//             //상단 스테이지 배경 내용            
//             Positioned(
//               left: 0,
//               top: 0,
//               child: Image.asset(
//                 'assets/images/stage_background.png',
//                 width: 150,
//                 height: 150,
//               ),
//             ),
//             Positioned(
//               left: 36,
//               top: 65,
//               child: Text(
//                 '#stage 4',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             if (!isGameActive && !isDialogueActive)
//               Container(
//                 color: Colors.black.withOpacity(0.5),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Game Over',
//                         style: TextStyle(fontSize: 24, color: Colors.white),
//                       ),
//                       ElevatedButton(
//                         onPressed: restartGame,
//                         child: Text('다시하기'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             Positioned(
//               top: 10,
//               left: 50,
//               right: 0,
//               child: AppBar(
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     StarWidget(stars),
//                   ],
//                 ),
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 automaticallyImplyLeading: false, // 이 부분을 추가하여 뒤로가기 화살표 없앰
//                 actions: <Widget>[
//                   IconButton(
//                     icon: Icon(Icons.settings),
//                     onPressed: () {
//                       print('Settings button pressed');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (isDialogueActive)
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   color: Colors.black.withOpacity(0.7),
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         dialogues[dialogueIndex],
//                         style: TextStyle(fontSize: 20, color: Colors.white),
//                         textAlign: TextAlign.center,
//                       ),
//                       ElevatedButton(
//                         onPressed: nextDialogue,
//                         child: Text('다음'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             if (isLongPressed)
//             //타이머 숫자 출력
//               Positioned(
//                 top: 50.0,
//                 right: 40.0,
//                 child: Container(
//                   padding: EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Text(
//                     '$countdown',
//                     style: TextStyle(color: Colors.white, fontSize: 20.0),
//                   ),
//                 ),
//               ),
//           ],
//         ),
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
//                   MaterialPageRoute(builder: (context) => MusclereleaseGameApp()),
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
//   final int stars;
//   GameWinScreen({required this.stars});

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
//               '화가 풀렸어요',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => MusclereleaseGameApp()),
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


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

// void main() => runApp(MusclereleaseGameApp());

// //글씨체
// class MusclereleaseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(fontFamily: 'BMJUA'),
//       home: MusclereleaseGameScreen(),
//     );
//   }
// }

// //문어
// class OctopusImage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SvgPicture.asset(
//       'assets/images/new_mooner.svg', //문어 이미지 경로
//       fit: BoxFit.contain, // 이미지가 위젯에 맞게 조정
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

// class MusclereleaseGameScreen extends StatefulWidget {
//   @override
//   _MusclereleaseGameScreenState createState() =>
//       _MusclereleaseGameScreenState();
// }

// class _MusclereleaseGameScreenState extends State<MusclereleaseGameScreen> {
//   bool isLongPressed = false;
//   late Offset _startPosition;
//   int countdown = 7;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   Timer? _countdownTimer;
//   int successCount = 0; // 성공 횟수
//   int stars = 0; // 별 갯수
//   int failCount = 0; // 실패 횟수
//   double _progress = 1.0;

//   List<String> dialogues = [
//     "이제 문어의 꼬인 다리를 풀어줄거야",
//     "문어를 7초 동안 누르고 있다가 빠르게 아래로 내리면 돼!",
//     "기회는 4번! 실패하면 문어의 화가 더 날거야.",
//   ];

//   @override
//   void initState() {
//     super.initState();
//   }

//   void nextDialogue() {
//     setState(() {
//       dialogueIndex++;
//       if (dialogueIndex >= dialogues.length) {
//         isDialogueActive = false;
//         startGame();
//       }
//     });
//   }

//   void startGame() {
//     setState(() {
//       isGameActive = true;
//     });
//   }

//   void resetGame() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => MusclereleaseGameScreen()),
//     ); // 타이머 재시작
//   }  

//   void restartGame() {
//     setState(() {
//       successCount = 0; // 성공 횟수 초기화
//       stars = 0; // 별 갯수 초기화
//       failCount = 0; // 실패 횟수 초기화
//       isGameActive = true;
//       startGame();
//     });
//   }

//   void startCountdown() {
//     setState(() {
//       countdown = 7;
//     });

//     _countdownTimer?.cancel();

//     _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (countdown > 0) {
//         setState(() {
//           countdown--;
//         });
//       } else {
//         timer.cancel();
//         if (isLongPressed) {
//           setState(() {
//             isLongPressed = false;
//             showNotification("7초 동안 누르고 아래로 이동하세요!");
//           });
//         }
//       }
//     });
//   }

//   void showNotification(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('알림'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void updateStars() {
//     if (successCount >= 4) {
//       stars = 3;
//     } else if (successCount >= 3) {
//       stars = 2;
//     } else if (successCount >= 2) {
//       stars = 1;
//     } else {
//       stars = 0;
//     }
//   }

//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onLongPressStart: (details) {
//           setState(() {
//             isLongPressed = true;
//             _startPosition = details.globalPosition;
//             startCountdown();
//           });
//         },
//         onLongPressEnd: (details) {
//           if (isLongPressed) {
//             double verticalDistance = details.globalPosition.dy - _startPosition.dy;

//             if (verticalDistance > 0 && countdown == 0) {
//               setState(() {
//                 successCount++;
//               });

//               if (successCount >= 4) {
//                 // Move to GameWinScreen
//                 updateStars();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => GameWinScreen(stars: stars),
//                   ),
//                 );
//               } else {
//                 updateStars();
//                 showNotification('성공했어요!');
//               }
//             } else {
//               setState(() {
//                 failCount++;
//               });

//               if (failCount >= 3) {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => GameOverScreen(),
//                   ),
//                 );
//               } else {
//                 showNotification('7초 동안 누르고 이동해야해요! 다시 한 번 해보세요!');
//               }
//             }

//             setState(() {
//               isLongPressed = false;
//             });
//           }
//         },
//         child: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             //배경 이미지
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/images/new_bg_stage_test.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             //문어 출력
//             OctopusImage(),
//             SizedBox(height: 20),
                           
//             //상단 스테이지 배경 내용            
//             Positioned(
//               left: 0,
//               top: 0,
//               child: Image.asset(
//                 'assets/images/stage_background.png',
//                 width: 150,
//                 height: 150,
//               ),
//             ),
//             Positioned(
//               left: 36,
//               top: 65,
//               child: Text(
//                 '#stage 4',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             if (!isGameActive && !isDialogueActive)
//               Container(
//                 color: Colors.black.withOpacity(0.5),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Game Over',
//                         style: TextStyle(fontSize: 24, color: Colors.white),
//                       ),
//                       ElevatedButton(
//                         onPressed: restartGame,
//                         child: Text('다시하기'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             Positioned(
//               top: 10,
//               left: 50,
//               right: 0,
//               child: AppBar(
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     StarWidget(stars),
//                   ],
//                 ),
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 automaticallyImplyLeading: false, // 이 부분을 추가하여 뒤로가기 화살표 없앰
//                 actions: <Widget>[
//                   IconButton(
//                     icon: Icon(Icons.settings),
//                     onPressed: () {
//                       print('Settings button pressed');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (isDialogueActive)
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   color: Colors.black.withOpacity(0.7),
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         dialogues[dialogueIndex],
//                         style: TextStyle(fontSize: 20, color: Colors.white),
//                         textAlign: TextAlign.center,
//                       ),
//                       ElevatedButton(
//                         onPressed: nextDialogue,
//                         child: Text('다음'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             if (isLongPressed)
//               Text(
//                 '남은 시간: $countdown 초',
//                 style: TextStyle(color: Colors.white, fontSize: 20.0),
//               ),
//               Positioned(
//                 top: 50.0,
//                 right: 40.0,
//                 child: SimpleAnimationProgressBar(
//                   height: 300,
//                   width: 15,
//                   backgroundColor: Colors.grey,
//                   foregrondColor: Colors.red,
//                   ratio: _progress,
//                   direction: Axis.vertical,
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   duration: const Duration(seconds: 1), // 여기서는 타이머의 시간과 맞춰줍니다.
//                   borderRadius: BorderRadius.circular(10),
//                   gradientColor: const LinearGradient(
//                     colors: [Colors.red, Colors.orange],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                 ),
//               ),
//           ],
//         ),
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
//                   MaterialPageRoute(builder: (context) => MusclereleaseGameApp()),
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
//   final int stars;
//   GameWinScreen({required this.stars});

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
//               '화가 풀렸어요',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => MusclereleaseGameApp()),
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

void main() => runApp(MusclereleaseGameApp());

// 글씨체
class MusclereleaseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: MusclereleaseGameScreen(),
    );
  }
}

// 문어
class OctopusImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/new_mooner.svg', // 문어 이미지 경로
      fit: BoxFit.contain, // 이미지가 위젯에 맞게 조정
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
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  Timer? _countdownTimer;
  Timer? _progressBarTimer;
  int successCount = 0; // 성공 횟수
  int stars = 0; // 별 갯수
  int failCount = 0; // 실패 횟수
  double _progress = 1.0; // 프로그래스바 비율
  int remainingTime = 7; // 남은 시간 (초)

  List<String> dialogues = [
    "이제 문어의 꼬인 다리를 풀어줄거야",
    "문어를 7초 동안 누르고 있다가 빠르게 아래로 내리면 돼!",
    "기회는 4번! 실패하면 문어의 화가 더 날거야.",
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
        startGame();
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
      remainingTime = 7;
      _progress = 1.0;
    });

    _countdownTimer?.cancel();
    _progressBarTimer?.cancel();
    
    // 1초마다 프로그래스바 비율을 1/7씩 감소
    _progressBarTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
        _progress = remainingTime / 7.0; // 프로그래스바 비율 업데이트
        if (remainingTime <= 0) {
          _progress = 0;
          timer.cancel();
          if (isLongPressed) {
            setState(() {
              isLongPressed = false;
              showNotification("7초 동안 누르고 아래로 이동하세요!");
            });
          }
        }
      });
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
    _progressBarTimer?.cancel();
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

            if (verticalDistance > 0 && remainingTime == 0) {
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
            // 배경 이미지
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/new_bg_stage_test.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 문어 출력
            OctopusImage(),
            SizedBox(height: 20),
                           
            // 상단 스테이지 배경 내용            
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
            if (isLongPressed)
              Positioned(
                top: 50.0,
                right: 40.0,
                child: Column(
                  children: [
                    // 프로그래스바
                    SimpleAnimationProgressBar(
                      height: 300,
                      width: 15,
                      backgroundColor: Colors.grey,
                      foregrondColor: Colors.red,
                      ratio: _progress,
                      direction: Axis.vertical,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 8), // 프로그래스바 애니메이션 지속 시간 7초
                      borderRadius: BorderRadius.circular(10),
                      gradientColor: const LinearGradient(
                        colors: [Colors.red, Colors.orange],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    SizedBox(height: 20),
                    // 남은 시간 표시
                    Text(
                      '남은 시간: $remainingTime 초',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            // if (_progress <= 0)
            //   Positioned.fill(
            //     child: Center(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           resetGame();
            //         }, // 다시 시작 버튼을 누르면 resetGame 함수를 호출합니다.
            //         child: Text('다시 시작'),
            //       ),
            //     ),
            //   ),
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
                  MaterialPageRoute(builder: (context) => MusclereleaseGameApp()),
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
  final int stars;
  GameWinScreen({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('축하합니다!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '화가 풀렸어요',
              style: TextStyle(fontSize: 24.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusclereleaseGameApp()),
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
