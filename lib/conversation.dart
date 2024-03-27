import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
void main() => runApp(ConversationGameApp());

class ConversationGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialDialogueScreen(),
      //home: ConversationGameScreen(),
    );
  }
}

class InitialDialogueScreen extends StatefulWidget {
  @override
  _InitialDialogueScreenState createState() => _InitialDialogueScreenState();
}

class _InitialDialogueScreenState extends State<InitialDialogueScreen> {
  // 대화 인덱스와 대화 내용
  int dialogueIndex = 0;
  List<String> dialogues = [
    "너무너가 하고싶은 말이 있어 보여.\n 나 전달법을 사용해서 말할 수 있도록 도와주자.",
  ];

  void nextDialogue() {
    setState(() {
      if (dialogueIndex < dialogues.length - 1) {
        dialogueIndex++;
      } else {
        // 모든 대화가 완료되었을 때, 게임 화면으로 전환
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConversationGameScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(dialogues[dialogueIndex], style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: nextDialogue, child: Text("시작하기")),
          ],
        ),
      ),
    );
  }
}

class ConversationGameScreen extends StatefulWidget {
  @override
  _ConversationGameScreenState createState() => _ConversationGameScreenState();
}

class _ConversationGameScreenState extends State<ConversationGameScreen> {
  int score = 0;
  Timer? _timer;
  final int _timeLimit = 30; // 30초 제한 시간
  double _progress = 1.0;
  double ratio = 0;

  List<ConversationItem> conversation = [
    ConversationItem(
      speaker: 'Character A',
      text: 'stage1',
      choices: [
        Choice(text: '이 말미잘아!', nextIndex:1, score:-1 ),
        Choice(text: '(심호흡을 한다)', nextIndex:1, score: 1),
      ],
    ),
    ConversationItem(
      speaker: 'Character A',
      text: 'stage2',
      choices: [
        Choice(text: '이 해삼 똥구멍아!!', nextIndex:2,score: -2),
        Choice(text: '나 너무너무 화났어!', nextIndex:2,score: 1),
      ],
    ),
    ConversationItem(
      speaker: 'Character A',
      text: 'stage3',
      choices: [
        Choice(text: '너 내말 똑똑히 들어!', nextIndex:3,score: -2),
        Choice(text: '나는 우리가 대화가 필요하다고 생각해', nextIndex:3,score: 1),

      ],
    ),
    ConversationItem(
      speaker: 'Character A',
      text: 'stage4',
      choices: [
        Choice(text: '너는 진짜 너무해..', nextIndex:4,score: -1),
        Choice(text: '나는 너가 진짜 너무했다는 생각이 들어', nextIndex:4,score: 1),
      ],
    ),
    ConversationItem(
      speaker: 'Character A',
      text: 'stage5',
      choices: [
        Choice(text: '너는 항상 그런식으로 말해! ', nextIndex:5,score: -3),
        Choice(text: '너 왜 그런식으로 말해?', nextIndex:5,score: -2),
        Choice(text: '나는 너가 그런식으로 말하면 화가나!', nextIndex:5,score: 1),
      ],
    ),
    ConversationItem(
      speaker: 'Character A',
      text: 'stage6',
      choices: [
        Choice(text: '너는 나쁜사람이야! ', nextIndex:6,score: -3),
        Choice(text: '너의 그런 행동은 나빠!', nextIndex:6,score: -2),
        Choice(text: '나는 너가 나쁜사람이라는 생각이 들었어.', nextIndex:6,score: -1),
        Choice(text: '나는 너의 그런 행동이 나쁘다고 생각해.', nextIndex:6,score: 2),
      ],
    ),
    ConversationItem(
      speaker: 'Character A',
      text: 'stage7',
      choices: [
        Choice(text: '다시는 그딴식으로 말하지 마!  ', nextIndex:7,score: -3),
        Choice(text: '너 그렇게 말하면 안돼.', nextIndex:7,score: -2),
        Choice(text: '나는 너가 그렇게 말하지 않았으면 좋겠어', nextIndex:7,score: 1),
      ],
    ),
    ConversationItem(
      speaker: 'Character A',
      text: 'stage7',
      choices: [
        Choice(text: '다시는 그딴식으로 말하지 마!  ', nextIndex:7,score: -3),
        Choice(text: '너 그렇게 말하면 안돼.', nextIndex:7,score: -2),
        Choice(text: '나는 너가 그렇게 말하지 않았으면 좋겠어', nextIndex:7,score: 1),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        ratioVal();
        _progress -= 1 / _timeLimit; // 매 초마다 진행률 감소

        if (_progress <= 0) {
          _timer?.cancel();
          _showScoreDialog();
        }
      });
    });
  }

  void _handleChoice(Choice choice) {
    setState(() {
      score += choice.score;
      currentIndex = choice.nextIndex;

      if (currentIndex == conversation.length-1) {
      // 대화가 끝났을 때
      _timer?.cancel();
      _showScoreDialog();
    } 
    });
  }

  


  @override
  void dispose() {
    _timer?.cancel(); // 타이머 정리
    super.dispose();
  }


  void ratioVal() {
    if (ratio == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          ratio = 0.2;
        });
        if (ratio == 0.2) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              ratio = 0.4;
            });
            if (ratio == 0.4) {
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  ratio = 0.7;
                });
                if (ratio == 0.7) {
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      ratio = 1;
                    });
                    if (ratio == 1) {
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          ratio = 0;
                        });
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });
    }
  }
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                '#stage 10',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  Text(
                    'Score: $_timer',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    conversation[currentIndex].speaker,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    conversation[currentIndex].text,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: conversation[currentIndex].choices.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          _handleChoice(conversation[currentIndex].choices[index]);
                        },
                        child: Text(
                          conversation[currentIndex].choices[index].text,
                        ),
                      );
                    },
                  ),
                SimpleAnimationProgressBar(
                height: 300,
                width: 15,
                backgroundColor: Colors.grey,//Colors.grey.shade800,
                foregrondColor: Colors.red,
                ratio: _progress,
                direction: Axis.vertical,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(seconds: 1),
                borderRadius: BorderRadius.circular(10),
                gradientColor: const LinearGradient(
                    colors: [Colors.red, Colors.orange],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
                  // LinearProgressIndicator(
                  //   value: _progress, // 진행률에 따라 막대 길이 변경
                  //   backgroundColor: Colors.grey, // 배경색
                  //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // 막대색
                  // ),
                ],
              ),
            ),
          
          ]),
        ),
      );
  }
  
  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Your final score is $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewStage()),
                      );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ConversationItem {
  final String speaker;
  final String text;
  final List<Choice> choices;

  ConversationItem({required this.speaker, required this.text, required this.choices});
}

class Choice {
  final String text;
  final int nextIndex;
  final int score;

  Choice({required this.text, required this.nextIndex, required this.score});
}