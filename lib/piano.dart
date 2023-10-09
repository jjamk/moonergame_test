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

class PianoGameScreen extends StatelessWidget {
  final List<Color> keyColors = [
    Colors.white70,
    Colors.black,
    Colors.white70,
    Colors.black,
    Colors.white70,
    Colors.black,
    Colors.white70,
    Colors.black,
    Colors.white,
    Colors.black,
    Colors.white,
  ];

  final List<String> notes = [
    'C',
    //'C#',
    'D',
    //'D#',
    'E',
    'F',
    //'F#',
    'G',

    ///'G#',
    'A',
    //'A#',
    'B',
    'high_C'
  ];

  void playSound(String note) async {
    late AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    _assetsAudioPlayer.open(Audio("assets/audio/$note.mp3"));
    _assetsAudioPlayer.play();
    //_assetsAudioPlayer.stop();
  }

  Widget buildKey(int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          playSound(notes[index]);
        },
        child: Container(
          child: Text(notes[index]),
          color: keyColors[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Flexible(
            flex: 9,
            child: Placeholder(
              fallbackHeight: 700,
              fallbackWidth: 500,
            )),
        Flexible(
          flex: 4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildKey(0),
              buildKey(1),
              buildKey(2),
              buildKey(3),
              buildKey(4),
              buildKey(5),
              buildKey(6),
              buildKey(7),
              // C
            ],
          ),
        ),
        Flexible(
            flex: 2,
            child: Placeholder(
              fallbackHeight: 700,
              fallbackWidth: 500,
            )),
      ]),
    );
  }
}
