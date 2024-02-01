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

  double hookLeft = 300;
  double hookTop = 400;

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
          
          child: Center(
            child: Image.asset(
            'assets/images/mooner.png',
            width: 300,
            height: 300,
            fit: BoxFit.cover)),
        ),
        Positioned(
          width: 70,
          height: 70,
          left: hookLeft,
          top: hookTop,
          child: Draggable(
            onDragUpdate: (details) {
              // 드래그가 업데이트 될 때마다 위치 업데이트
              setState(() {
                hookLeft += details.globalPosition.dx;
                hookTop += details.globalPosition.dy;
              });

              // 겹치는지 확인
              checkOverlap();
            },
            child: Image.asset('assets/images/hook.png'),
            //크기 유지
            feedback: Material(
              child: Image.asset(
                'assets/images/hook.png',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            onDragEnd: (details) {
              // 드래그가 종료될 때 위치 업데이트하지 않음
              checkOverlap();
            },
            childWhenDragging: Container(),
          ),
        ),
      ],
     ) );
  }
  
  void checkOverlap() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset(hookLeft, hookTop));

    setState(() {
      //print(position.dx);
      print(position.dy);
      // 겹치는지 확인
      areWidgetsOverlapping = position.dx >= MediaQuery.of(context).size.width - 100 &&
          position.dy >= 400 &&
          //position.dx <= MediaQuery.of(context).size.width &&
          position.dy <= 1000;
    });

    if (!areWidgetsOverlapping && !isShowingNotification) {
      // 안겹친 경우 알림 표시
      showNotification();
    }

    else {
      hookLeft = 300;
      hookTop = 400;
    }
  }

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
}
//   void showNotification() {
//     setState(() {
//       isShowingNotification = true;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('겹치지 않았어요!'),
//         duration: Duration(seconds: 1),
//         action: SnackBarAction(
//           label: '닫기',
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//             setState(() {
//               isShowingNotification = false;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }