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
  double _progress = 1.0;
  int currentIndex = 0;
  int dialogueIndex = 0;
  bool isDialogueComplete = false;
  String feedbackMessage = ''; // Store feedback
  bool showFeedback = false; 
  bool showcorrect = false;

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
      choices: [
        Choice(text: '이 말미잘아!', nextIndex: 1, feedback: '상대방을 공격하는 말은 갈등을 크게 만들고 상대방을 방어적으로 만듭니다.', correct: false),
        Choice(text: '(심호흡을 한다)', nextIndex: 1, feedback: '잘했어요! 심호흡은 긴장을 풀어주고 차분하게 생각할 시간을 만들어줘요.', correct: true),
      ],
    ),
    ConversationItem(
      choices: [
        Choice(text: '이 해삼 똥구멍아!!', nextIndex: 2, feedback: '상대방을 공격하는 말은 갈등을 크게 만들고 상대방을 방어적으로 만들어요.', correct: false),
        Choice(text: '나 너무너무 화났어!', nextIndex: 2, feedback: '잘했어요! 상대방을 공격하지 않고 자신의 감정을 솔직하게 표현하면, 상대방이 자신의 감정을 이해할 수 있게 해요.', correct: true),
      ],
    ),
    ConversationItem(
      choices: [
        Choice(text: '나는 우리가 대화가 필요하다고 생각해', nextIndex: 3, feedback: '잘했어요!자신의 생각과 감정을 솔직하게 전달하면, 상대방은 존중받는다고 느끼며 대화에 참여하게 돼요.', correct: true),
        Choice(text: '너 내 말 똑똑히 들어!', nextIndex: 3, feedback: '상대방에게 명령하듯이 말하면, 상대방은 존중받지 못하고 있다는 느낌을 받게돼요.', correct: false),
      ],
    ),
    ConversationItem(
      choices: [
        Choice(text: '너는 진짜 너무해..', nextIndex: 4, feedback: '상대방을 직접적으로 비난하는 말은 상대방을 방어적으로 만들어요.', correct: false),
        Choice(text: '나는 너가 진짜 너무했다는 생각이 들어..', nextIndex: 4, feedback: '잘했어요!\'나\'로 시작하는 "나-전달법"을 사용해서 자신의 감정과 생각을 표현하면, 상대방이 더 쉽게 이해하고 받아들일 수 있어요.', correct: true),
      ],
    ),
    ConversationItem(
      choices: [
        Choice(text: '너는 항상 그런식으로 말해!', nextIndex: 5, feedback: '상대방을 공격하는 말은 갈등을 크게 만들고 상대방을 방어적으로 만들어요.', correct: false),
        Choice(text: '나는 네가 그런식으로 말하면 화가 나!', nextIndex: 5, feedback: '잘했어요!\'나\'로 시작하는 "나-전달법"을 사용해서 자신의 감정과 생각을 표현하면, 상대방이 더 쉽게 이해하고 받아들일 수 있어요.', correct: true),
        Choice(text: '너 왜 그런식으로 말해?', nextIndex: 5, feedback: '상대방의 행동을 비난하거나 공격적인 질문은 존중받지 못하고 있다는 느낌을 받게해요.', correct: false),
      ],
    ),
    ConversationItem(
      choices: [
        Choice(text: '나는 너의 그런 행동이 나쁘다고 생각해', nextIndex: 6, feedback: '\'나\'로 시작하는 "나-전달법"을 사용해서 자신의 감정과 생각을 잘 표현했고, 상대방의 인격이 아닌 행동을 지목하면 상대방이 더 쉽게 받아들일 수 있어요!', correct: true),
        Choice(text: '너의 그런 행동은 나빠!', nextIndex: 6, feedback: '상대방의 특정 행동을 공격하는 말이에요. 상대를 방어적으로 만들어요.', correct: false),
        Choice(text: '나는 너가 나쁜 사람이라는 생각이 들었어', nextIndex: 6, feedback: '\'나\'로 시작하는 "나-전달법"을 사용해서 자신의 감정과 생각을 표현했지만, 상대방의 인격을 평가하는 말이기 때문에 들으면 기분이 나빠요.', correct: false),
      ],
    ),
    ConversationItem(
      choices: [
        Choice(text: '다시는 그딴 식으로 하지 마!', nextIndex: 7, feedback: '상대방에게 명령하듯이 말하면, 상대방은 존중받지 못하고 있다는 느낌을 받게돼요.', correct: false),
        Choice(text: '너 그렇게 하면 안돼.', nextIndex: 7, feedback: '상대방에게 명령하듯이 말하면, 상대방은 존중받지 못하고 있다는 느낌을 받게돼요.', correct: false),
        Choice(text: '나는 너가 그렇게 하지 않았으면 좋겠어', nextIndex: 7, feedback: '"나-전달법"을 사용하면 자신의 생각과 감정을 표현하면서도 상대방을 존중할 수 있어요.', correct: true),
      ],
    ),
  ];

  void _handleChoice(Choice choice) {
    setState(() {
      currentIndex = choice.nextIndex;
      feedbackMessage = choice.feedback; // Set feedback message
      showFeedback = true; // Show feedback
      isDialogueComplete = false;
      showcorrect = choice.correct;
    });

    // Hide feedback after a short delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showFeedback = false;
      });
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
                  clipBehavior: Clip.none,
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
                      top: -40,
                      child: Image.asset(
                        'assets/images/star.png',
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      left: 105,
                      top: -40,
                      child: Image.asset(
                        'assets/images/star.png',
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      right: -45,
                      top: -40,
                      child: Image.asset(
                        'assets/images/star.png',
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
            if (showcorrect && showFeedback)
              Positioned(
              child: Center(
                child: Image.asset('assets/images/correct.png',
                    width: 400, height: 320, fit: BoxFit.contain),
              ),
            ),
            if (!showcorrect  && showFeedback)
              Positioned(
              child: Center(
                child: Image.asset('assets/images/incorrect.png',
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
                              showFeedback
                                  ? feedbackMessage
                                  : dialogues[dialogueIndex], // Use feedbackMessage if showFeedback is true
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
}

class ConversationItem {
  final List<Choice> choices;

  ConversationItem({
    required this.choices,
  });
}

class Choice {
  final String text;
  final int nextIndex;
  final String feedback;
  final bool correct;

  Choice({
    required this.text,
    required this.nextIndex,
    required this.feedback,
    required this.correct,
  });
}
