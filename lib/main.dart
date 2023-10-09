import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'piano.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '문어잡기 게임',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MoleGame(),
    );
  }
}

class MoleGame extends StatefulWidget {
  @override
  State<MoleGame> createState() => _MoleGameState();
}

class _MoleGameState extends State<MoleGame> {
  int score = 0;
  int duration = 10;
  List<bool> moles = List.generate(9, (index) => false);
  Timer? gameTimer;
  bool isGameActive = true;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = 'blank';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //myBanner = GoogleAdMob.loadBannerAd();
    //myBanner.load();
    startGame();
    _speech = stt.SpeechToText();
    _listen();
  }

  void startGame() {
    gameTimer = Timer.periodic(Duration(seconds: duration), (timer) {
      setState(() {
        timer.cancel();
        gameTimer = null;
        isGameActive = false;
      });
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (isGameActive) {
        spawnMole();
      } else {
        timer.cancel();
      }
    });
  }

  void spawnMole() {
    Random random = Random();
    int molePosition = random.nextInt(9);

    setState(() {
      moles = List.generate(9, (index) => index == molePosition);
    });
  }

  void handleMoleTap(int index) {
    setState(() {
      if (moles[index]) {
        score++;
      }
    });
  }

  void restartGame() {
    setState(() {
      score = 0;
      isGameActive = true;
      startGame();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    gameTimer?.cancel();
    //_banner.dispose();

    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (error) {
          print('Error: $error');
        },
      );
      print(available);
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _lastWords = result.recognizedWords;
              if (_lastWords.toLowerCase() == "one") {
                _lastWords = "1";
              } else if (result.recognizedWords == "two") {
              } else if (result.recognizedWords == "three") {
              } else if (result.recognizedWords == "four") {
              } else if (result.recognizedWords == "five") {}
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("0. 문어잡기 게임"),
        ),
        body: Center(
          child: Stack(alignment: Alignment.center, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '점수: $score',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (isGameActive) {
                          handleMoleTap(index);
                        }
                      },
                      child: Image.asset(
                        moles[index]
                            ? 'assets/images/mooner.png'
                            : 'assets/images/doodeo.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  itemCount: 9,
                ),
              ],
            ),
            if (!isGameActive)
              Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Game Over\n score: $score',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              restartGame();
                            },
                            child: Text('다시하기'),
                          )
                        ]),
                  ))
          ]),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          //https://jinho-study.tistory.com/1083
          //https://www.youtube.com/watch?v=dI-NHSv2WKI
          title: Text("1. 미로 게임"),
        ),
        body: Center(
          child: Lottie.asset(
            'assets/images/loading_example.json',
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.lightGreen,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("2/3. 상처 달래주기&근육이완법"),
        ),
        body: Center(
          child: Lottie.asset(
            'assets/images/loading_example.json',
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("4. 운동하기"),
        ),
        body: Center(
          child: Lottie.asset(
            'assets/images/loading_example.json',
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("5. 심호흡하기"),
        ),
        body: Center(
          child: Lottie.asset(
            'assets/images/animation_example.json',
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("6. 숫자세기"),
        ),
        body: Center(
            child: Column(
          children: [
            Text(
              _lastWords,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                onPressed: () {
                  _listen();
                  print(_isListening);
                },
                child:
                    Text(_isListening ? 'Stop Listening' : 'Start Listening')),
          ],
        )),
      ),
      Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("7. 자장가 불러주기"),
        ),
        body: Center(child: PianoGameApp()),
      ),
    ];
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              fullTransitionValue: 500,
              positionSlideIcon: 0.8,
              slideIconWidget: Icon(Icons.arrow_back_ios),
            ),
          ],
        ),
      ),
    );
  }
}
