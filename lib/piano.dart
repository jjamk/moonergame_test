import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() => runApp(PianoGameApp());

class PianoGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PianoGameScreen(),
    );
  }
}

class PianoGameScreen extends StatefulWidget {
  @override
  _PianoGameState createState() => _PianoGameState();
}

String selectedSongName = '';

class _PianoGameState extends State<PianoGameScreen> {
  // final List<Color> keyColors = [
  //   Colors.white70,
  //   Color.fromARGB(26, 255, 255, 255),
  //   Colors.white70,
  //   Color.fromARGB(26, 255, 255, 255),
  //   Colors.white70,
  //   Color.fromARGB(26, 255, 255, 255),
  //   Colors.white,
  //   Color.fromARGB(26, 255, 255, 255),
  // ];

  void playSound(String note) async {
    late AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    _assetsAudioPlayer.open(Audio("assets/audio/$note.mp3"));
    _assetsAudioPlayer.play();
    //_assetsAudioPlayer.stop();
  }

  void pp(double x, double y, List<int> ans) async {
    GestureBinding.instance.handlePointerEvent(PointerDownEvent(
      position: Offset(x, y),
    )); //trigger button up,

    await Future.delayed(Duration(milliseconds: 200));
    //add delay between up and down button

    GestureBinding.instance.handlePointerEvent(PointerUpEvent(
      position: Offset(x, y),
    ));

    await Future.delayed(Duration(milliseconds: 200));
    //trigger button down)),
    ans.clear();
  }

  @override
  Widget build(BuildContext context) {
    final mybuttonKey = GlobalKey();
    final mybuttonKey2 = GlobalKey();
    final mybuttonKey3 = GlobalKey();
    final mybuttonKey4 = GlobalKey();
    final mybuttonKey5 = GlobalKey();
    final mybuttonKey6 = GlobalKey();
    final mybuttonKey7 = GlobalKey();
    final mybuttonKey8 = GlobalKey();

    final List<int> answer = [];

    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
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
            '#stage 7',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  key: mybuttonKey,
                  onPressed: () {
                    print("button is pressed");
                    playSound("C");
                    answer.add(1);
                    print(answer);
                    checkAnswer(answer, selectedSongName);
                  },
                  child: Text("도"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  key: mybuttonKey2,
                  onPressed: () {
                    print("button2 is pressed");
                    playSound("D");
                    answer.add(2);
                    checkAnswer(answer, selectedSongName);
                  },
                  child: Text("레"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  key: mybuttonKey3,
                  onPressed: () {
                    print("button3 is pressed");
                    playSound("E");
                    answer.add(3);
                    checkAnswer(answer, selectedSongName);
                  },
                  child: Text("미"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  key: mybuttonKey4,
                  onPressed: () {
                    print("button4 is pressed");
                    playSound("F");
                    answer.add(4);
                    checkAnswer(answer, selectedSongName);
                  },
                  child: Text("파"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  key: mybuttonKey5,
                  onPressed: () {
                    print("button5 is pressed");
                    playSound("G");
                    answer.add(5);
                    checkAnswer(answer, selectedSongName);
                  },
                  child: Text("솔"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  key: mybuttonKey6,
                  onPressed: () {
                    print("button6 is pressed");
                    playSound("A");
                    answer.add(6);
                    checkAnswer(answer, selectedSongName);
                  },
                  child: Text("라"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  key: mybuttonKey7,
                  onPressed: () {
                    print("button7 is pressed");
                    playSound("B");
                    answer.add(7);
                    checkAnswer(answer, selectedSongName);
                  },
                  child: Text("시"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  key: mybuttonKey8,
                  onPressed: () {
                    print("button8 is pressed");
                    playSound("CC");
                    answer.add(8);
                    checkAnswer(answer, selectedSongName);
                  },
                  child: Text("높도"),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: ElevatedButton(
                    child: Text("비행기"),
                    onPressed: () async {
                      selectedSongName = '비행기';
                      RenderBox renderbox =
                          mybuttonKey3.currentContext! //mybuttonKey == '미'
                              .findRenderObject() as RenderBox;
                      Offset position = renderbox.localToGlobal(Offset.zero);

                      RenderBox renderbox2 = mybuttonKey2.currentContext! //레
                          .findRenderObject() as RenderBox;
                      Offset position2 = renderbox2.localToGlobal(Offset.zero);

                      RenderBox renderbox3 = mybuttonKey5.currentContext! //도
                          .findRenderObject() as RenderBox;
                      Offset position3 = renderbox3.localToGlobal(Offset.zero);

                      double x = position.dx;
                      double y = position.dy; //미

                      double x2 = position2.dx;
                      double y2 = position2.dy; //레

                      double x3 = position3.dx;
                      double y3 = position3.dy; //도

                      //print(x);
                      //print(y);

                      await Future.delayed(Duration(milliseconds: 200)); //미
                      pp(x, y, answer);
                      await Future.delayed(Duration(milliseconds: 500)); //솔
                      pp(x2, y2, answer);
                      await Future.delayed(Duration(milliseconds: 500)); //라
                      pp(x3, y3, answer);
                      await Future.delayed(Duration(milliseconds: 500)); //시
                      pp(x2, y2, answer);
                      await Future.delayed(Duration(milliseconds: 500)); //시
                      pp(x, y, answer);
                      await Future.delayed(Duration(milliseconds: 500)); //시
                      pp(x, y, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x, y, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                    }),
              ),
              Flexible(
                child: ElevatedButton(
                    child: Text("나비야"),
                    onPressed: () async {
                      selectedSongName = '나비야';
                      RenderBox renderbox5 =
                          mybuttonKey5.currentContext! //mybuttonKey == '솔'
                              .findRenderObject() as RenderBox;
                      Offset position = renderbox5.localToGlobal(Offset.zero);

                      RenderBox renderbox3 = mybuttonKey3.currentContext!
                          .findRenderObject() as RenderBox;
                      Offset position2 = renderbox3.localToGlobal(Offset.zero);

                      RenderBox renderbox4 = mybuttonKey4.currentContext!
                          .findRenderObject() as RenderBox;
                      Offset position3 = renderbox4.localToGlobal(Offset.zero);

                      RenderBox renderbox2 = mybuttonKey2.currentContext!
                          .findRenderObject() as RenderBox;
                      Offset position4 = renderbox2.localToGlobal(Offset.zero);

                      double x = position.dx;
                      double y = position.dy; //솔

                      double x2 = position2.dx;
                      double y2 = position2.dy; //미

                      double x3 = position3.dx;
                      double y3 = position3.dy; //파

                      double x4 = position4.dx;
                      double y4 = position4.dy; //레

                      //print(x);
                      //print(y);

                      await Future.delayed(Duration(milliseconds: 200));
                      pp(x, y, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x2, y2, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x2, y2, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x3, y3, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x4, y4, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x4, y4, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                    }),
              ),
              Flexible(
                child: ElevatedButton(
                    child: Text("학교종"),
                    onPressed: () async {
                      selectedSongName = '학교종';
                      RenderBox renderbox =
                          mybuttonKey6.currentContext! //mybuttonKey == '솔'
                              .findRenderObject() as RenderBox;
                      Offset position = renderbox.localToGlobal(Offset.zero);

                      RenderBox renderbox2 = mybuttonKey7.currentContext! //라
                          .findRenderObject() as RenderBox;
                      Offset position2 = renderbox2.localToGlobal(Offset.zero);

                      RenderBox renderbox3 = mybuttonKey3.currentContext! //미
                          .findRenderObject() as RenderBox;
                      Offset position3 = renderbox3.localToGlobal(Offset.zero);

                      double x = position.dx; //솔
                      double y = position.dy;

                      double x2 = position2.dx; //라
                      double y2 = position2.dy;

                      double x3 = position3.dx; //미
                      double y3 = position3.dy;

                      //print(x);
                      //print(y);

                      await Future.delayed(Duration(milliseconds: 200));
                      pp(x, y, answer); //솔
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x, y, answer); //솔
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x2, y2, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x2, y2, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x, y, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x, y, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                      pp(x3, y3, answer);
                      await Future.delayed(Duration(milliseconds: 500));
                    }),
              ),
            ],
          )
        ])
      ],
    ));
  }

  void checkAnswer(List<int> answer, String songName) {
    switch (songName) {
      case '나비야':
        checkSujinAnswer(answer);
        break;
      case '비행기':
        checkSeohyunAnswer(answer);
        break;
      case '학교종':
        checkJinsuAnswer(answer);
        break;
      default:
        print('Invalid song selection');
    }
  }

  void checkSujinAnswer(List answer) {
    List<int> ans = [5, 3, 3, 4, 2, 2];

    if (answer.length == 7) {
      if (listEquals(answer, ans)) {
        showMessage("잘하셨군요!");
        print("correct");
        answer.clear();
      } else {
        answer.clear();
        showMessage("다시 해보세요");
        print("Try again");
      }
    }
  }

  void checkSeohyunAnswer(List answer) {
    List<int> ans = [3, 2, 1, 2, 3, 3, 3];

    if (answer.length == 7) {
      if (listEquals(answer, ans)) {
        showMessage("잘하셨군요!");
        print("correct");
        answer.clear();
      } else {
        answer.clear();
        showMessage("다시 해보세요");
        print("Try again");
      }
    }
  }

  void checkJinsuAnswer(List answer) {
    List<int> ans = [5, 5, 6, 6, 5, 5, 3];

    if (answer.length == 7) {
      if (listEquals(answer, ans)) {
        showMessage("잘하셨군요!");
        print("correct");
        answer.clear();
      } else {
        answer.clear();
        showMessage("다시 해보세요");
        print("Try again");
      }
    }
  }

  // void checkAnswer(List answer) {
  //   List<int> ans = [1, 1, 2, 2, 3, 3, 2];

  //   if (answer.length == 7) {
  //     if (listEquals(answer, ans)) {
  //       showMessage("잘하셨군요!");
  //       print("correct");
  //       answer.clear();
  //     } else {
  //       answer.clear();
  //       showMessage("다시 해보세요");
  //       print("Try again");
  //     }
  //   }
  // }

  void showMessage(String m) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(m),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              )
            ],
          );
        });
  }
}

// class NoteCard extends StatelessWidget {
//   final String note;

//   NoteCard({required this.note, required Key key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 60, // 각 아이템의 너비 설정
//       margin: EdgeInsets.all(8), // 아이템 간 간격 설정
//       color: Colors.blue,
//       child: Column(
//         children: [Text(
//           note,
//           style: TextStyle(color: Colors.white),
//         ),
//         Text('Key: $key',
//         style: TextStyle(color: Colors.white),
//         )
//         ],
//     ));
//   }
// }
