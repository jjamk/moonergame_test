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
  String _lastWords = '';

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
              _lastWords = result.recognizedWords.toLowerCase();

              // Convert spoken words to numbers
              switch (_lastWords) {
                case 'one':
                case '하나':
                  _lastWords = '1';
                  break;
                case 'two':
                case '둘':
                  _lastWords = '2';
                  break;
                case 'three':
                case '셋':
                  _lastWords = '3';
                  break;
                case 'four':
                case '넷':
                  _lastWords = '4';
                  break;
                case 'five':
                case '다섯':
                  _lastWords = '5';
                  break;
                default:
                  // If unrecognized word, keep the same word
                  break;
              }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Count Number Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Last Spoken Number:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              _lastWords,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _listen();
              },
              child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// void main() => runApp(CountNumberGameApp());

// class CountNumberGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CountNumberGameScreen(),
//     );
//   }
// }

// class CountNumberGameScreen extends StatefulWidget {
//   @override
//   _CountNumberGameScreenState createState() => _CountNumberGameScreenState();
// }

// class _CountNumberGameScreenState extends State<CountNumberGameScreen> {
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   int _count = 0;
//   String _lastWords = '';
//   bool _notificationShown = false;

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onError: (error) {
//           print('Error: $error');
//         },
//       );

//       print('Speech initialized: $available');

//       if (available) {
//         setState(() {
//           _isListening = true;
//           _count = 0; // Reset count when listening starts
//           _lastWords = '';
//           _notificationShown = false; // Reset notification flag
//         });

//         _speech.listen(
//           onResult: (result) {
//             setState(() {
//               _lastWords = result.recognizedWords.toLowerCase();

//               // Convert spoken words to numbers
//               switch (_lastWords) {
//                 case 'one':
//                 case '하나':
//                   _lastWords = '1';
//                   break;
//                 case 'two':
//                 case '둘':
//                   _lastWords = '2';
//                   break;
//                 case 'three':
//                 case '셋':
//                   _lastWords = '3';
//                   break;
//                 case 'four':
//                 case '넷':
//                   _lastWords = '4';
//                   break;
//                 case 'five':
//                 case '다섯':
//                   _lastWords = '5';
//                   break;
//                 default:
//                   // If unrecognized word, keep the same word
//                   break;
//               }

//               // Check if the spoken word is a number and increment count
//               if (_lastWords.isNotEmpty && int.tryParse(_lastWords) != null) {
//                 _count = int.parse(_lastWords);
//               }

//               // Check if the user counted to 5
//               if (_count >= 1 && _count <= 5 && !_notificationShown) {
//                 _isListening = false;
//                 _speech.stop();
//                 _showNotification("5까지 세었습니다.");
//                 _notificationShown = true; // Set notification flag
//               }
//               else if(_count >= 1 && _count <= 4 && !_notificationShown){
//                 _showNotification("5까지 세라.");

//               }
//             });
//           },
//         );
//       }
//     } else {
//       setState(() {
//         _isListening = false;
//         _speech.stop();
//       });
//     }
//   }

//   void _showNotification(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("알림"),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("확인"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Count Number Game'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Last Spoken Number or Message:',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               _lastWords,
//               style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _listen();
//               },
//               child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
