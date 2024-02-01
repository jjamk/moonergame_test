
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
  void pp (double x, double y, List<int> ans) async {
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
          Column(children: [
        Flexible(
            flex: 9,
            child: Placeholder(
              fallbackHeight: 700,
              fallbackWidth: 500,
            )),
        Flexible(
          flex: 4,
          child: ElevatedButton(
            key: mybuttonKey,
            onPressed: (){
              print("button is pressed");
              playSound("C");
              answer.add(1);
              print(answer);
              checkAnswer(answer);
              
              
            },
            child:Text("도") ,)
          // child: ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: notes.length,
          //   itemBuilder: (context, index) {
          //     return NoteCard(
          //       note: notes[index],
          //       key: _buttonKey1,
          //     );
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            //children: [
              
              // buildKey(0),
              // buildKey(1),
              // buildKey(2),
              // buildKey(3),
              // buildKey(4),
              // buildKey(5),
              // buildKey(6),
              // buildKey(7),
              // C
            //],
          ),
          Flexible(
          flex: 4,
          child: ElevatedButton(
            key: mybuttonKey2,
            onPressed: (){
              print("button2 is pressed");
              playSound("G");
              answer.add(2);
              checkAnswer(answer);
              
            },
            child:Text("솔") ,)),
          Flexible(
          flex: 4,
          child: ElevatedButton(
            key: mybuttonKey3,
            onPressed: (){
              print("button3 is pressed");
              playSound("A");
              answer.add(3);
              checkAnswer(answer);
            },
            child:Text("라") ,)),
        Flexible(
          child: ElevatedButton(
          child: Text("들어볼래!"),
          onPressed: () async {
                    RenderBox renderbox = mybuttonKey.currentContext!.findRenderObject() as RenderBox;
                    Offset position = renderbox.localToGlobal(Offset.zero);

                    RenderBox renderbox2 = mybuttonKey2.currentContext!.findRenderObject() as RenderBox;
                    Offset position2 = renderbox2.localToGlobal(Offset.zero);

                    RenderBox renderbox3 = mybuttonKey3.currentContext!.findRenderObject() as RenderBox;
                    Offset position3 = renderbox3.localToGlobal(Offset.zero);

                    double x = position.dx;
                    double y = position.dy;

                    double x2 = position2.dx;
                    double y2 = position2.dy;

                    double x3 = position3.dx;
                    double y3 = position3.dy;

                    //print(x);
                    //print(y);

                    await Future.delayed(Duration(milliseconds: 200)); 
                    pp(x,y,answer);
                    await Future.delayed(Duration(milliseconds: 500)); 
                    pp(x,y,answer);
                    await Future.delayed(Duration(milliseconds: 500)); 
                    pp(x2,y2,answer);
                    await Future.delayed(Duration(milliseconds: 500)); 
                    pp(x2,y2,answer);
                    await Future.delayed(Duration(milliseconds: 500));
                    pp(x3,y3,answer);
                    await Future.delayed(Duration(milliseconds: 500));
                    pp(x3,y3,answer);
                    await Future.delayed(Duration(milliseconds: 500));  
                    pp(x2,y2,answer);
                    await Future.delayed(Duration(milliseconds: 500));  
                    

                    
          }),
        ),
        Flexible(
            flex: 2,
            child: Placeholder(
              fallbackHeight: 700,
              fallbackWidth: 500,
            )),
      ])],
      ));
  }
  
  void checkAnswer(List answer) {
    List<int> ans=[1,1,2,2,3,3,2];

    if (answer.length == 7) {
      if (listEquals(answer, ans)) {
        showMessage("잘하셨군요!");
        print("correct");
        answer.clear();
      }
      else {
        answer.clear();
        showMessage("다시 해보세요");
        print("Try again");
      }
    }
  }
  
  
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
                child: Text('확인'),)
            ],
          );
      } 
        );
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