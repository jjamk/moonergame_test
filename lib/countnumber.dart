//키보드 랜덤 재배치 good
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mooner_interface/stage.dart';
import 'package:mooner_interface/stage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

void main() => runApp(CountNumberGameApp());

class CountNumberGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'BMJUA'),
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
            image: AssetImage("assets/images/bg_stage.png"),
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

            // 음성인식 횟수에 따라 별 업데이트
            if (successCount >= 9) {
              stars = 3;
            } else if (successCount >= 7) {
              stars = 2;
            } else if (successCount >= 5) {
              stars = 1;
            } else {
              stars = 0;
            }

            if (successCount >= 10) {
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
              child: SvgPicture.asset('assets/images/normal_mooner_o.svg',
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
  _UnspeakableCountNumberGameScreenState createState() =>
      _UnspeakableCountNumberGameScreenState();
}

class _UnspeakableCountNumberGameScreenState extends State<UnspeakableCountNumberGameScreen> {
  int stars = 0;
  int successCount = 0;
  bool isGameActive = false;
  bool isDialogueActive = true;
  int dialogueIndex = 0;
  int _bubbleNumber = 1;
  late Timer _timer;
  int _remainingTime = 180;
  List<int> _numberPad = List.generate(10, (index) => index + 1);

  List<String> dialogues = [
    "화면에 있는 숫자와 같은 숫자를 찾아봐",
    "3분 안에 10개 이상 성공하면 돼",
    "이제 한 번 시작해볼까?",
  ];

  @override
  void initState() {
    super.initState();
    _shuffleNumberPad();
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
    _startTimer();
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
      _shuffleNumberPad();
    });
    _startTimer();
  }

  void _shuffleNumberPad() {
    _numberPad.shuffle();
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



  void _onNumberPress(int number) {
    if (number == _bubbleNumber) {
      successCount++;
      if (_bubbleNumber < 10) {
        setState(() {
          _bubbleNumber++;
          _shuffleNumberPad();
        });
      }
    }

    if (successCount >= 9) {
      setState(() {
        stars = 3;
      });
    } else if (successCount >= 7) {
      setState(() {
        stars = 2;
      });
    } else if (successCount >= 5) {
      setState(() {
        stars = 1;
      });
    } else {
      setState(() {
        stars = 0;
      });
    }

    if (successCount >= 10) {
      _timer.cancel();
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
              child: SvgPicture.asset('assets/images/normal_mooner_o.svg',
                  width: 200, height: 270, fit: BoxFit.cover),
            ),
          ),
          // 말풍선 표시
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

          // 중앙 하단에 숫자 키패드 표시
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                for (int i = 0; i < 4; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int j = 0; j < 3; j++)
                        if (i * 3 + j < _numberPad.length)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () => _onNumberPress(_numberPad[i * 3 + j]),
                              child: Text(
                                _numberPad[i * 3 + j].toString(),
                                style: TextStyle(fontSize: 24),
                              ),
                          ),
                        ),
                    ],
                  ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //     onPressed: () => _onNumberPress(_numberPad[9]),
                //     child: Text(
                //       _numberPad[9].toString(),
                //       style: TextStyle(fontSize: 24),
                //     ),
                //   ),
                // ),
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

          // 상단에 별을 표시
          Positioned(
            top: 50,
            right: 20,
            child: StarWidget(stars),
          ),

          // 타이머 표시
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              '남은 시간: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
