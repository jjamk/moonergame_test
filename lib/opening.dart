import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mooner_interface/stage.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

void main() => runApp(OpeningGameApp());

class OpeningGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: DialogueGame(),
    );
  }
}

class DialogueGame extends StatefulWidget {
  @override
  _DialogueGameState createState() => _DialogueGameState();
}

class _DialogueGameState extends State<DialogueGame> {
  final TextEditingController _textEditingController = TextEditingController();
  String name = "";

  List<Map<String, String>> script = [
    {"text": "??\n 안녕, 외부인이 이렇게 온건 오랜만이네! \n 무슨 일로 온 거야?", 
    "button": "나도 모르겠어. 너는 누군데?"},
    {"text": "어부\n 내가 누구냐고? \n 나는 이 섬에서 나고 자란 어부야. \n 특히 문어를 잡는 어부지. \n 아버지의 일을 물려받고 지금까지 일하고 있어.", 
    "button": "아하"},
    {"text": "어부\n 근데 내 소개를 들었으면 너도 얘기해야지.\n 넌 누군데?", 
    "button": "응 나는 말이야.."},
    {"text": "어부\n 아~. 이구나. \n 일단 환영해! \n 어디 갈 곳은 있어?", 
    "button": "아니.."},
    {"text": "어부\n 아…. 갈 곳이 없어?", 
    "button": "응"},
    {"text": "어부\n 그러면 나랑 같이 일해볼래? \n 정해진 일이 다 끝나면 \n 네가 원래 있던 곳으로 돌아가도록 도와줄게. \n 어때?", 
    "button": "알겠어"},
    {"text": "어부\n 대신 네가 한 가지 명심하는 게 있어. \n 아버지가 말씀하시길 문어 중에서는 \n 크기가 남다르고 먹물을 뿜는 특이한 문어가 있대.", 
    "button": "응?"},
    {"text": "어부\n 그 문어를 만나게 되면 잡지 말고 \n 잘 달래서 다시 바다로 돌려보내야 해. \n 그렇지 않으면 진짜 큰일이 벌어진대.", 
    "button": "그게 뭔데?"},
    {"text": "어부\n 큰일이 뭐냐고? 나도 당연히 모르지. \n 어부들 사이에서 옛날부터 전해져 내려오던 이야기래.", 
    "button": "아.. 그럼 어떻게 해야해?"},
    {"text": "어부\n 아 돌려보낼 방법? 당연히 있지. \n 대대로 전해져 내려오는 비밀 방법들이 있어. \n 내가 하라는 대로만 하면 괜찮을 거야. ", 
    "button": "할 수 있을까?"},
    {"text": "어부\n 긴장된다고? 걱정하지 마. \n 그 방법들만 제대로 해내면 어렵지 않을 거야. ", 
    "button": "응.."},
    {"text": "어부\n 날 믿어! \n 자, 이제 문어 잡으러 떠나볼까?", 
    "button": "가자!"},
  ];

  int scriptIndex = 0;

  void nextScript() {
    if (scriptIndex == 2) { // 두 번째 스크립트일 때만 입력 팝업창 표시
      showInputPopup();
    } else {
      if (scriptIndex < script.length - 1) {
        setState(() {
          scriptIndex++;
        });
      } else {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewStage()),
            );
        print("대화가 끝났습니다.");
      }
    }
  }

  void showInputPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('너의 이름은?'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: "여기에 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
              // 사용자가 입력한 텍스트를 다음 스크립트 텍스트로 설정
              String userInput = _textEditingController.text;
              // 다음 대화 스크립트 인덱스 확인 및 업데이트
              int nextScriptIndex = scriptIndex + 1;
              if (nextScriptIndex < script.length) {
                setState(() {
                  // 다음 스크립트의 텍스트를 사용자 입력으로 업데이트
                  script[nextScriptIndex]['text'] = "아~. $userInput이구나. 일단 환영해! 어디 갈 곳은 있어?";
                  scriptIndex++;
                });
              }
              Navigator.of(context).pop(); // 다이얼로그 닫기
              _textEditingController.clear(); // 입력 필드 초기화
            },
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: <Widget>[
        // 배경 이미지
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_openclosing.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (scriptIndex == 7) ...[
                // 7번째 대화 전: 3angry_mooner_o.svg 터치 가능
                GestureDetector(
                  onTap: nextScript, // 클릭 시 다음 대화로 넘어감
                  child: SvgPicture.asset(
                    'assets/images/3angry_mooner_o.svg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ]

              else ...[
                // 기본 대화 UI
                // SvgPicture.asset(
                //   'assets/images/fisherman_front.svg',
                //   width: 250,
                //   height: 250,
                //   fit: BoxFit.cover,
                // ),

                if(scriptIndex == 0) ...<Widget>[
                  SvgPicture.asset(
                    'assets/images/fisherman_shadow.svg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                ]              
                else if(scriptIndex == 1) ...<Widget>[
                  SvgPicture.asset(
                    'assets/images/fisherman_shadow.svg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                ]
                else...[
                  SvgPicture.asset(
                    'assets/images/fisherman_front.svg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ],                 
                SizedBox(height: 16.0),
                Stack(
                  children: [
                    // dialog_background 이미지
                    Container(
                      width: MediaQuery.of(context).size.width * 2,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/dialog_background.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    // 대화 텍스트
                    Positioned.fill(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            script[scriptIndex]['text']!,
                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: nextScript,
                  child: Text(script[scriptIndex]['button']!),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}



  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}