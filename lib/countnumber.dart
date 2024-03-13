import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
void main() => runApp(CountNumberGameApp());

class CountNumberGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CountNumberGameScreen(),
    );
  }
}

class CountNumberGameScreen extends StatefulWidget {
  @override
  _CountNumberGameScreenState createState() => _CountNumberGameScreenState();
}

class _CountNumberGameScreenState extends State<CountNumberGameScreen> {
late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = 'blank';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (error) {
          print('Error: $error');
        },
      );

      print('Speech initialized: $available');
      
      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (result) {
            setState(() {
              _lastWords = result.recognizedWords;

              if (_lastWords.toLowerCase() == "one") {
                _lastWords = "1";
              } else if (result.recognizedWords == "two") {
              } else if (result.recognizedWords == "three") {
              } else if (result.recognizedWords == "four") {
              } else if (result.recognizedWords == "five") {}
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),Text(
              _lastWords,
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                onPressed: () {
                  _listen();
                  print(_isListening);
                },
                child:
                    Text(_isListening ? 'Stop Listening' : 'Start Listening')),
        
        ],
     ) );
  }
  
}