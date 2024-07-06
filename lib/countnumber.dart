import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

void main() => runApp(CountNumberGameApp());

class CountNumberGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChoiceScreen(),
    );
  }
}

class ChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new_bg_stage_test.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose your situation:',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpeakableCountNumberGameScreen()),
                  );
                },
                child: Text('I can speak'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnspeakableCountNumberGameScreen()),
                  );
                },
                child: Text('I cannot speak'),
              ),
            ],
          ),
        ),
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
            color: Colors.grey,
          );
        }
      }),
    );
  }
}

class SpeakableCountNumberGameScreen extends StatefulWidget {
  @override
  _SpeakableCountNumberGameScreenState createState() => _SpeakableCountNumberGameScreenState();
}

class _SpeakableCountNumberGameScreenState extends State<SpeakableCountNumberGameScreen> {
  int stars = 0;
  int successCount = 0;
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  late stt.SpeechToText _speech;
  String _lastWords = '';
  int _bubbleNumber = 1; // 초기값 1
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  int _remainingTime = 180; // 3분

  List<String> dialogues = [
    "3분 안에 10개 이상 성공하면 돼",
    "이제 한 번 시작해볼까?",
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _timer.cancel();
    _speech.stop();
    super.dispose();
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
    _listen(); // Start listening for speech
    _startTimer(); // Start the timer
  }

  void restartGame() {
    setState(() {
      stars = 0;
      successCount = 0;
      isGameActive = true;
      isDialogueActive = true;
      dialogueIndex = 0;
      _bubbleNumber = 1;
      _remainingTime = 180;
    });
    _listen();
    _startTimer();
  }

  void _listen() async {
    bool available = await _speech.initialize(
      onError: (error) {
        print('Error: $error');
      },
    );

    print('Speech initialized: $available');

    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords.toLowerCase();
            print('Recognized words: $_lastWords'); // 디버깅용 출력
            // Convert spoken words to numbers
            String recognizedNumber = '';
            switch (_lastWords) {
              case '하나':
              case '일':
              case '1':
                recognizedNumber = '1';
                break;
              case '둘':
              case '이':
              case '2':
                recognizedNumber = '2';
                break;
              case '셋':
              case '삼':
              case '3':
                recognizedNumber = '3';
                break;
              case '넷':
              case '사':
              case '4':
                recognizedNumber = '4';
                break;
              case '다섯':
              case '오':
              case '5':
                recognizedNumber = '5';
                break;
              case '여섯':
              case '육':
              case '6':
                recognizedNumber = '6';
                break;
              case '일곱':
              case '칠':
              case '7':
                recognizedNumber = '7';
                break;
              case '여덟':
              case '팔':
              case '8':
                recognizedNumber = '8';
                break;
              case '아홉':
              case '구':
              case '9':
                recognizedNumber = '9';
                break;
              case '열':
                recognizedNumber = '10';
                break;
              default:
                // If unrecognized word, keep the same word
                break;
            }

            // Check bubble number and update accordingly
            if (recognizedNumber == _bubbleNumber.toString()) {
              _lastWords = recognizedNumber;
              successCount++; // 일치 횟수 증가
              if (_bubbleNumber < 10) {
                _bubbleNumber++;
              } else {
                print('Bubble number $_bubbleNumber matched with spoken number $_bubbleNumber');
              }
            }

            // 운동 횟수에 따라 별 업데이트
            if (successCount >= 9) {
              stars = 3;
            } else if (successCount >= 7) {
              stars = 2;
            } else if (successCount >= 5) {
              stars = 1;
            } else {
              stars = 0;
            }

            if (stars == 3) {
              // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
              );
            }
          });
        },
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          isGameActive = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
          );
        }
      });
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
                image: AssetImage("assets/images/new_bg_stage_test.png"),
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
              '#stage 7',
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
              child: Image.asset('assets/images/new_mooner.png',
                  width: 200, height: 270, fit: BoxFit.cover),
            ),
          ),

          //말풍선 표시
          Positioned(
            left: 30,
            top: 120,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/speechbubble.png',
                    width: 100, height: 100, fit: BoxFit.cover),
                Positioned(
                  left: 30,
                  top: 30,
                  child: Text(
                    _bubbleNumber.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 말한 내용 표시
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Recognized: $_lastWords',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          // 음성 인식 버튼
          Positioned(
            bottom: 105,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_speech.isListening) {
                    _speech.stop();
                  } else {
                    _listen();
                  }
                },
                child: Text(
                  _speech.isListening ? 'Listening...' : 'Start Listening',
                ),
              ),
            ),
          ),

          // 대화가 활성화 중일 때의 대화 UI
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
                      child: Text('Next'),
                    ),
                  ],
                ),
              ),
            ),
          // 별 개수 표시
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

          // 타이머 표시
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Time left: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UnspeakableCountNumberGameScreen extends StatefulWidget {
  @override
  _UnspeakableCountNumberGameScreenState createState() => _UnspeakableCountNumberGameScreenState();
}

class _UnspeakableCountNumberGameScreenState extends State<UnspeakableCountNumberGameScreen> {
  int stars = 0;
  int successCount = 0;
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  int _bubbleNumber = 1; // 초기값 1
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  int _remainingTime = 180; // 3분

  List<String> dialogues = [
    "화면에 나온 숫자와 같은 숫자를 입력하면 돼",
    "이제 한 번 시작해볼까?",
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
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
      successCount = 0;
      isGameActive = true;
      isDialogueActive = true;
      dialogueIndex = 0;
      _bubbleNumber = 1;
      _remainingTime = 180;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          isGameActive = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
          );
        }
      });
    });
  }

  void onSubmitted(String value) {
    setState(() {
      if (value == _bubbleNumber.toString()) {
        successCount++; // 일치 횟수 증가
        if (_bubbleNumber < 10) {
          _bubbleNumber++;
        } else {
          print('Bubble number $_bubbleNumber matched with entered number $_bubbleNumber');
        }
      }
      _controller.clear();
    });

    // 일치 횟수에 따라 별 업데이트
    if (successCount >= 9) {
      stars = 3;
    } else if (successCount >= 7) {
      stars = 2;
    } else if (successCount >= 5) {
      stars = 1;
    } else {
      stars = 0;
    }

    if (stars == 3) {
      // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
      );
    }
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
                image: AssetImage("assets/images/new_bg_stage_test.png"),
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
              '#stage 7',
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
              child: Image.asset('assets/images/new_mooner.png',
                  width: 200, height: 270, fit: BoxFit.cover),
            ),
          ),

          //말풍선 표시
          Positioned(
            left: 30,
            top: 120,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/speechbubble.png',
                    width: 100, height: 100, fit: BoxFit.cover),
                Positioned(
                  left: 30,
                  top: 30,
                  child: Text(
                    _bubbleNumber.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 숫자 입력 필드
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter number',
                  ),
                  onSubmitted: onSubmitted,
                ),
              ),
            ),
          ),

          // 대화가 활성화 중일 때의 대화 UI
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
                      child: Text('Next'),
                    ),
                  ],
                ),
              ),
            ),

          // 별 개수 표시
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

          // 타이머 표시
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Time left: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 20),
              ),
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



//화난 문어 있는 버전
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'dart:async';
// import 'package:flutter_animate/flutter_animate.dart';


// void main() => runApp(CountNumberGameApp());

// class CountNumberGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ChoiceScreen(),
//     );
//   }
// }

// class ChoiceScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/new_bg_stage_test.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Choose your situation:',
//                 style: TextStyle(fontSize: 24),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SpeakableCountNumberGameScreen()),
//                   );
//                 },
//                 child: Text('I can speak'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => UnspeakableCountNumberGameScreen()),
//                   );
//                 },
//                 child: Text('I cannot speak'),
//               ),
//             ],
//           ),
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

// class SpeakableCountNumberGameScreen extends StatefulWidget {
//   @override
//   _SpeakableCountNumberGameScreenState createState() => _SpeakableCountNumberGameScreenState();
// }

// class _SpeakableCountNumberGameScreenState extends State<SpeakableCountNumberGameScreen> {
//   int stars = 0;
//   int successCount = 0;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   late stt.SpeechToText _speech;
//   String _lastWords = '';
//   int _bubbleNumber = 1; // 초기값 1
//   final TextEditingController _controller = TextEditingController();
//   late Timer _timer;
//   int _remainingTime = 180; // 3분

//   List<String> dialogues = [
//     "3분 안에 10개 이상 성공하면 돼",
//     "이제 한 번 시작해볼까?",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _speech.stop();
//     super.dispose();
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
//     _listen(); // Start listening for speech
//     _startTimer(); // Start the timer
//   }

//   void restartGame() {
//     setState(() {
//       stars = 0;
//       successCount = 0;
//       isGameActive = true;
//       isDialogueActive = true;
//       dialogueIndex = 0;
//       _bubbleNumber = 1;
//       _remainingTime = 180;
//     });
//     _listen();
//     _startTimer();
//   }

//   void _listen() async {
//     bool available = await _speech.initialize(
//       onError: (error) {
//         print('Error: $error');
//       },
//     );

//     print('Speech initialized: $available');

//     if (available) {
//       _speech.listen(
//         onResult: (result) {
//           setState(() {
//             _lastWords = result.recognizedWords.toLowerCase();
//             print('Recognized words: $_lastWords'); // 디버깅용 출력
//             // Convert spoken words to numbers
//             String recognizedNumber = '';
//             switch (_lastWords) {
//               case '하나':
//                 recognizedNumber = '1';
//                 break;
//               case '둘':
//                 recognizedNumber = '2';
//                 break;
//               case '셋':
//                 recognizedNumber = '3';
//                 break;
//               case '넷':
//                 recognizedNumber = '4';
//                 break;
//               case '다섯':
//                 recognizedNumber = '5';
//                 break;
//               case '여섯':
//                 recognizedNumber = '6';
//                 break;
//               case '일곱':
//                 recognizedNumber = '7';
//                 break;
//               case '여덟':
//                 recognizedNumber = '8';
//                 break;
//               case '아홉':
//                 recognizedNumber = '9';
//                 break;
//               case '열':
//                 recognizedNumber = '10';
//                 break;
//               default:
//                 // If unrecognized word, keep the same word
//                 break;
//             }

//             // Check bubble number and update accordingly
//             if (recognizedNumber == _bubbleNumber.toString()) {
//               _lastWords = recognizedNumber;
//               successCount++; // 일치 횟수 증가
//               if (_bubbleNumber < 10) {
//                 _bubbleNumber++;
//               } else {
//                 print('Bubble number $_bubbleNumber matched with spoken number $_bubbleNumber');
//               }
//             }

//             // 운동 횟수에 따라 별 업데이트
//             if (successCount >= 9) {
//               stars = 3;
//             } else if (successCount >= 7) {
//               stars = 2;
//             } else if (successCount >= 5) {
//               stars = 1;
//             } else {
//               stars = 0;
//             }

//             if (stars == 3) {
//               // 별이 3개가 되면 타이머를 중지하고 다음 스테이지로 이동
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//               );
//             }
//           });
//         },
//       );
//     }
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_remainingTime > 0) {
//           _remainingTime--;
//         } else {
//           _timer.cancel();
//           isGameActive = false;
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
//           );
//         }
//       });
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
//                 image: AssetImage("assets/images/new_bg_stage_test.png"),
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
//               '#stage 7',
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
//               child: Image.asset('assets/images/new_mooner.png',
//                   width: 200, height: 270, fit: BoxFit.cover),
//             ),
//           ),

//           //말풍선 표시
//           Positioned(
//             left: 30,
//             top: 120,
//             child: Stack(
//               children: <Widget>[
//                 Image.asset('assets/images/speechbubble.png',
//                     width: 100, height: 100, fit: BoxFit.cover),
//                 Positioned(
//                   left: 30,
//                   top: 30,
//                   child: Text(
//                     _bubbleNumber.toString(),
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 말한 내용 표시
//           Positioned(
//             bottom: 150,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 'Recognized: $_lastWords',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ),

//           // 음성 인식 버튼
//           Positioned(
//             bottom: 105,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_speech.isListening) {
//                     _speech.stop();
//                   } else {
//                     _listen();
//                   }
//                 },
//                 child: Text(_speech.isListening ? 'Listening...' : 'Listen'),
//               ),
//             ),
//           ),

//           // 현재 점수 및 별 표시
//           Positioned(
//             bottom: 80,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Column(
//                 children: [
//                   Text(
//                     'Score: $successCount',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   StarWidget(stars),
//                 ],
//               ),
//             ),
//           ),

//           // 다이얼로그 표시
//           if (isDialogueActive)
//             Positioned(
//               bottom: 200,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: GestureDetector(
//                   onTap: nextDialogue,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     color: Colors.white.withOpacity(0.5),
//                     child: Text(
//                       dialogues[dialogueIndex],
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 24),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//           // 시간 표시
//           Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 'Time left: $_remainingTime',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class UnspeakableCountNumberGameScreen extends StatefulWidget {
//   @override
//   _UnspeakableCountNumberGameScreenState createState() => _UnspeakableCountNumberGameScreenState();
// }

// class _UnspeakableCountNumberGameScreenState extends State<UnspeakableCountNumberGameScreen> {
//   int stars = 0;
//   int successCount = 0;
//   bool isGameActive = false;
//   bool isDialogueActive = true;
//   int dialogueIndex = 0;
//   int _bubbleNumber = 1; // 초기값 1
//   final TextEditingController _controller = TextEditingController();
//   late Timer _timer;
//   int _remainingTime = 180; // 3분

//   List<String> dialogues = [
//     "You have 3 minutes to complete 10 or more",
//     "Now let's try once.",
//   ];

//   @override
//   void initState() {
//     super.initState();
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
//       }
//     });
//   }

//   void startGame() {
//     setState(() {
//       isGameActive = true;
//     });
//     _startTimer(); // Start the timer
//   }

//   void restartGame() {
//     setState(() {
//       stars = 0;
//       successCount = 0;
//       isGameActive = true;
//       isDialogueActive = true;
//       dialogueIndex = 0;
//       _bubbleNumber = 1;
//       _remainingTime = 180;
//     });
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_remainingTime > 0) {
//           _remainingTime--;
//         } else {
//           _timer.cancel();
//           isGameActive = false;
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GameOverScreen(restartGame)),
//           );
//         }
//       });
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
//                 image: AssetImage("assets/images/new_bg_stage_test.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           //중앙에 플레이어 이미지를 표시
//           Positioned(
//             child: Center(
//               //화난 문어
//               // child: Image.asset('assets/images/anger_mooner.gif', width: 300, height: 300)
//               //     .animate()
//               //     .fadeIn(duration: Duration(seconds: 2)),

//               child: Image.asset('assets/images/new_mooner.png',
//                   width: 200, height: 270, fit: BoxFit.cover),
//             ),
//           ),

//           // 말풍선 표시
//           Positioned(
//             left: 30,
//             top: 120,
//             child: Stack(
//               children: <Widget>[
//                 Image.asset('assets/images/speechbubble.png',
//                     width: 100, height: 100, fit: BoxFit.cover),
//                 Positioned(
//                   left: 30,
//                   top: 30,
//                   child: Text(
//                     _bubbleNumber.toString(),
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 입력 필드 표시
//           Positioned(
//             bottom: 200,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Column(
//                 children: [
//                   Text(
//                     'Enter the number:',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   SizedBox(height: 10),
//                   Container(
//                     width: 100,
//                     child: TextField(
//                       controller: _controller,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       onSubmitted: (value) {
//                         if (value == _bubbleNumber.toString()) {
//                           setState(() {
//                             successCount++;
//                             if (_bubbleNumber < 10) {
//                               _bubbleNumber++;
//                             } else {
//                               print('Bubble number $_bubbleNumber matched with entered number $_bubbleNumber');
//                             }
//                           });

//                           // Clear the text field
//                           _controller.clear();

//                           // Update stars based on success count
//                           if (successCount >= 10) {
//                             stars = 3;
//                           } else if (successCount >= 7) {
//                             stars = 2;
//                           } else if (successCount >= 5) {
//                             stars = 1;
//                           } else {
//                             stars = 0;
//                           }

//                           // If 3 stars achieved, go to the next screen
//                           if (stars == 3) {
//                             _timer.cancel();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => GameWinScreen(restartGame)),
//                             );
//                           }
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // 현재 점수 및 별 표시
//           Positioned(
//             bottom: 100,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Column(
//                 children: [
//                   Text(
//                     'Score: $successCount',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   StarWidget(stars),
//                 ],
//               ),
//             ),
//           ),

//           // 다이얼로그 표시
//           if (isDialogueActive)
//             Positioned(
//               bottom: 300,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: GestureDetector(
//                   onTap: nextDialogue,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     color: Colors.white.withOpacity(0.5),
//                     child: Text(
//                       dialogues[dialogueIndex],
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 24),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//           // 시간 표시
//           Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 'Time left: $_remainingTime',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GameOverScreen extends StatelessWidget {
//   final Function restartCallback;

//   GameOverScreen(this.restartCallback);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Game Over!',
//               style: TextStyle(fontSize: 32),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 restartCallback();
//                 Navigator.pop(context);
//               },
//               child: Text('Restart'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GameWinScreen extends StatelessWidget {
//   final Function restartCallback;

//   GameWinScreen(this.restartCallback);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Congratulations! You Won!',
//               style: TextStyle(fontSize: 32),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 restartCallback();
//                 Navigator.pop(context);
//               },
//               child: Text('Play Again'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
