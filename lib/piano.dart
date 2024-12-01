import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(PianoGameApp());

class PianoGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: PianoGameScreen(),
    );
  }
}

class PianoGameScreen extends StatefulWidget {
  @override
  _PianoGameScreenState createState() => _PianoGameScreenState();
}

class _PianoGameScreenState extends State<PianoGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 배경화면
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 중앙에 이미지와 텍스트 배치
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PianoGamesScreen()), // PianoGamesScreen으로의 이동
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/result_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 400, // 이미지의 너비 설정
                    height: 300, // 이미지의 높이 설정
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Spacer(),
                        SizedBox(height: 90), // 위쪽 공간을 비워 텍스트를 아래로 이동
                        const Text(
                          'STAGE 7 \n문찌의 플레이리스트',
                          style: TextStyle(
                            fontSize: 24,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10), // 텍스트 간의 간격을 추가
                        const Text(
                          '문찌가 진정할 수 있게 \n 자장가를 들려주자',
                          style: TextStyle(
                            fontSize: 18,
                            
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(), // 하단 공간을 비워서 여백을 조절
                      ],
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

class PianoGamesScreen extends StatefulWidget {
  @override
  _PianoGamesScreenState createState() => _PianoGamesScreenState();
}

class _PianoGamesScreenState extends State<PianoGamesScreen> {
  // 문장 리스트로 관리
  List<String> dialogTexts = [
    "화를 진정시킬 때 다른 것보다도 \n 음악을 들으면 또 생각보다 금방 \n 차분해지기도 하지!",
    "지금부터 자장가 3개를 문찌한테 \n 연주해줄거야!",
    "이제 1번부터 눌러볼까?"
  ];

  int currentDialogIndex = 0; // 현재 보여지는 문장의 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 상단바를 배경 뒤로 확장
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent, // 상단바 배경 투명
        elevation: 0, // 상단바 그림자 없애기
        title: Row(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset(
                  'assets/images/stage_background.png', // 상단바 왼쪽 이미지 경로
                  height: 80, // 이미지 높이 조절
                ),
                Positioned(
                  left: 35, // 이미지 내에서 텍스트 위치 조정
                  child: Text(
                    'STAGE 7',
                    style: TextStyle(
                      fontSize: 16, // 텍스트 크기
                      color: Colors.black, // 텍스트 색상 (배경 이미지와 대비되게 설정)
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10), // 이미지와 텍스트 간의 간격
            Text(
              '문찌의 플레이리스트',
              style: TextStyle(
                fontSize: 18, // 텍스트 크기
                color: Colors.black, // 텍스트 색상
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_stage.png'), // 배경 이미지 경로
            fit: BoxFit.cover,  // 이미지를 화면 크기에 맞게 조정
          ),
        ),
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             SizedBox(
                width: 300, // 이미지의 가로 크기
                height: 200, // 이미지의 세로 크기
                child: Image.asset('assets/images/normal_mooner_x.png'),
            ),
            SizedBox(height: 20), // 버튼과 텍스트 간의 간격
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGameButton(1, firstGame),
                SizedBox(width: 20), // 버튼 간의 간격
                _buildGameButton(2, secondGame),
                SizedBox(width: 20), // 버튼 간의 간격
                _buildGameButton(3, thirdGame),
              ]),
              SizedBox(height: 20), // 버튼과 이미지 간의 간격
            Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,  // Row 크기를 내용에 맞춤
                      children: [
                        SvgPicture.asset(
                          'assets/images/fisherman_front.svg',
                          width: 10,  // Fisher 이미지의 너비
                          height: 110,  // Fisher 이미지의 높이
                        ),
                        Image.asset(
                          'assets/images/dialog_background.png',
                          width: 280,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
            
                    // 텍스트 오버레이
              Positioned(
                left: 145,
                top: 28,
                child: GestureDetector(
                  onTap: () {
                    // 클릭 시 다음 문장으로 변경
                    if (currentDialogIndex < dialogTexts.length - 1) {
                      setState(() {
                        currentDialogIndex++;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      dialogTexts[currentDialogIndex],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                ),
          ),
          ],
      ),
          ],
      ),
    ),
      ),
    );
  }

  GestureDetector _buildGameButton(int number, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, // 버튼의 너비 설정
        height: 80, // 버튼의 높이 설정
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/note.png'), // note 이미지
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter, // 텍스트를 아래쪽에 정렬
          child: Text(
            '$number',
            style: TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: 24, // 텍스트 크기
             
            ),
          ),
        ),
      ),
    );
  }

  void firstGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstGameScreen()),
    );
  }

  void secondGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondGameScreen()),
    );
  }

  void thirdGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThirdGameScreen()),
    );
  }
}

// 첫 번째 게임 화면
class FirstGameScreen extends StatefulWidget {
  @override
  _FirstGameScreenState createState() => _FirstGameScreenState();
}
class _FirstGameScreenState extends State<FirstGameScreen> {
  final List<List<String>> melodies = [
    ['도', '도', '솔', '솔', '라', '라', '솔'],
    ['파', '파', '미', '미', '레', '레', '도'],
    ['솔', '솔', '파', '파', '미', '미', '레'],
    ['솔', '솔', '파', '파', '미', '미', '레'],
    ['도', '도', '솔', '솔', '라', '라', '솔'],
    ['파', '파', '미', '미', '레', '레', '도'],
  ];

  int currentMelodyIndex = 0;
  List<String> userInput = [];
  List<String> buttonImages = List.filled(8, 'assets/images/orangenote.png');
  int currentDialogIndex = 0;
  bool gameStarted = false; // 게임 시작 여부

  // Dialog 텍스트 목록
  final List<String> dialogTexts = [
    "이건 반짝 반짝 작은별이야!",
    "들리는 음과 빛나는 음표를 \n 보고 따라 클릭해줘",
  ];

  @override
  void initState() {
    super.initState();
    playMelody(); // 첫 멜로디 재생
  }

  void playMelody() {
    if (!gameStarted) return;
    List<String> melody = melodies[currentMelodyIndex];
    for (int i = 0; i < melody.length; i++) {
      Future.delayed(Duration(seconds: i), () {
        int noteIndex = getNoteIndex(melody[i]);
        _playNoteAndShowFeedback(noteIndex);
      });
    }
  }

  int getNoteIndex(String note) {
    switch (note) {
      case '도':
        return 0;
      case '레':
        return 1;
      case '미':
        return 2;
      case '파':
        return 3;
      case '솔':
        return 4;
      case '라':
        return 5;
      case '시':
        return 6;
      default:
        return 0;
    }
  }

  void startGame(){
    setState(() {
      gameStarted = true;
    });
    playMelody();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 상단바를 배경 뒤로 확장
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent, // 상단바 배경 투명
        elevation: 0, // 상단바 그림자 없애기
        title: Row(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset(
                  'assets/images/stage_background.png', // 상단바 왼쪽 이미지 경로
                  height: 80, // 이미지 높이 조절
                ),
                Positioned(
                  left: 35, // 이미지 내에서 텍스트 위치 조정
                  child: Text(
                    'STAGE 7',
                    style: TextStyle(
                      fontSize: 16, // 텍스트 크기
                      color: Colors.black, // 텍스트 색상 (배경 이미지와 대비되게 설정)
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10), // 이미지와 텍스트 간의 간격
            Text(
              '문찌의 플레이리스트',
              style: TextStyle(
                fontSize: 18, // 텍스트 크기
                color: Colors.black, // 텍스트 색상
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_stage.png'), // 배경 이미지 설정
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dialog 텍스트 표시
            Positioned(
                    top: 20,  // 문어 이미지의 Y 위치 조정
                    left: 0,  // 문어 이미지의 X 위치 조정
                    child: Image.asset(
                      'assets/images/normal_mooner_x.png', // 문어 이미지
                      width: 200,  // 문어 이미지 크기
                      height: 300,
                    ),
                  ),
            // 첫 번째 Row (1, 2, 3, 4 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton('도', 0),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('레', 1),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('미', 2),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('파', 3),
              ],
            ),
            SizedBox(height: 10), // 두 Row 사이의 간격
            // 두 번째 Row (5, 6, 7, 8 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton('솔', 4),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('라', 5),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('시', 6),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('도', 7),
              ],
            ),
            SizedBox(height: 50),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 배경 이미지
                Image.asset(
                  'assets/images/dialog_background.png',
                  width: 320,
                  fit: BoxFit.cover,
                ),
                
                // Fisherman 이미지
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/images/fisherman_front.svg', // 추가된 이미지
                      width: 10,
                      height: 110,
                    ),
                  ],
                ),
                // 텍스트 위젯
                Positioned(
                  top: 45,  // 텍스트의 Y 위치 조정
                  left: 100,  // 텍스트의 X 위치 조정
                  child: GestureDetector(
                    onTap: () {
                      if (currentDialogIndex < dialogTexts.length - 1) {
                        setState(() {
                          currentDialogIndex++;
                        });
                      } else {
                        startGame(); // 마지막 텍스트 후 게임 시작
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        dialogTexts[currentDialogIndex],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
  
Widget _buildImageButton(String buttonText, int noteIndex) {
    return GestureDetector(
      onTap: () {
        userTapped(buttonText); // 사용자가 클릭한 음을 처리
        _playNoteAndShowFeedback(noteIndex); // 음을 재생하고 피드백을 표시
      },
      child: Container(
        width: 60, // 버튼의 너비 설정
        height: 50, // 버튼의 높이 설정
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(buttonImages[noteIndex]), // 현재 이미지
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: 16, // 텍스트 크기
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _playNoteAndShowFeedback(int noteIndex) {
    // 각 음의 파일 경로를 설정합니다.
    List<String> notePaths = [
      'assets/audio/C.mp3',
      'assets/audio/D.mp3',
      'assets/audio/E.mp3',
      'assets/audio/F.mp3',
      'assets/audio/G.mp3',
      'assets/audio/A.mp3',
      'assets/audio/B.mp3',
      'assets/audio/CC.mp3',
    ];

    // 음을 재생합니다.
    final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
    audioPlayer.open(Audio(notePaths[noteIndex]));

    // 버튼 이미지 변경
    setState(() {
      buttonImages[noteIndex] = 'assets/images/note.png'; // note 이미지로 변경
    });

    // 1초 후에 원래 이미지로 복구
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        buttonImages[noteIndex] = 'assets/images/orangenote.png'; // orangenote 이미지로 복구
      });
    });
  }

  void userTapped(String note) {
    userInput.add(note); // 사용자가 입력한 음 추가
    checkUserInput(); // 입력 확인
  }

  bool showEndText = false; // 텍스트 표시 여부 상태 변수 추가

    // 게임 완료 후 텍스트 처리 함수
    void showSuccessText() {
      setState(() {
        showEndText = true; // 텍스트 표시
      });
    }

    void checkUserInput() {
    if (userInput.length > melodies[currentMelodyIndex].length) {
      // 사용자의 입력이 멜로디 길이를 초과하면 다시 초기화
      userInput = [];
      return;
    }

    for (int i = 0; i < userInput.length; i++) {
      if (userInput[i] != melodies[currentMelodyIndex][i]) {
        // 잘못된 입력일 경우
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('어부'),
              content: Text('다시 한 번 쳐줘!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    userInput = []; // 입력 초기화
                  },
                  child: Text('알겠어!'),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    // 모든 입력이 맞는 경우
    if (userInput.length == melodies[currentMelodyIndex].length) {
      if (currentMelodyIndex < melodies.length - 1) {
        // 다음 멜로디로 이동
        setState(() {
          currentMelodyIndex++;
          userInput = [];
        });

        // 1초 후에 다음 마디 시작
        Future.delayed(Duration(seconds: 1), () {
          playMelody(); // 다음 마디 재생
        });

      } else {
        // 모든 멜로디 성공
        // 모든 멜로디 성공
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('어부'),
          content: Text('멋진연주였어! \n문찌가 조금 진정했네! \n다음으로 가볼까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PianoGamesScreen()), // 게임 화면으로 이동
                );
              },
              child: Text('좋아!'),
            ),
          ],
        );
      },
    );
  }
      }
      }
    }



// 두 번째 게임 화면
class SecondGameScreen extends StatefulWidget {
  @override
  _SecondGameScreenState createState() => _SecondGameScreenState();
}

class _SecondGameScreenState extends State<SecondGameScreen> {
final List<List<String>> melodies = [
    ['미', '미', '솔', '미', '미', '솔', '미', '미', '솔', '미', '미', '솔'],
    ['미', '솔', '도', '시', '라', '라', '솔', '미', '솔', '도', '시'],
    ['라', '라', '솔', '레', '미', '파', '레', '레', '미', '파'],
    ['레', '파', '시', '라', '솔', '시', '도'],
    ['레', '파', '시', '라', '솔', '시', '도'],
    ['도', '도', '도', '라', '파', '솔'],
    ['미', '도', '파', '솔', '라', '솔'],
    ['도', '도', '도', '라', '파', '솔'],
    ['미', '도', '파', '미', '레', '도'],
  ];

  int currentMelodyIndex = 0;
  List<String> userInput = [];
  List<String> buttonImages = List.filled(8, 'assets/images/orangenote.png');

  @override
  void initState() {
    super.initState();
    playMelody(); // 첫 멜로디 재생
  }

  void playMelody() {
    List<String> melody = melodies[currentMelodyIndex];
    for (int i = 0; i < melody.length; i++) {
      Future.delayed(Duration(seconds: i), () {
        int noteIndex = getNoteIndex(melody[i]);
        _playNoteAndShowFeedback(noteIndex);
      });
    }
  }

  int getNoteIndex(String note) {
    switch (note) {
      case '도':
        return 0;
      case '레':
        return 1;
      case '미':
        return 2;
      case '파':
        return 3;
      case '솔':
        return 4;
      case '라':
        return 5;
      case '시':
        return 6;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('두 번째 게임'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 첫 번째 Row (1, 2, 3, 4 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton('도', 0),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('레', 1),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('미', 2),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('파', 3),
              ],
            ),
            SizedBox(height: 10), // 두 Row 사이의 간격
            // 두 번째 Row (5, 6, 7, 8 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton('솔', 4),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('라', 5),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('시', 6),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('도', 7),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
Widget _buildImageButton(String buttonText, int noteIndex) {
    return GestureDetector(
      onTap: () {
        userTapped(buttonText); // 사용자가 클릭한 음을 처리
        _playNoteAndShowFeedback(noteIndex); // 음을 재생하고 피드백을 표시
      },
      child: Container(
        width: 60, // 버튼의 너비 설정
        height: 50, // 버튼의 높이 설정
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(buttonImages[noteIndex]), // 현재 이미지
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: 16, // 텍스트 크기
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _playNoteAndShowFeedback(int noteIndex) {
    // 각 음의 파일 경로를 설정합니다.
    List<String> notePaths = [
      'assets/audio/C.mp3',
      'assets/audio/D.mp3',
      'assets/audio/E.mp3',
      'assets/audio/F.mp3',
      'assets/audio/G.mp3',
      'assets/audio/A.mp3',
      'assets/audio/B.mp3',
      'assets/audio/CC.mp3',
    ];

    // 음을 재생합니다.
    final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
    audioPlayer.open(Audio(notePaths[noteIndex]));

    // 버튼 이미지 변경
    setState(() {
      buttonImages[noteIndex] = 'assets/images/note.png'; // note 이미지로 변경
    });

    // 1초 후에 원래 이미지로 복구
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        buttonImages[noteIndex] = 'assets/images/orangenote.png'; // orangenote 이미지로 복구
      });
    });
  }

  void userTapped(String note) {
    userInput.add(note); // 사용자가 입력한 음 추가
    checkUserInput(); // 입력 확인
  }

    void checkUserInput() {
    if (userInput.length > melodies[currentMelodyIndex].length) {
      // 사용자의 입력이 멜로디 길이를 초과하면 다시 초기화
      userInput = [];
      return;
    }

    for (int i = 0; i < userInput.length; i++) {
      if (userInput[i] != melodies[currentMelodyIndex][i]) {
        // 잘못된 입력일 경우
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('오답입니다!'),
              content: Text('멜로디를 다시 시도해 주세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    userInput = []; // 입력 초기화
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    // 모든 입력이 맞는 경우
    if (userInput.length == melodies[currentMelodyIndex].length) {
      if (currentMelodyIndex < melodies.length - 1) {
        // 다음 멜로디로 이동
        setState(() {
          currentMelodyIndex++;
          userInput = [];
        });

        // 1초 후에 다음 마디 시작
        Future.delayed(Duration(seconds: 1), () {
          playMelody(); // 다음 마디 재생
        });

      } else {
        // 모든 멜로디 성공
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: Text('모든 멜로디 성공!'),
        //       content: Text('축하합니다! 모든 멜로디를 성공적으로 재생했습니다.'),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //             Navigator.pop(context); // 메인 화면으로 이동
        //           },
        //           child: Text('확인'),
        //         ),
        //       ],
        //     );
        //   },
        // );
        Positioned(
              top: 125,
              left: 60,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstGameScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "멋진연주였어! \n 문찌가 조금 진정했네! \n 다음으로 가볼까?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
      }
    }
    }
}

// 세 번째 게임 화면
class ThirdGameScreen extends StatefulWidget {
  @override
  _ThirdGameScreenState createState() => _ThirdGameScreenState();
}

class _ThirdGameScreenState extends State<ThirdGameScreen> {
  final List<List<String>> melodies = [
    ['미', '파', '미', '레', '도', '레', '도'],
    ['도', '파', '파', '파', '솔', '라', '솔'],
    ['레', '도', '레', '레', '도', '레', '파'],
    ['미', '미', '미', '파', '미', '파', '솔'],
    ['라', '라', '라', '라', '솔', '라', '도'],
    ['솔', '솔', '솔', '솔', '파', '솔', '도'],
    ['파', '솔', '파', '미', '파', '솔', '레'],
    ['미', '파', '미', '레', '도', '레', '도'],
  ];


  int currentMelodyIndex = 0;
  List<String> userInput = [];
  List<String> buttonImages = List.filled(8, 'assets/images/orangenote.png');

  @override
  void initState() {
    super.initState();
    playMelody(); // 첫 멜로디 재생
  }

  void playMelody() {
    List<String> melody = melodies[currentMelodyIndex];
    for (int i = 0; i < melody.length; i++) {
      Future.delayed(Duration(seconds: i), () {
        int noteIndex = getNoteIndex(melody[i]);
        _playNoteAndShowFeedback(noteIndex);
      });
    }
  }

  int getNoteIndex(String note) {
    switch (note) {
      case '도':
        return 0;
      case '레':
        return 1;
      case '미':
        return 2;
      case '파':
        return 3;
      case '솔':
        return 4;
      case '라':
        return 5;
      case '시':
        return 6;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('두 번째 게임'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 첫 번째 Row (1, 2, 3, 4 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton('도', 0),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('레', 1),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('미', 2),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('파', 3),
              ],
            ),
            SizedBox(height: 10), // 두 Row 사이의 간격
            // 두 번째 Row (5, 6, 7, 8 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton('솔', 4),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('라', 5),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('시', 6),
                SizedBox(width: 10), // 버튼 간의 간격
                _buildImageButton('도', 7),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
Widget _buildImageButton(String buttonText, int noteIndex) {
    return GestureDetector(
      onTap: () {
        userTapped(buttonText); // 사용자가 클릭한 음을 처리
        _playNoteAndShowFeedback(noteIndex); // 음을 재생하고 피드백을 표시
      },
      child: Container(
        width: 60, // 버튼의 너비 설정
        height: 50, // 버튼의 높이 설정
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(buttonImages[noteIndex]), // 현재 이미지
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: 16, // 텍스트 크기
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _playNoteAndShowFeedback(int noteIndex) {
    // 각 음의 파일 경로를 설정합니다.
    List<String> notePaths = [
      'assets/audio/C.mp3',
      'assets/audio/D.mp3',
      'assets/audio/E.mp3',
      'assets/audio/F.mp3',
      'assets/audio/G.mp3',
      'assets/audio/A.mp3',
      'assets/audio/B.mp3',
      'assets/audio/CC.mp3',
    ];

    // 음을 재생합니다.
    final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
    audioPlayer.open(Audio(notePaths[noteIndex]));

    // 버튼 이미지 변경
    setState(() {
      buttonImages[noteIndex] = 'assets/images/note.png'; // note 이미지로 변경
    });

    // 1초 후에 원래 이미지로 복구
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        buttonImages[noteIndex] = 'assets/images/orangenote.png'; // orangenote 이미지로 복구
      });
    });
  }

  void userTapped(String note) {
    userInput.add(note); // 사용자가 입력한 음 추가
    checkUserInput(); // 입력 확인
  }

    void checkUserInput() {
    if (userInput.length > melodies[currentMelodyIndex].length) {
      // 사용자의 입력이 멜로디 길이를 초과하면 다시 초기화
      userInput = [];
      return;
    }

    for (int i = 0; i < userInput.length; i++) {
      if (userInput[i] != melodies[currentMelodyIndex][i]) {
        // 잘못된 입력일 경우
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('오답입니다!'),
              content: Text('멜로디를 다시 시도해 주세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    userInput = []; // 입력 초기화
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    // 모든 입력이 맞는 경우
    if (userInput.length == melodies[currentMelodyIndex].length) {
      if (currentMelodyIndex < melodies.length - 1) {
        // 다음 멜로디로 이동
        setState(() {
          currentMelodyIndex++;
          userInput = [];
        });

        // 1초 후에 다음 마디 시작
        Future.delayed(Duration(seconds: 1), () {
          playMelody(); // 다음 마디 재생
        });

      } else {
        // 모든 멜로디 성공
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('모든 멜로디 성공!'),
              content: Text('축하합니다! 모든 멜로디를 성공적으로 재생했습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context); // 메인 화면으로 이동
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      }
    }
    }
}
