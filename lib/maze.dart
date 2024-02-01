import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';

void main() => runApp(MazeGameApp());

class MazeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MazeGameScreen(),
    );
  }
}

class MazeGameScreen extends StatefulWidget {
  @override
  _MazeGameState createState() => _MazeGameState();

}

class _MazeGameState extends State<MazeGameScreen> {
  List<List<int>> maze = [
    [1, 1, 1, 0, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 1],
    [1, 1, 1, 0, 1, 1, 1],
  ];

  int playerRow = 0;
  int playerCol = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center, 
          children: <Widget>[
            Text('Navigate through the maze'),
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
            //SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: maze[0].length,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ maze[0].length;
                int col = index % maze[0].length;
                return GestureDetector(
                  onTap: () {
                    if ((row == playerRow || col == playerCol) && maze[row][col] == 0) {
                      setState(() {
                        playerRow = row;
                        playerCol = col;
                        if (row == maze.length - 1 && col == maze[0].length ~/ 2) {
                          // Reached the destination
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text('문어가 드디어 미로를 통과했어요!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewStage()),
                      );
                                  },
                                  child: Text('다음 스테이지로'),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: maze[row][col] == 1 ? Colors.black : Colors.white,
                    ),
                    child: playerRow == row && playerCol == col
                        ? Image.asset('assets/images/mooner.png')
                        : null,
                  ),
                );
              },
              itemCount: maze.length * maze[0].length,
            ),
          ],
        ),
      ),
    );
  }
  bool isAdjacent(int newRow, int newCol) {
    return (newRow == playerRow && (newCol == playerCol - 1 || newCol == playerCol + 1)) ||
        (newCol == playerCol && (newRow == playerRow - 1 || newRow == playerRow + 1));
  }
}