import 'package:flutter/material.dart';

void main() => runApp(HealingGameApp());

class HealingGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HealingGameScreen(),
    );
  }
}

class HealingGameScreen extends StatefulWidget {
  @override
  _HealingGameScreenState createState() => _HealingGameScreenState();
}

class _HealingGameScreenState extends State<HealingGameScreen> {
  bool areWidgetsOverlapping = false;
  bool isShowingNotification = false;
  bool woundTreated = false;

  double hookLeft = 180; // 낚싯대의 초기 왼쪽 위치
  double hookTop = 260; // 낚싯대의 초기 위쪽 위치

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 배경 이미지를 표시하는 컨테이너
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 중앙에 플레이어 이미지를 표시
          Positioned(
            child: Center(
                child: Image.asset('assets/images/mooner.png',
                    width: 350, height: 350, fit: BoxFit.cover)),
          ),
          // 문어 이미지를 표시하고 사용자가 갈고리를 빼주는 기능 추가
          if (!woundTreated)
            Positioned(
              width: 70,
              height: 70,
              left: hookLeft,
              top: hookTop,
              child: Draggable(
                onDragUpdate: (details) {
                  // 드래그가 업데이트 될 때마다 위치 업데이트
                  setState(() {
                    hookLeft += details.delta.dx;
                    hookTop += details.delta.dy;
                  });

                  // 겹치는지 확인
                  checkOverlap();
                },
                child: Image.asset('assets/images/hook.png'),
                //크기 유지
                feedback: Material(
                  child: Image.asset(
                    'assets/images/hook.png', //드래그 중인 이미지
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                onDragEnd: (details) {
                  // 문어에 갈고리가 걸린 후에 상처를 표시
                  setState(() {
                    woundTreated = true;
                  });
                },
                childWhenDragging: Container(), // 드래그 중에 대체할 위젯
              ),
            ),
          // 상처 이미지 표시
          if (woundTreated)
            Positioned(
              left: 180,
              top: 260,
              child: Image.asset(
                'assets/images/wound.png',
                width: 70,
                height: 70,
              ),
            ),
          // 연고 및 붕대 이미지를 표시하고 사용자가 상처에 적용할 수 있도록 함
          if (woundTreated && !isShowingNotification)
            Positioned(
              left: 250,
              top: 650,
              child: Draggable(
                child: Image.asset(
                  'assets/images/ointment.png',
                  width: 70,
                  height: 70,
                ),
                feedback: Image.asset(
                  'assets/images/ointment.png',
                  width: 50,
                  height: 50,
                ),
                data: 'ointment', // 드래그 데이터 설정
                onDragEnd: (details) {
                  applyTreatment('ointment'); // 연고를 상처에 적용
                },
              ),
            ),
          if (woundTreated && !isShowingNotification)
            Positioned(
              left: 100,
              top: 650,
              child: Draggable(
                child: Image.asset(
                  'assets/images/bandage.png',
                  width: 70,
                  height: 70,
                ),
                feedback: Image.asset(
                  'assets/images/bandage.png',
                  width: 50,
                  height: 50,
                ),
                data: 'bandage', // 드래그 데이터 설정
                onDragEnd: (details) {
                  applyTreatment('bandage'); // 붕대를 상처에 적용
                },
              ),
            ),
        ],
      ),
    );
  }

  void bend() {
    Positioned(
      left: 180,
      top: 260,
      child: Image.asset(
        'assets/images/bend.png',
        width: 70,
        height: 70,
      ),
    );
  }

  // 겹치는 지 확인하는 메소드
  void checkOverlap() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset(hookLeft, hookTop));

    setState(() {
      // 겹치는 지 여부를 확인하고 상태 업데이트
      areWidgetsOverlapping =
          position.dx >= MediaQuery.of(context).size.width - 100 &&
              position.dy >= 400 &&
              position.dy <= 1000;
    });

    if (!areWidgetsOverlapping && !isShowingNotification) {
      // 겹치지 않고 알림을 표시하지 않았을 경우 알림 표시
      showNotification();
    } else {
      // 겹치거나 이미 알림을 표시한 경우 초기 위치로 재설정
      hookLeft = 300;
      hookTop = 400;
    }
  }

  // 알림을 표시하는 메소드
  void showNotification() {
    setState(() {
      isShowingNotification = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('낚시빼기'),
          content: Text('잘했어요!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isShowingNotification = false;
                });
              },
              child: Text('다음'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // 드래그한 아이템을 받아 상처를 치료하는 메소드
  void applyTreatment(String item) {
    setState(() {
      isShowingNotification = true; // 알림 표시
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('치료'),
          content: Text(
              item == 'ointment' ? '연고를 발라서 덜 아파 고마워!' : '붕대까지,, 고마워 친구야!!!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (item == 'ointment') {
                  setState(() {
                    woundTreated = true; // 연고를 적용한 경우 상처를 치료함
                    isShowingNotification = false; // 알림 닫음
                  });
                } else if (item == 'bandage') {
                  setState(() {
                    woundTreated = true; // 붕대를 적용한 경우 상처를 치료함
                    isShowingNotification = false;
                    // 알림 닫음
                  });
                  hookLeft = -100; // 갈고리 위치를 화면 밖으로 이동시킴
                  hookTop = -100;

                  // 상처 이미지 제거
                  woundTreated = false;
                  bend();
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
