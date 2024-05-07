// import 'dart:async';
// import 'package:flutter/material.dart';

// void main() => runApp(MusclereleaseGameApp());

// class MusclereleaseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MusclereleaseGameScreen(),
//     );
//   }
// }

// class MusclereleaseGameScreen extends StatefulWidget {
//   @override
//   _MusclereleaseGameScreenState createState() => _MusclereleaseGameScreenState();
// }

// class _MusclereleaseGameScreenState extends State<MusclereleaseGameScreen> {
//   bool isLongPressed = false;
//   late Offset _startPosition;
//   late DateTime _longPressStartTime;
//   int countdown = 3;
//   int moveDownCount = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onLongPressStart: (details) {
//           setState(() {
//             isLongPressed = true;
//             _startPosition = details.globalPosition;
//             _longPressStartTime = DateTime.now();
//           });
//           startCountdown();
//         },
//         onLongPressEnd: (details) {
//           if (isLongPressed) {
//             double verticalDistance = details.globalPosition.dy - _startPosition.dy;

//             if (verticalDistance > 0 && countdown == 0) {
//               moveDownCount++;
//               if (moveDownCount == 4) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => GameWinScreen()),
//                 );
//               }
//             }
//             else if (verticalDistance > 0 && countdown != 0) {
//               // 7초 동안 누르지 않고 아래로 이동한 경우
//               showNotification('7초 동안 누르고 이동해야해요! 다시 한 번 해보세요!');
//             } 
//             else{
//               showNotification('다시 한 번 해보세요!');
//             }

            

//             setState(() {
//               isLongPressed = false;
//               countdown = 3;
//             });
//           }
//         },
//         child: Stack(
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
//             if (isLongPressed)
//               Positioned(
//                 top: 20.0,
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

//   void startCountdown() {
//     const oneSecond = Duration(seconds: 1);

//     Timer.periodic(oneSecond, (timer) {
//       if (!isLongPressed) {
//         timer.cancel();
//       } else if (countdown == 0) {
//         timer.cancel();
//         setState(() {
//           isLongPressed = false;
//         });
//         showNotification('3초 동안 누르고 아래로 이동해야해요! 다시 한 번 해보세요!');
//       } else {
//         setState(() {
//           countdown--;
//         });
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
//                 Navigator.pop(context);
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

void main() => runApp(MusclereleaseGameApp());

class MusclereleaseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusclereleaseGameScreen(),
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
  late DateTime _longPressStartTime;
  int countdown = 3;
  int moveDownCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPressStart: (details) {
          setState(() {
            isLongPressed = true;
            _startPosition = details.globalPosition;
            _longPressStartTime = DateTime.now();
          });
          startCountdown();
        },
        onLongPressEnd: (details) {
          if (isLongPressed) {
            double verticalDistance = details.globalPosition.dy -
                _startPosition.dy;

            if (verticalDistance > 0 && countdown == 0) {
              moveDownCount++;
              if (moveDownCount == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameWinScreen()),
                );
              }
            } else if (verticalDistance > 0 && countdown != 0) {
              // 7초 동안 누르지 않고 아래로 이동한 경우
              showNotification('7초 동안 누르고 이동해야해요! 다시 한 번 해보세요!');
            } else {
              showNotification('다시 한 번 해보세요!');
            }

            setState(() {
              isLongPressed = false;
              countdown = 3;
            });
          }
        },
        child: Stack(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '이동 횟수: $moveDownCount', // 이동 횟수 텍스트
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20), // 추가된 여백
                  Image.asset(
                    'assets/images/mooner.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  if (isLongPressed)
                    Container(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);

    Timer.periodic(oneSecond, (timer) {
      if (!isLongPressed) {
        timer.cancel();
      } else if (countdown == 0) {
        timer.cancel();
        setState(() {
          isLongPressed = false;
        });
        showNotification('3초 동안 누르고 아래로 이동해야해요! 다시 한 번 해보세요!');
      } else {
        setState(() {
          countdown--;
        });
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
}

class GameWinScreen extends StatelessWidget {
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
                Navigator.pop(context);
              },
              child: Text('다음 스테이지로...'),
            ),
          ],
        ),
      ),
    );
  }
}
