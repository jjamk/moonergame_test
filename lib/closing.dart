//그냥 끝
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(ClosingGameApp());
}

class ClosingGameApp extends StatelessWidget {
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
  final List<String> messages = [
    "드디어 할 일을 모두 완료했네.\n 도와줘서 고마워.",
    "이제 네가 돌아갈 수 있게 도와줄게",
    "먼저 너가 문어를 달래주기 위해 했던 \n 방법들을 생각해볼래?",
    "심호흡도 하고 자장가도 불러주고, \n 맞다! 같이 운동도 해줬잖아",
    "네가 화가 난 문어였다면 \n 너의 행동에 기분이 어땠을 것 같아?",
    "그럼 지금의 너는 화가 났을 때 \n 어떻게 행동하고 있었어?",
    "그럴 때 문어에게 했던 \n 방법들을 사용한다면 \n 너의 기분은 어떻게 변할 것 같아?",
    "그래. 네가 달래준 그 문어는 \n 너의 마음 속에 존재하는 감정이야",
    "문어를 달래주기 위해 \n 사용한 방법들은 너 스스로 감정을 \n 조절할 수 있도록 도와줄 수 있어",
    "감정이 조절되지 않을 때 \n 문어를 달래줬던 기억을 떠올려봐",
    "화난 문어가 금방 차분해진 것처럼 \n 너도 조절할 수 있어",
    "혼자 하기 어렵다면 \n 우리의 기억을 모아둔 해변에 \n 방문해 다시 문어와 함께 진행해봐",
    "이번 여정이 너에게 \n 큰 도움이 됐으면 좋겠어",
    "나랑 함께 \n 문어를 달래줘서 고마워",
    "다음에 또 보자!"
  ];

  int _currentMessageIndex = 0;

  void _showNextMessage() {
    setState(() {
      if (_currentMessageIndex < messages.length - 1) {
        _currentMessageIndex++;
      }
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
                image: AssetImage("assets/images/bg_openclosing.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
              children: [
                // Fisherman 이미지를 중앙에 배치
                SvgPicture.asset(
                  'assets/images/fisherman_front.svg',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),

                // Dialog background을 클릭했을 때 다음 메시지를 표시
                GestureDetector(
                  onTap: _showNextMessage,
                  child: Container(
                    width: 350,
                    height: 130,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/dialog_background.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        messages[_currentMessageIndex],
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 대화 끝난 후 해변의 비밀로 이동
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:mooner_interface/Secret.dart';

// void main() {
//   runApp(ClosingGameApp());
// }

// class ClosingGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(fontFamily: 'BMJUA'),
//       home: DialogueGame(),
//     );
//   }
// }

// class DialogueGame extends StatefulWidget {
//   @override
//   _DialogueGameState createState() => _DialogueGameState();
// }

// class _DialogueGameState extends State<DialogueGame> {
//   final List<String> messages = [
//     "드디어 할 일을 모두 완료했네.\n 도와줘서 고마워.",
//     "이제 네가 돌아갈 수 있게 도와줄게",
//     "먼저 너가 문어를 달래주기 위해 했던 \n 방법들을 생각해볼래?",
//     "심호흡도 하고 자장가도 불러주고, \n 맞다! 같이 운동도 해줬잖아",
//     "네가 화가 난 문어였다면 \n 너의 행동에 기분이 어땠을 것 같아?",
//     "그럼 지금의 너는 화가 났을 때 \n 어떻게 행동하고 있었어?",
//     "그럴 때 문어에게 했던 \n 방법들을 사용한다면 \n 너의 기분은 어떻게 변할 것 같아?",
//     "그래. 네가 달래준 그 문어는 \n 너의 마음 속에 존재하는 감정이야",
//     "문어를 달래주기 위해 \n 사용한 방법들은 너 스스로 감정을 \n 조절할 수 있도록 도와줄 수 있어",
//     "감정이 조절되지 않을 때 \n 문어를 달래줬던 기억을 떠올려봐",
//     "화난 문어가 금방 차분해진 것처럼 \n 너도 조절할 수 있어",
//     "혼자 하기 어렵다면 \n 우리의 기억을 모아둔 해변에 \n 방문해 다시 문어와 함께 진행해봐",
//     "이번 여정이 너에게 \n 큰 도움이 됐으면 좋겠어",
//     "나랑 함께 \n 문어를 달래줘서 고마워",
//     "다음에 또 보자!"
//   ];

//   int _currentMessageIndex = 0;

//   void _showNextMessage() {
//     setState(() {
//       if (_currentMessageIndex < messages.length - 1) {
//         _currentMessageIndex++;
//       } else {
//         // 마지막 메시지를 클릭하면 SecretGameApp으로 이동
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => SecretGameApp()),
//         );
//       }
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
//                 image: AssetImage("assets/images/bg_openclosing.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
//               children: [
//                 // Fisherman 이미지를 중앙에 배치
//                 SvgPicture.asset(
//                   'assets/images/fisherman_front.svg',
//                   width: 250,
//                   height: 250,
//                   fit: BoxFit.cover,
//                 ),

//                 // Dialog background을 클릭했을 때 다음 메시지를 표시
//                 GestureDetector(
//                   onTap: _showNextMessage,
//                   child: Container(
//                     width: 350,
//                     height: 130,
//                     padding: EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage("assets/images/dialog_background.png"),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         messages[_currentMessageIndex],
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
