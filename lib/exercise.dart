// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// void main() => runApp(ExerciseGameApp());

// class ExerciseGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ExerciseGameScreen(),
//     );
//   }
// }

// class ExerciseGameScreen extends StatefulWidget {
//   @override
//   _ExerciseGameScreenState createState() => _ExerciseGameScreenState();
// }

// class _ExerciseGameScreenState extends State<ExerciseGameScreen> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/bg_stage.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Center(
//           child: Image.asset(
//             'assets/images/mooner.png',
//             width: 300,
//             height: 300,
//             fit: BoxFit.cover)),
//         ]
//      ) );
//   }
  
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(ExerciseGameApp());
}

class ExerciseGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExerciseGameScreen(),
    );
  }
}

class ExerciseGameScreen extends StatefulWidget {
  @override
  _ExerciseGameScreenState createState() => _ExerciseGameScreenState();
}

class _ExerciseGameScreenState extends State<ExerciseGameScreen> {
  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();

    // ShakeDetector를 초기화하고 흔들림 감지 이벤트를 등록
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        // 흔들림 감지 시 알림을 띄움
        showShakeNotification();
      },
    );
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
          ),
          Center(
            child: Image.asset(
              'assets/images/mooner.png',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  void showShakeNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('핸드폰을 흔들었습니다!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // ShakeDetector를 정상적으로 종료
    detector.stopListening();
    super.dispose();
  }
}
