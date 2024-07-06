

    import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
    {"text": "안녕, 외부인이 이렇게 온건 오랜만이네! 무슨 일로 온 거야?", "button": "나도 모르겠어. 너는 누군데?"},
    {"text": "내가 누구냐고? 나는 이 섬에서 나고 자란 어부야. 특히 문어를 잡는 어부지. 아버지의 일을 물려받고 지금까지 일하고 있어.", "button": "아하"},
    {"text": "근데 내 소개를 들었으면 너도 얘기해야지. 넌 누군데?", "button": "응 나는 말이야.."},
    {"text": "아~. 이구나. 일단 환영해! 어디 갈 곳은 있어?", "button": "아니.."},
    {"text": "아…. 갈 곳이 없어?", "button": "응"},
    {"text": "그러면 나랑 같이 일해볼래? 정해진 일이 다 끝나면 네가 원래 있던 곳으로 돌아가도록 도와줄게. 어때?", "button": "알겠어"},
    {"text": "대신 네가 한 가지 명심하는 게 있어. 아버지가 말씀하시길 문어 중에서는 크기가 남다르고 먹물을 뿜는 특이한 문어가 있대.", "button": "응?"},
    {"text": "그 문어를 만나게 되면 잡지 말고 잘 달래서 다시 바다로 돌려보내야 해. 그렇지 않으면 진짜 큰일이 벌어진대.", "button": "그게 뭔데?"},
    {"text": "큰일이 뭐냐고? 나도 당연히 모르지. 어부들 사이에서 옛날부터 전해져 내려오던 이야기래.", "button": "아.. 그럼 어떻게 해야해?"},
    {"text": "아 돌려보낼 방법? 당연히 있지. 대대로 전해져 내려오는 비밀 방법들이 있어. 내가 하라는 대로만 하면 괜찮을 거야. ", "button": "할 수 있을까?"},
    {"text": "긴장된다고? 걱정하지 마. 그 방법들만 제대로 해내면 어렵지 않을 거야. ", "button": "응.."},
    {"text": "날 믿어! 자, 이제 문어 잡으러 떠나볼까?", "button": "가자!"},
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
      appBar: AppBar(
        title: Text('오프닝'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              script[scriptIndex]['text']!,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          ElevatedButton(
            onPressed: nextScript,
            child: Text(script[scriptIndex]['button']!),
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