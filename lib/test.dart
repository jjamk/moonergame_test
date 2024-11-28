import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

// Step 추상 클래스
abstract class Step {
  String get text;
  String get buttonText;
  Step? nextStep();
}

// 각 단계별 클래스 정의
class Step1 extends Step {
  @override
  String get text => '유리조각을 빼세요.';

  @override
  String get buttonText => '다음';

  @override
  Step? nextStep() => Step2();
}

class Step2 extends Step {
  @override
  String get text => '소독약을 골라 소독하세요.';

  @override
  String get buttonText => '다음';

  @override
  Step? nextStep() => Step3();
}

class Step3 extends Step {
  @override
  String get text => '연고를 골라 바르세요.';

  @override
  String get buttonText => '다음';

  @override
  Step? nextStep() => Step4();
}

class Step4 extends Step {
  @override
  String get text => '밴드를 골라 붙이세요.';

  @override
  String get buttonText => '끝';

  @override
  Step? nextStep() => null; // 마지막 단계
}

// 메인 화면
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Step currentStep = Step1();

  void _nextStep() {
    setState(() {
      currentStep = currentStep.nextStep() ?? currentStep;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상처 치료하기 게임'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentStep.text, style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _nextStep,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/wooden_board.png'), // 나무판자 이미지 경로
                    fit: BoxFit.cover,
                  ),
                ),
                width: 200,
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  currentStep.buttonText,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
