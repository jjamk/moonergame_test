import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      exit(1);
    }
  };

  runApp(const ColoringGame());
}

class ColoringGame extends StatelessWidget {
  const ColoringGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ColoringGameScreen(),
    );
  }
}

class ColoringGameScreen extends StatefulWidget {
  const ColoringGameScreen({Key? key}) : super(key: key);

  @override
  State<ColoringGameScreen> createState() => _ColoringGameScreenState();
}

class _ColoringGameScreenState extends State<ColoringGameScreen> {
  /// 绘制控制器
  final DrawingController _drawingController = DrawingController();
  // 사용자가 선택한 색상을 저장하는 변수
  Color selectedColor = Colors.black;
  

  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // 그리기 스타일 설정
    _drawingController.setStyle(
    );
  }

  
  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  /// 获取画板数据 `getImageData()`
  Future<void> _getImageData() async {
    final Uint8List? data =
        (await _drawingController.getImageData())?.buffer.asUint8List();
    if (data == null) {
      debugPrint('获取图片数据失败');
      return;
    }

    if (mounted) {
    showDialog<void>(
      context: context,
      builder: (BuildContext c) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // DrawingBoard에서 가져온 이미지 데이터로부터 생성한 이미지
              Image.memory(data),
              // 로컬 파일 'cat.png' 이미지 위젯
              Positioned(
                child: Image.asset('assets/images/cat.png'),
              ),
            ],
          ),
        );
      },
    );
  }
}

  void _restBoard() {
    _transformationController.value = Matrix4.identity();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Drawing Test'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.check), onPressed: _getImageData),
          IconButton(
              icon: const Icon(Icons.restore_page_rounded),
              onPressed: _restBoard),
        ],
      ),
      body: Stack(
        children: <Widget>[
          
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return DrawingBoard(
                  // boardPanEnabled: false,
                  // boardScaleEnabled: false,
                  transformationController: _transformationController,
                  controller: _drawingController,
                  // background: _backgroundWidget,
                  background: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
           decoration: BoxDecoration(
               image: DecorationImage(
                 fit: BoxFit.contain,
            image: AssetImage('assets/images/cat.png'))
)),
                  showDefaultActions: true,
                  showDefaultTools: true,
                  defaultToolsBuilder: (Type t, _) {
                    return DrawingBoard.defaultTools(t, _drawingController);
                    
                      // ..insert(
                      //   1,
                      //   DefToolItem(
                      //     icon: Icons.change_history_rounded,
                      //     isActive: t == Triangle,
                      //     onTap: () =>
                      //         _drawingController.setPaintContent(Triangle()),
                      //   ),
                      // );
                      // ..insert(
                      //   2,
                      //   DefToolItem(
                      //     icon: Icons.image_rounded,
                      //     isActive: t == ImageContent,
                      //     onTap: () async {
                      //       showDialog(
                      //         context: context,
                      //         barrierDismissible: false,
                      //         builder: (BuildContext c) {
                      //           return const Center(
                      //             child: CircularProgressIndicator(),
                      //           );
                      //         },
                      //       );

                      //       try {
                      //         _drawingController.setPaintContent(ImageContent(
                      //           await _getImage(_imageUrl),
                      //           imageUrl: _imageUrl,
                      //         ));
                      //       } catch (e) {
                      //         //
                      //       } finally {
                      //         if (context.mounted) {
                      //           Navigator.pop(context);
                      //         }
                      //       }
                      //     },
                      //   ),
                      // );
                  },
                );

              },
            ),
          ),
//           Container(
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                  fit: BoxFit.contain,
//             image: AssetImage('assets/images/cat.png'))
// )),
          
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_state_notifier/flutter_state_notifier.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:scribble/scribble.dart';


// void main() => runApp(MoleGame());
// class MoleGame extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//         home: new HomePage(title:"gg"));
//   }
// }
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late ScribbleNotifier notifier;

//   @override
//   void initState() {
//     notifier = ScribbleNotifier();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return 
//       Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.contain,
//                 image: AssetImage('assets/images/cat.png'))),
//           child: Stack(
//                 children: <Widget>[
//             SingleChildScrollView(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 2,
//               child: Stack(
//                 children: [
//                   Scribble(
//                     notifier: notifier,
//                     drawPen: true,
//                   ),
                  
//                   Positioned(
//                     top: 16,
//                     right: 16,
//                     child: Column(
//                       children: [
//                         _buildStrokeToolbar(context),
//                         const Divider(
//                           height: 16,
//                         ),
//                         _buildColorToolbar(context),
//                       ],
//                     ),
//               ),
              
//               ],
//               ),
//             ),),
            
            
            
//             ],),
//         ),
//       );
//   }

//   Future<void> _saveImage(BuildContext context) async {
//     final image = await notifier.renderImage();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Your Image"),
//         content: Image.memory(image.buffer.asUint8List()),
//       ),
//     );
//   }

//   Widget _buildStrokeToolbar(BuildContext context) {
//     return StateNotifierBuilder<ScribbleState>(
//       stateNotifier: notifier,
//       builder: (context, state, _) => Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           for (final w in notifier.widths)
//             _buildStrokeButton(
//               context,
//               strokeWidth: w,
//               state: state,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStrokeButton(
//     BuildContext context, {
//     required double strokeWidth,
//     required ScribbleState state,
//   }) {
//     final selected = state.selectedWidth == strokeWidth;
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: Material(
//         elevation: selected ? 4 : 0,
//         shape: const CircleBorder(),
//         child: InkWell(
//           onTap: () => notifier.setStrokeWidth(strokeWidth),
//           customBorder: const CircleBorder(),
//           child: AnimatedContainer(
//             duration: kThemeAnimationDuration,
//             width: strokeWidth * 2,
//             height: strokeWidth * 2,
//             decoration: BoxDecoration(
//                 color: state.map(
//                   drawing: (s) => Color(s.selectedColor),
//                   erasing: (_) => Colors.transparent,
//                 ),
//                 border: state.map(
//                   drawing: (_) => null,
//                   erasing: (_) => Border.all(width: 1),
//                 ),
//                 borderRadius: BorderRadius.circular(50.0)),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildColorToolbar(BuildContext context) {
//     return StateNotifierBuilder<ScribbleState>(
//       stateNotifier: notifier,
//       builder: (context, state, _) => Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           _buildUndoButton(context),
//           const Divider(
//             height: 4.0,
//           ),
//           _buildRedoButton(context),
//           const Divider(
//             height: 4.0,
//           ),
//           _buildClearButton(context),
//           const Divider(
//             height: 20.0,
//           ),
//           _buildPointerModeSwitcher(context,
//               penMode:
//                   state.allowedPointersMode == ScribblePointerMode.penOnly),
//           const Divider(
//             height: 20.0,
//           ),
//           _buildEraserButton(context, isSelected: state is Erasing),
//           _buildColorButton(context, color: Colors.black, state: state),
//           _buildColorButton(context, color: Colors.white, state: state),
//           _buildColorButton(context, color: Colors.red, state: state),
//           _buildColorButton(context, color: Colors.redAccent, state: state),
//           _buildColorButton(context, color: Colors.green, state: state),
//           _buildColorButton(context, color: Colors.blue, state: state),
//           _buildColorButton(context, color: Colors.blueGrey, state: state),
//           _buildColorButton(context, color: Colors.yellow, state: state),
//           _buildColorButton(context, color: Colors.deepOrange, state: state),
//           _buildColorButton(context, color: Colors.orange, state: state),
//         ],
//       ),
//     );
//   }

//   Widget _buildPointerModeSwitcher(BuildContext context,
//       {required bool penMode}) {
//     return FloatingActionButton.small(
//       onPressed: () => notifier.setAllowedPointersMode(
//         penMode ? ScribblePointerMode.all : ScribblePointerMode.penOnly,
//       ),
//       tooltip:
//           "Switch drawing mode to " + (penMode ? "all pointers" : "pen only"),
//       child: AnimatedSwitcher(
//         duration: kThemeAnimationDuration,
//         child: !penMode
//             ? const Icon(
//                 Icons.touch_app,
//                 key: ValueKey(true),
//               )
//             : const Icon(
//                 Icons.do_not_touch,
//                 key: ValueKey(false),
//               ),
//       ),
//     );
//   }

//   Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: FloatingActionButton.small(
//         tooltip: "Erase",
//         backgroundColor: const Color(0xFFF7FBFF),
//         elevation: isSelected ? 10 : 2,
//         shape: !isSelected
//             ? const CircleBorder()
//             : RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//         child: const Icon(Icons.remove, color: Colors.blueGrey),
//         onPressed: notifier.setEraser,
//       ),
//     );
//   }

//   Widget _buildColorButton(
//     BuildContext context, {
//     required Color color,
//     required ScribbleState state,
//   }) {
//     final isSelected = state is Drawing && state.selectedColor == color.value;
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: FloatingActionButton.small(
//           backgroundColor: color,
//           elevation: isSelected ? 10 : 2,
//           shape: !isSelected
//               ? const CircleBorder()
//               : RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//           child: Container(),
//           onPressed: () => notifier.setColor(color)),
//     );
//   }

//   Widget _buildUndoButton(
//     BuildContext context,
//   ) {
//     return FloatingActionButton.small(
//       tooltip: "Undo",
//       onPressed: notifier.canUndo ? notifier.undo : null,
//       disabledElevation: 0,
//       backgroundColor: notifier.canUndo ? Colors.blueGrey : Colors.grey,
//       child: const Icon(
//         Icons.undo_rounded,
//         color: Colors.white,
//       ),
//     );
//   }

//   Widget _buildRedoButton(
//     BuildContext context,
//   ) {
//     return FloatingActionButton.small(
//       tooltip: "Redo",
//       onPressed: notifier.canRedo ? notifier.redo : null,
//       disabledElevation: 0,
//       backgroundColor: notifier.canRedo ? Colors.blueGrey : Colors.grey,
//       child: const Icon(
//         Icons.redo_rounded,
//         color: Colors.white,
//       ),
//     );
//   }

//   Widget _buildClearButton(BuildContext context) {
//     return FloatingActionButton.small(
//       tooltip: "Clear",
//       onPressed: notifier.clear,
//       disabledElevation: 0,
//       backgroundColor: Colors.blueGrey,
//       child: const Icon(Icons.clear),
//     );
//   }
// } 
