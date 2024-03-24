import 'package:flutter/material.dart';
import 'package:mooner_interface/breathe.dart';
import 'package:mooner_interface/conversation.dart';
import 'package:mooner_interface/countnumber.dart';
import 'package:mooner_interface/exercise.dart';
import 'package:mooner_interface/healing.dart';
import 'package:mooner_interface/maze.dart';
import 'package:mooner_interface/piano.dart';
import 'package:mooner_interface/takepicture.dart';
import 'package:mooner_interface/coloring.dart';
import 'package:mooner_interface/walk.dart';
import 'molegame.dart';

class NewStage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new NewStageScreen());
  }
}

class NewStageScreen extends StatelessWidget {
  final List<String> buttonNames = [
    '문어잡기', '산책하기', '상처치료해주기',
    '근육이완법', '운동하기','심호흡하기',
    '숫자세기', '자장가','색칠하기',
    '주의 분산', '대화하기','나만의 스토리'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
        children: <Widget>[
          // 배경 이미지를 가진 Container
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage_test.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 버튼이 있는 GridView
          Center(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisCount: 3,
              ),
              padding: EdgeInsets.fromLTRB(3,90,3,20),
              itemCount: 11,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MoleGame()),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => walkGame()),
                      );
                    }
                    else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HealingGameApp()),
                      );
                    }
                    else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExerciseGameApp()),
                      );
                    }
                    else if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExerciseGameApp()),
                      );
                    }
                    else if (index == 5) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BreatheGameApp()),
                      );
                    }
                    else if (index == 6) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CountNumberGameApp()),
                      );
                    }
                    else if (index == 7) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PianoGameApp()),
                      );
                    }
                    else if (index == 8) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ColoringGame()),
                      );
                    }
                    else if (index == 9) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TakePictureGameApp()),
                      );
                    }
                    else if (index == 10) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConversationGameApp()),
                      );
                    } else {

                  
                      // 다른 버튼 클릭 시 실행할 액션
                      print('Button $index pressed');
                    }
                  },
                  child: Text(buttonNames[index]),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent, // AppBar 배경을 투명하게 설정
              elevation: 0, // 그림자 제거
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    // 설정 버튼 클릭 시 실행할 액션
                    print('Settings button pressed');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}