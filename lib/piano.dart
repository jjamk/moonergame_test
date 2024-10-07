import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

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
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10), // 텍스트 간의 간격을 추가
                        const Text(
                          '문찌가 진정할 수 있게 \n 자장가를 들려주자',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piano Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'test입니다',
              style: TextStyle(fontSize: 24),
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
              ],
            ),
          ],
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
              fontWeight: FontWeight.bold,
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
  List<String> melody = ['도', '도', '솔', '솔', '라', '라', '솔']; // 멜로디 정의
  List<String> userInput = []; // 사용자가 입력한 음을 저장할 리스트
  List<String> buttonImages = List.filled(8, 'assets/images/orangenote.png'); // 각 버튼의 이미지 경로를 저장하는 리스트

  @override
  void initState() {
    super.initState();
    playMelody(); // 게임 시작 시 멜로디 재생
  }

  void playMelody() {
    for (int i = 0; i < melody.length; i++) {
      Future.delayed(Duration(seconds: i), () {
        int noteIndex = getNoteIndex(melody[i]);
        _playNoteAndShowFeedback(noteIndex); // 멜로디 재생 및 피드백
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
        title: Text('First Game'),
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
    if (userInput.length > melody.length) {
      // 사용자의 입력이 멜로디 길이를 초과하면 다시 초기화
      userInput = [];
      return;
    }

    for (int i = 0; i < userInput.length; i++) {
      if (userInput[i] != melody[i]) {
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
    if (userInput.length == melody.length) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('성공!'),
            content: Text('멜로디를 성공적으로 재생했습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  userInput = []; // 입력 초기화
                  Navigator.pop(context); // 이전 화면으로 이동
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

// 두 번째 게임 화면
class SecondGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Game'),
      ),
      body: Center(
        child: Text('Second Game Screen'),
      ),
    );
  }
}

// 세 번째 게임 화면
class ThirdGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Game'),
      ),
      body: Center(
        child: Text('Third Game Screen'),
      ),
    );
  }
}
