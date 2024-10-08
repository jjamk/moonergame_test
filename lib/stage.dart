import 'package:flutter/material.dart';
import 'package:mooner_interface/Secret.dart';
import 'package:mooner_interface/SoundQuiz.dart';
import 'package:mooner_interface/breathe.dart';
import 'package:mooner_interface/conversation.dart';
import 'package:mooner_interface/countnumber.dart';
import 'package:mooner_interface/exercise.dart';
import 'package:mooner_interface/healing.dart';
import 'package:mooner_interface/piano.dart';
import 'package:mooner_interface/takepicture.dart';
import 'package:mooner_interface/musclerelease.dart';
import 'package:mooner_interface/walk.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'SoundQuiz.dart';
import 'moonerhit.dart';

class NewStage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: new NewStageScreen());
  }
}

class NewStageScreen extends StatefulWidget {
  @override
  _NewStageScreenState createState() => _NewStageScreenState();
}

// 배경음을 관리하는 클래스
// class AudioManager {
//   static final AudioPlayer _audioPlayer = AudioPlayer();
//   static ValueNotifier<bool> isPlaying = ValueNotifier(true);
//   static bool _initialized = false;

//   static void toggleBackgroundSound(bool value) {
//     if (value) {
//       _audioPlayer.resume(); // 이전에 이미 load되어 있다고 가정
//       isPlaying.value = true;
//     } else {
//       _audioPlayer.pause();
//       isPlaying.value = false;
//     }
//     print(isPlaying);
//   }

//   static void initialize() async {
//     if (_initialized) return;
//     await _audioPlayer.setSourceAsset('audio/bgm_test.mp3');
//     _audioPlayer.setReleaseMode(ReleaseMode.loop);
//     if (isPlaying.value) _audioPlayer.resume();
//     _initialized = true;
//   }
// }

class _NewStageScreenState extends State<NewStageScreen> {
  bool isSwitched = true;
  final List<String> buttonNames = [
    '문어잡기',
    '산책하기',
    '상처치료해주기',
    '근육이완법',
    '운동하기',
    '심호흡하기',
    '숫자세기',
    '자장가',
    '소리듣기',
    '주의 분산',
    '대화하기',
    '나만의 스토리'
  ];

  @override
  void initState() {
    super.initState();
    //AudioManager.initialize(); // 앱 시작 시 배경음 재생 초기화
    isSwitched = AudioManager.isPlaying.value;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    isSwitched = AudioManager.isPlaying.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 배경 이미지를 가진 Container
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
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
              padding: EdgeInsets.fromLTRB(3, 90, 3, 20),
              itemCount: buttonNames.length,
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
                        MaterialPageRoute(builder: (context) => WalkGameapp()),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HealingGameApp()),
                      );
                    } else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MusclereleaseGameApp()),
                      );
                    } else if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseGameApp()),
                      );
                    } else if (index == 5) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BreatheGameApp()),
                      );
                    } else if (index == 6) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CountNumberGameApp()),
                      );
                    } else if (index == 7) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PianoGameApp()),
                      );
                    } else if (index == 8) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Soundquiz()),
                      );
                    } else if (index == 9) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TakePictureGameApp()),
                      );
                    } else if (index == 10) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConversationGameApp()),
                      );
                    } else if (index == 11) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecretGameApp()),
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('음악 설정'),
                          content: SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('배경음'),
                                ValueListenableBuilder(
                                  valueListenable: AudioManager.isPlaying,
                                  builder: (context, value, child) {
                                    return FlutterSwitch(
                                      width: 100.0,
                                      height: 55.0,
                                      valueFontSize: 25.0,
                                      toggleSize: 45.0,
                                      value: isSwitched,
                                      borderRadius: 30.0,
                                      padding: 8.0,
                                      showOnOff: true,
                                      onToggle: (val) {
                                        setState(() {
                                          isSwitched = val;
                                          AudioManager.toggleBackgroundSound(val);
                                          print(val);
                                          print(isSwitched);
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
