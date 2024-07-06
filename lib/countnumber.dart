import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:math';

void main() => runApp(CountNumberGameApp());

class CountNumberGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: CountNumberGameScreen(),
    );
  }
}

class CountNumberGameScreen extends StatefulWidget {
  @override
  _CountNumberGameScreenState createState() => _CountNumberGameScreenState();
}

class _CountNumberGameScreenState extends State<CountNumberGameScreen> {
  late stt.SpeechToText _speech;
  String _lastWords = '';
  String _randomNumber = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _generateRandomNumber();
  }

  void _generateRandomNumber() {
    Random random = Random();
    _randomNumber = (random.nextInt(10) + 1).toString();
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
            // Convert spoken words to numbers
            switch (_lastWords) {
case '하나':
                  _lastWords = '1';
                  break;
                case '둘':
                  _lastWords = '2';
                  break;
                case '셋':
                  _lastWords = '3';
                  break;
                case '넷':
                  _lastWords = '4';
                  break;
                case '다섯':
                  _lastWords = '5';
                  break;

                case '여섯':
                  _lastWords = '6';
                  break;

                case '일곱':
                  _lastWords = '7';
                  break;

                case '여덟':
                  _lastWords = '8';
                  break;

                case '아홉':
                  _lastWords = '9';
                  break;

                case '열':
                  _lastWords = '10';
                  break;

                case '하나 둘 셋 넷 다섯':
                  _lastWords = '1 2 3 4 5';
                  break;
              default:
                // If unrecognized word, keep the same word
                break;
            }
          });
        },
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

          //말풍선 표시
          Positioned(
            left: 40,
            top: 140,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/speechbubble.png',
                    width: 100, height: 100, fit: BoxFit.cover),
                Positioned(
                  left: 40,
                  top: 25,
                  child: Text(
                    getRandomNumber(),
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

          //마지막 단어 출력
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Last Spoken Number: $_lastWords',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          // 음성 인식 버튼
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _listen();
                },
                child:
                    Text(_speech.isListening ? 'Listening...' : 'Start Listening'),
              ),
            ),
          )
        ],
      ),
    );
  }
    //1부터 10까지 랜덤숫자 생성
  String getRandomNumber() {
    Random random = new Random();
    return (random.nextInt(10) + 1).toString();
  }
}
