import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(Soundquiz());

class Soundquiz extends StatelessWidget {
  const Soundquiz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: SoundquizApp(),
    );
  }
}

class SoundquizApp extends StatefulWidget {
  const SoundquizApp({super.key});

  @override
  State<SoundquizApp> createState() => _SoundquizAppState();
}

class _SoundquizAppState extends State<SoundquizApp> {
  double _progress = 1.0;
  bool isDialogueActive = true;
  int dialogueIndex = 0; // 현재 대화 인덱스

  // 대화 스크립트 정의 (여기서는 예시로 간단한 대화만 추가)
  List<String> dialogues = [
    "어부\n     화난 문어가 숲을 돌고 있어~",
    "어부\n     주변에 어떤 소리가 들리는지 \n     잘 듣고 알려주자!\n     ",
    "어부\n     10초 안에 3개의 소리를 찾아줘!",
  ];

  @override
  void initState() {
    super.initState();
  }

  void nextDialogue() {
    if (!mounted) return;
    setState(() {
      dialogueIndex++;
      if (dialogueIndex >= dialogues.length) {
        isDialogueActive = false; // 대화 종료
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
              child: SvgPicture.asset(
                'assets/images/stage_background.svg',
                width: 150,
                height: 150,
              ),
            ),
            Positioned(
              left: 36,
              top: 65,
              child: Text(
                '#stage 8',
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
                      child: SvgPicture.asset(
                        'assets/images/star.svg', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      left: 105,
                      top: -40, // 중앙 별 이미지의 위치
                      child: SvgPicture.asset(
                        'assets/images/star.svg', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Positioned(
                      right: -45,
                      top: -40, // 오른쪽 끝 별 이미지의 위치
                      child: SvgPicture.asset(
                        'assets/images/star.svg', // 별 이미지 경로
                        width: 110,
                        height: 110,
                      ),
                    )
                    ]
                  )
                )
              )
            ,Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/normal_mooner_x.png',
                    width: 300,
                    height: 270,
                    fit: BoxFit.contain,
                  ),
                  if (!isDialogueActive) // 대화가 끝난 후 버튼 표시
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text('새 소리'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('나뭇잎 부딪히는 소리'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('나뭇가지가 떨어지는 소리'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text('바람 소리'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('매미 소리'),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (isDialogueActive) // 대화 창 표시
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: nextDialogue,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/fisher.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ), 
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(50),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/dialog_background.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Text(
                              dialogues[dialogueIndex],
                              style: TextStyle(fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
