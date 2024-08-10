import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

void main() => runApp(ConversationGameApp());

class ConversationGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: ConversationGameScreen(),
    );
  }
}

class ConversationGameScreen extends StatefulWidget {
  @override
  _ConversationGameScreenState createState() => _ConversationGameScreenState();
}

class _ConversationGameScreenState extends State<ConversationGameScreen> {
  int score = 0;
  double _progress = 1.0;
  int currentIndex = 0;
  int dialogueIndex = 0;
  bool isDialogueComplete = false;

  List<String> dialogues = [
    '어부\n     문찌가 하고싶은 말이 있어보여. \n     적절한 말하기를 하도록 도와줘!',
  ];

  void nextDialogue() {
    setState(() {
      if (dialogueIndex < dialogues.length - 1) {
        dialogueIndex++;
      } else {
        isDialogueComplete = true;
      }
    });
  }

  List<ConversationItem> conversation = [
    ConversationItem(
      speaker: 'Character A',
      text: 'stage1',
      choices: [
        Choice(text: '이 말미잘아!', nextIndex: 1, score: -1),
        Choice(text: '(심호흡을 한다)', nextIndex: 1, score: 1),
      ],
    ),
    ConversationItem(
      speaker: 'Character A',
      text: 'stage2',
      choices: [
        Choice(text: '이 해삼 똥구멍아!!', nextIndex: 2, score: -2),
        Choice(text: '나 너무너무 화났어!', nextIndex: 2, score: 1),
      ],
    ),
    // 나머지 대화 내용은 그대로 유지...
  ];

  void _handleChoice(Choice choice) {
    setState(() {
      score += choice.score;
      currentIndex = choice.nextIndex;

      if (currentIndex == conversation.length - 1) {
        // 대화가 끝났을 때
        _showScoreDialog();
      }
    });
  }

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
            // 상단 스테이지번호
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
                '#stage 9',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // 별 프로그레스 바
            Positioned(
              left: 56,
              top: 200,
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none, // Positioned가 Stack 바깥으로 나가도록 허용
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      child: SimpleAnimationProgressBar(
                        height: 30,
                        width: 330,
                        backgroundColor: Colors.grey,
                        foregrondColor: Colors.red,
                        ratio: _progress,
                        direction: Axis.horizontal,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(seconds: 1),
                        borderRadius: BorderRadius.circular(10),
                        gradientColor: const LinearGradient(
                            colors: [Colors.red, Colors.orange],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                      ),
                    ),
                    Positioned(
                      left: -45,
                      top: -40, // 별 이미지를 약간 위로 올리기 위해 top 값 조정
                      child: Image.asset(
                        'assets/images/star.png', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      left: 105,
                      top: -40, // 중앙 별 이미지의 위치
                      child: Image.asset(
                        'assets/images/star.png', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      right: -45,
                      top: -40, // 오른쪽 끝 별 이미지의 위치
                      child: Image.asset(
                        'assets/images/star.png', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 중앙에 문어 이미지
            Positioned(
              child: Center(
                child: Image.asset('assets/images/normal_mooner_x.png',
                    width: 400, height: 320, fit: BoxFit.contain),
              ),
            ),
            if (!isDialogueComplete)
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: nextDialogue,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/fisher.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(47),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/dialog_background.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Text(
                              dialogues[dialogueIndex],
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (isDialogueComplete)
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '점수: $score',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      conversation[currentIndex].speaker,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
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
                            _handleChoice(conversation[currentIndex]
                                .choices[index]);
                          },
                          child: Text(
                            conversation[currentIndex].choices[index].text,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
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

  ConversationItem({
    required this.speaker,
    required this.text,
    required this.choices,
  });
}

class Choice {
  final String text;
  final int nextIndex;
  final int score;

  Choice({
    required this.text,
    required this.nextIndex,
    required this.score,
  });
}
