// import 'dart:async';
// import 'package:flutter/material.dart';

// void main() => runApp(MusclereleaseGameApp());

// class MusclereleaseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MusclereleaseGameScreen(),
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
//   int stars = 0;
//   bool isLongPressed = false;
//   late Offset _startPosition;
//   late DateTime _longPressStartTime;
//   int countdown = 7;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   Timer? _countdownTimer;
//   int successCount = 0; // 성공 횟수

//   List<String> dialogues = [
//     "이제 문어의 꼬인 다리를 풀어줄거야",
//     "문어를 7초 동안 누르고 있다가 빠르게 아래로 내리면 돼!",
//     "기회는 3번! 실패하면 문어의 화가 더 날거야.",
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
//       stars = 0;
//       successCount = 0; // 성공 횟수 초기화
//       isGameActive = true;
//       startGame();
//     });
//   }

//   void decrementStars() {
//     setState(() {
//       stars++;
//       if (stars == 3) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => GameWinScreen(),
//           ),
//         );
//       } else {
//         startCountdown();
//       }
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
//             _longPressStartTime = DateTime.now();
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

//               if (successCount >= 3) {
//                 // Move to GameWinScreen
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => GameWinScreen(),
//                   ),
//                 );
//               } else {
//                 showNotification('성공했어요!');
//               }
//             } else {
//               decrementStars();
//               if (stars > 0) {
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
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/images/bg_stage.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
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
//             Center(
//               child: Image.asset(
//                 'assets/images/mooner.png',
//                 width: 300,
//                 height: 300,
//                 fit: BoxFit.cover,
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
//               Positioned(
//                 top: 50.0,
//                 right: 40.0,
//                 child: Container(
//                   padding: EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.7),
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

// void main() => runApp(MusclereleaseGameApp());

// class MusclereleaseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MusclereleaseGameScreen(),
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

import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MusclereleaseGameApp());

class MusclereleaseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                '#stage 4',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/mooner.png',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
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
            if (isLongPressed)
              Positioned(
                top: 50.0,
                right: 40.0,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '$countdown',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
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
            StarWidget(stars),
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
