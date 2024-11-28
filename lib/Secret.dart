import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mooner_interface/breathe.dart';
import 'package:mooner_interface/coloring.dart';
import 'package:mooner_interface/conversation.dart';
import 'package:mooner_interface/countnumber.dart';
import 'package:mooner_interface/exercise.dart';
import 'package:mooner_interface/healing.dart';
import 'package:mooner_interface/moonerhit.dart';
import 'package:mooner_interface/musclerelease.dart';
import 'package:mooner_interface/piano.dart';
import 'package:mooner_interface/takepicture.dart';

void main() => runApp(SecretGameApp());

class SecretGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: SecretGameAppScreen());
  }
}

class SecretGameAppScreen extends StatefulWidget {
  @override
  _SecretGameAppScreenState createState() => _SecretGameAppScreenState();
}

class AudioManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static ValueNotifier<bool> isPlaying = ValueNotifier(true);

  static void toggleBackgroundSound(bool value) {
    if (value) {
      _audioPlayer.resume(); // Assume it's already loaded
      isPlaying.value = true;
    } else {
      _audioPlayer.pause();
      isPlaying.value = false;
    }
  }

  static void initialize() async {
    await _audioPlayer.setSourceAsset('audio/bgm_test.mp3');
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    if (isPlaying.value) _audioPlayer.resume();
  }
}

class _SecretGameAppScreenState extends State<SecretGameAppScreen> {
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
    AudioManager.initialize();
    isSwitched = AudioManager.isPlaying.value;
  }

  void showCustomDialog(BuildContext context, int index) {
    String title = 'Default Title';
    String description = 'Default description for the stage.';
    String scrollImage = 'assets/images/bottle.png';
    String octopusImage = 'assets/images/normal_mooner_x.png';
    Widget? nextPage;

    switch (index) {
      case 0:
        title = 'Stage1.산책하기';
        description =
            '숲이나 공원같이 나무가 가득한 곳을 걸을 때 기분이 좋아지는 걸 느껴본 적이 있나요? 이렇게 자연 속을 걸으면, 가만히 있을 때보다 스트레스가 줄어들고, 몸이 안정되는 기분을 느낄 수 있어요. 친구와 싸워서, 엄마한테 혼나서 기분이 좋지 않을 때, 집 주변에 나무가 가득한 공원에 가서 생각을 비우고 걸어보면, 이전보다 기분이 나아지는 경험을 할 수 있을 거예요.';
        nextPage = MoleGame();
        break;
      case 1:
        title = 'Stage2.상처치료하기';
        description =
            '불이야! 불이야! 이런 얘기를 들으면 어떤 생각이 드나요? 불난 곳에 물을 뿌려주고, 소방관 아저씨한테 연락해야 한다는 생각이 들죠. 우리는 이렇게 누군가 힘든 상황에 있으면 도와주고 싶어져요. 여러분이 힘들 때는 어떨까요? 감정적으로 힘들 때는 감정을 제대로 마주하기도 힘들고, 혼자 생각하고 결정하는 것에 어려움을 느낄 수 있어요. 이럴 때 주변 사람들에게 도와달라고 말할 수 있는 능력이 꼭 필요해요. 여러분의 상황을 나누게 되면, 더 큰 문제나 어려움을 겪지 않을 수 있도록 함께 해결해 나갈 수 있도록 도와줄거니까요. 여러분은 혼자가 아니라 늘 주변 어른, 친구들의 도움을 받을 수 있다는 사실! 꼭 기억하고 힘들 때는 주변에 도와달라고 해봐요.';
        nextPage = HealingGameApp();
        break;
      case 3:
        title = 'Stage3.근육이완법';
        description =
            '점진적 근육 이완법은 신체의 긴장이완에 우선적으로 중점을 둔 기법이다. 근육 섬유의 이완은 긴장과 생리적으로 정반대되는 것이기 때문에 지나치게 긴장하거나 불안한 사람에게 논리적인 치료법이 된다.';
        nextPage = MusclereleaseGameApp();
        break;
      case 4:
        title = 'Stage4.운동하기';
        description =
            '운동을 할 때 분비되는 호르몬인 엔도르핀은 스트레스를 완화시켜 마음을 진정시켜 주는 효과를 준다는 사실 알고 계셨나요? 운동을 하면서 자신의 몸 상태와 동작에 집중할 수 있어 생각을 전환시키는 데 도움을 줘요. 예를 들어, 걷기, 달리기 등 유산소 운동을 통해서 혈액순환을 원활하게 해 불안과 분노를 감소시키는 것은 어떨까요?';
        nextPage = ExerciseGameApp();
        break;
      case 5:
        title = 'Stage5.심호흡';
        description =
            '화날 때는 몸에서 다양한 반응이 나타나요. 얼굴이 토마토처럼 빨개지기도 하고, 숨이 거칠어지기도 하며, 땀이 나기도 하고, 심장이 빨리 뛰면서 손이 떨리기도 하죠. 이럴 때는 후~하~후~하~하면서 몸을 진정시켜 봐요. 4초 동안 천천히 들이마시고, 6초 동안 내뱉고, 3초 동안 쉬는 심호흡을 반복하다 보면, 몸도 차분해지고, 기분이 훨씬 나아진 자신을 볼 수 있을 거예요!';
        nextPage = BreatheGameApp();
        break;
      case 6:
        title = 'Stage6.숫자세기';
        description =
            '하나~ 둘~ 셋~. 이렇게 천천히 숫자를 세는 동안 어떤 생각이 드시나요? 숫자에만 집중하고 있다는 느낌을 받을 수 있을 거에요. 특히, 숫자를 세면서 발생하는 시간이 분노의 강도를 줄일 수 있어요. 분노를 통해 일어난 혼돈과 불안을 질서와 규칙으로 바꿀 수 있어 도움을 주기도 해요. 다 같이 화가 날 때 숫자를 세봐요! 아 중요한 건 숫자를 천천히 세야한다는 점 잊지 말아주세요.';
        nextPage = CountNumberGameApp();
        break;
      case 7:
        title = 'Stage7.화난 너무너에게 자장가를';
        description =
            '화가 나고, 감정을 주체하기 힘들어질 때는 잠시 음악의 세계로 떠나볼까요? 피아노, 바이올린, 칼림바, 리코더 같이 주변에서 자주 만날 수 있는 악기들로 좋아하는 노래를 연주하다보면 전보다 차분해진 스스로를 볼 수 있을 거예요. 악기와 음악에 자기 감정을 실어서 멀리 보내준다고 생각해봐요.';
        nextPage = PianoGameApp();
        break;
      case 8:
        title = 'Stage8.컬러링';
        description =
            '어릴 때 스케치북이나 벽에 크레파스로 이리저리 원하는 색을 색칠해본 적 있지 않나요? 자기가 표현하고 싶은 대로, 제시된 색칠 도안을 꽉 채워나가는 재미가 있는 컬러링은 여러분의 감정을 표현하는 데에도 도움이 될 거예요. 색을 칠하는 동안 화, 우울함, 불안함은 덜 느껴지고, 즐겁게 색칠하는 것에 몰입해서 컬러링의 순간에 집중할 수 있게 해요. 이렇게 화가 나고 정리가 되지 않은 감정을 마주할 때는 알록달록한 색의 세계로 빠져보는 건 어떨까요?';
        nextPage= ColoringGame();
        break;
      case 9:
        title = 'Stage9.주의분산';
        description =
            '화가 났을 때 여기 저기 둘러보거나, 기분 좋았던 일을 생각해봐요. 아니면 좋아하는 일을 하며 잠시 분노를 갈아앉히는 시간을 가져봐요. 이렇게 주의를 분산시키면, 사고의 흐름을 바꿀 수 있고 이성적으로 문제를 해결할 수 있어요. 그리고 좋아하는 일을 하는 등 다른 주제에 집중하게 돼면 분노에 대한 관심이 줄어드는 효과를 볼 수 있어요.';
        nextPage=TakePictureGameApp();
        break;
      // Add more cases for other stages
      case 10:
        title = 'Stage10.대화하기';
        description =
            '나 전달법은 효과적으로 다른 사람에게 자신의 감정과 생각을 전달할 수 있는 표현방법으로, 상황을 일방적으로 비난하거나 공격하지 않고 자신의 감정을 표현하는 것에 초점을 두는 대화방식이에요. 적절한 정서의 표현은 문제 상황을 해결하는데, 도움을 줄 뿐만 아니라 자기 인식을 높여 정서를 조절할 수 있게 도와줘요.';
        nextPage=ConversationGameApp();
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/scroll_background.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(description),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(), // Close dialog
                            icon: Image.asset(
                              scrollImage,
                              width: 40,
                              height: 40,
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog first
                              if (nextPage != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => nextPage!),
                                );
                              }
                            },
                              // Handle octopus button press
                            icon: Image.asset(
                              octopusImage,
                              width: 40,
                              height: 40,
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_secret.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // GridView with Image Buttons
          Center(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisCount: 3,
              ),
              padding: EdgeInsets.fromLTRB(3, 90, 3, 20),
              itemCount: 11, // Assuming there are 11 stages
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => showCustomDialog(context, index),
                  child: Image.asset('assets/images/bottle.png'), // Replace with your single button image
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent, // AppBar transparent
              elevation: 0, // No shadow
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    // Open Settings Dialog
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
                                      value: value,
                                      borderRadius: 30.0,
                                      padding: 8.0,
                                      showOnOff: true,
                                      onToggle: (val) {
                                        setState(() {
                                          AudioManager.toggleBackgroundSound(val);
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
