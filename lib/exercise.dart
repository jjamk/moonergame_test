import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(ExerciseGameApp());

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
  int exCount = 0; //운동 횟수 = 걸음 수
  double threshold = 20.0; // 흔들림을 감지하기 위한 임계값
  bool isShaking = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      // 가속도 데이터를 받아와 흔들림 감지
      double magnitude = event.x.abs() + event.y.abs() + event.z.abs();
      if (magnitude > threshold && !isShaking) {
        setState(() {
          exCount++;
          isShaking = true;
        });
      } else if (magnitude <= threshold) {
        isShaking = false;
      }
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
          ),
          Positioned(
            bottom: 50, // 텍스트를 이미지 아래로 50픽셀 올립니다.
            left: MediaQuery.of(context).size.width / 2 - 150, // 화면의 가로 중앙에서 텍스트 너비의 절반 만큼 왼쪽으로 이동하여 센터에 배치
            child: Column(
              children: <Widget>[
                Text(
                  '운동 횟수:',
                  style: TextStyle(fontSize: 24.0),
                ),
                Text(
                  '$exCount',
                  style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
                ),
              ],
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
}



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_sensors/flutter_sensors.dart';

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
//   bool _accelAvailable = false;
//   bool _gyroAvailable = false;
//   List<double> _accelData = List.filled(3, 0.0);
//   List<double> _gyroData = List.filled(3, 0.0);
//   StreamSubscription? _accelSubscription;
//   StreamSubscription? _gyroSubscription;

//   @override
//   void initState() {
//     _checkAccelerometerStatus();
//     _checkGyroscopeStatus();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _stopAccelerometer();
//     _stopGyroscope();
//     super.dispose();
//   }

//   void _checkAccelerometerStatus() async {
//     await SensorManager()
//         .isSensorAvailable(Sensors.ACCELEROMETER)
//         .then((result) {
//       setState(() {
//         _accelAvailable = result;
//       });
//     });
//   }

//   Future<void> _startAccelerometer() async {
//     if (_accelSubscription != null) return;
//     if (_accelAvailable) {
//       final stream = await SensorManager().sensorUpdates(
//         sensorId: Sensors.ACCELEROMETER,
//         interval: Sensors.SENSOR_DELAY_FASTEST,
//       );
//       _accelSubscription = stream.listen((sensorEvent) {
//         setState(() {
//           _accelData = sensorEvent.data;
//         });
//       });
//     }
//   }

//   void _stopAccelerometer() {
//     if (_accelSubscription == null) return;
//     _accelSubscription?.cancel();
//     _accelSubscription = null;
//   }

//   void _checkGyroscopeStatus() async {
//     await SensorManager().isSensorAvailable(Sensors.GYROSCOPE).then((result) {
//       setState(() {
//         _gyroAvailable = result;
//       });
//     });
//   }

//   Future<void> _startGyroscope() async {
//     if (_gyroSubscription != null) return;
//     if (_gyroAvailable) {
//       final stream =
//           await SensorManager().sensorUpdates(sensorId: Sensors.GYROSCOPE);
//       _gyroSubscription = stream.listen((sensorEvent) {
//         setState(() {
//           _gyroData = sensorEvent.data;
//         });
//       });
//     }
//   }

//   void _stopGyroscope() {
//     if (_gyroSubscription == null) return;
//     _gyroSubscription?.cancel();
//     _gyroSubscription = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Sensors Example'),
//         ),
//         body: Container(
//           padding: EdgeInsets.all(16.0),
//           alignment: AlignmentDirectional.topCenter,
//           child: Column(
//             children: <Widget>[
//               Text(
//                 "Accelerometer Test",
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 "Accelerometer Enabled: $_accelAvailable",
//                 textAlign: TextAlign.center,
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Text(
//                 "[0](X) = ${_accelData[0].toStringAsFixed(2)}",
//                 textAlign: TextAlign.center,
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Text(
//                 "[1](Y) = ${_accelData[1].toStringAsFixed(2)}",
//                 textAlign: TextAlign.center,
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Text(
//                 "[2](Z) = ${_accelData[2].toStringAsFixed(2)}",
//                 textAlign: TextAlign.center,
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   MaterialButton(
//                     child: Text("Start"),
//                     color: Colors.green,
//                     onPressed:
//                         _accelAvailable ? () => _startAccelerometer() : null,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                   ),
//                   MaterialButton(
//                     child: Text("Stop"),
//                     color: Colors.red,
//                     onPressed:
//                         _accelAvailable ? () => _stopAccelerometer() : null,
//                   ),
//                 ],
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Text(
//                 "Gyroscope Test",
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 "Gyroscope Enabled: $_gyroAvailable",
//                 textAlign: TextAlign.center,
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Text(
//                 "[0](X) = ${_gyroData[0].toStringAsFixed(2)}",
//                 textAlign: TextAlign.center,
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Text(
//                 "[1](Y) = ${_gyroData[1].toStringAsFixed(2)}",
//                 textAlign: TextAlign.center,
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Text(
//                 "[2](Z) = ${_gyroData[2].toStringAsFixed(2)}",
//                 textAlign: TextAlign.center,
//               ),
//               Padding(padding: EdgeInsets.only(top: 16.0)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   MaterialButton(
//                     child: Text("Start"),
//                     color: Colors.green,
//                     onPressed: _gyroAvailable ? () => _startGyroscope() : null,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                   ),
//                   MaterialButton(
//                     child: Text("Stop"),
//                     color: Colors.red,
//                     onPressed: _gyroAvailable ? () => _stopGyroscope() : null,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }