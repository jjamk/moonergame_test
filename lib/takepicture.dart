import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(home: TakePictureGame ()));

class TakePictureGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BMJUA'),
      home: TakePictureGameApp(),
    );
  }
}

class TakePictureGameApp extends StatefulWidget {
  @override
  _TakePictureGameAppScreen createState() => _TakePictureGameAppScreen();
}

class _TakePictureGameAppScreen extends State<TakePictureGameApp > with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  List<Uint8List> _images = [];
  List<Map<String, double>> _colorPercentages = [];
  bool _allImagesPicked = false;
  String? _selectedColor;
  late AnimationController _controller;
  List<Offset> _initialPositions = [];
  List<double> _angles = []; // 각 이미지의 이동 방향을 결정하는 각도 목록

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20), // 움직임 속도 조정
      vsync: this,
    )..repeat();
  }

  Future<void> _pickImages() async {
  final List<XFile>? pickedFiles = await _picker.pickMultiImage();
  if (pickedFiles != null && pickedFiles.length >= 3) {
    _images.clear();
    _colorPercentages.clear();
    _initialPositions.clear();
    _angles.clear();
    _allImagesPicked = false;

    Size screenSize = MediaQuery.of(context).size;
    for (XFile file in pickedFiles) {
      final Uint8List imageData = await file.readAsBytes();
      _images.add(imageData);
      await _calculateColorPercentage(imageData);
      double centerX = screenSize.width / 2;
      double centerY = screenSize.height / 2;
      _initialPositions.add(Offset(centerX - 50 + Random().nextDouble() * 100, centerY - 50 + Random().nextDouble() * 100));
      _angles.add(Random().nextDouble() * 2 * pi);
    }
    _allImagesPicked = true;
    setState(() {});
  } else {
    // Handle the case where less than 3 images are picked
    print("Please select at least 3 images.");
  }
}

  Future<void> _calculateColorPercentage(Uint8List imageData) async {
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (data == null) return;

    int redPixelCount = 0;
    int greenPixelCount = 0;
    int bluePixelCount = 0;
    int totalPixelCount = image.width * image.height;

    for (int i = 0; i < data.lengthInBytes; i += 4) {
      final r = data.getUint8(i);
      final g = data.getUint8(i + 1);
      final b = data.getUint8(i + 2);

      if (r > g && r > b) redPixelCount++;
      else if (g > r && g > b) greenPixelCount++;
      else if (b > r && b > g) bluePixelCount++;
    }

    double redPercentage = (redPixelCount / totalPixelCount) * 100;
    double greenPercentage = (greenPixelCount / totalPixelCount) * 100;
    double bluePercentage = (bluePixelCount / totalPixelCount) * 100;

    _colorPercentages.add({
      "Red": redPercentage,
      "Green": greenPercentage,
      "Blue": bluePercentage
    });
  }

  void _checkResults() {
    if (!_allImagesPicked || _selectedColor == null) return;

    int validCount = _colorPercentages.where((map) {
      bool isQualifyingColor = map[_selectedColor!]! > 50;
      bool hasTwoColorsOver30 = map.entries.where((entry) => entry.value > 30).length >= 2;
      return isQualifyingColor && !hasTwoColorsOver30;
    }).length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Result"),
          content: Text(validCount >= 2 ? "성공" : "실패"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Image Color Checker'),
      ),
      body: Stack(
        children: [
          for (int i = 0; i < _images.length; i++)
            
            AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    if (_angles.isNotEmpty && i < _angles.length) { // Check if _angles is not empty and i is within bounds
      final double waveX = sin(_angles[i] + _controller.value * 2 * pi) * 20;
      final double waveY = cos(_angles[i] + _controller.value * 2 * pi) * 20;
      double left = _initialPositions[i].dx + waveX;
      double top = _initialPositions[i].dy + waveY;

      // 화면 바깥으로 나가지 않도록 조정
      left = max(0, min(screenSize.width - 80, left));
      top = max(0, min(screenSize.height - 80, top));

      return Positioned(
        left: left,
        top: top,
        child: child!,
      );
    } else {
      return SizedBox(); // Return an empty SizedBox if _angles is empty or i is out of bounds
    }
  },
  child: Image.memory(_images[i], width: 100, height: 100, fit: BoxFit.cover),
),

          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _pickImages,
              child: Column(
              children: [
                Wrap(
                  spacing: 10,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => setState(() => _selectedColor = "Red"),
                      child: Text('빨강'),
                      style: ElevatedButton.styleFrom(backgroundColor: _selectedColor == "Red" ? Colors.red : null),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => _selectedColor = "Green"),
                      child: Text('초록'),
                      style: ElevatedButton.styleFrom(backgroundColor: _selectedColor == "Green" ? Colors.green : null),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => _selectedColor = "Blue"),
                      child: Text('파랑'),
                      style: ElevatedButton.styleFrom(backgroundColor: _selectedColor == "Blue" ? Colors.blue : null),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _allImagesPicked ? _checkResults : null,
                  child: Text('Check Results'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return states.contains(MaterialState.disabled) ? Colors.grey : Colors.blue;
                      },
                    ),
                  ),
                ),
                ElevatedButton(
              onPressed: _pickImages,
              child: Text('Pick Images'),
            ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class TakePictureGameApp xtends StatefulWidget {
//   @override
//   _TakePictureGameApp State createState() => _TakePictureGameApp State();
// }

// class _TakePictureGameApp State extends State<TakePictureGameApp > {
//   final ImagePicker _picker = ImagePicker();
//   List<Uint8List> _images = [];
//   List<Map<String, double>> _colorPercentages = [];
//   bool _allImagesPicked = false;
//   String? _selectedColor;

//   Future<void> _pickImages() async {
//     final List<XFile>? pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles != null && pickedFiles.length >= 3) {
//       _images.clear();
//       _colorPercentages.clear();
//       _allImagesPicked = false;

//       for (XFile file in pickedFiles) {
//         final Uint8List imageData = await file.readAsBytes();
//         _images.add(imageData);
//         await _calculateColorPercentage(imageData);
//       }
//       setState(() {
//         _allImagesPicked = true;
//       });
//     }
//   }

//   Future<void> _calculateColorPercentage(Uint8List imageData) async {
//     final codec = await ui.instantiateImageCodec(imageData);
//     final frame = await codec.getNextFrame();
//     final image = frame.image;

//     final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
//     if (data == null) return;

//     int redPixelCount = 0;
//     int greenPixelCount = 0;
//     int bluePixelCount = 0;
//     int totalPixelCount = image.width * image.height;

//     for (int i = 0; i < data.lengthInBytes; i += 4) {
//       final r = data.getUint8(i);
//       final g = data.getUint8(i + 1);
//       final b = data.getUint8(i + 2);

//       if (r > g && r > b) redPixelCount++;
//       else if (g > r && g > b) greenPixelCount++;
//       else if (b > r && b > g) bluePixelCount++;
//     }

//     double redPercentage = (redPixelCount / totalPixelCount) * 100;
//     double greenPercentage = (greenPixelCount / totalPixelCount) * 100;
//     double bluePercentage = (bluePixelCount / totalPixelCount) * 100;

//     _colorPercentages.add({
//       "Red": redPercentage,
//       "Green": greenPercentage,
//       "Blue": bluePercentage
//     });
//   }

//   void _checkResults() {
//     if (!_allImagesPicked || _selectedColor == null) return;

//     int validCount = _colorPercentages.where((map) {
//       bool isQualifyingColor = map[_selectedColor!]! > 50;
//       bool hasTwoColorsOver30 = map.entries.where((entry) => entry.value > 30).length >= 2;
//       return isQualifyingColor && !hasTwoColorsOver30;
//     }).length;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Result"),
//           content: Text(validCount >= 2 ? "성공" : "실패"),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Multi Image Color Checker'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Wrap(
//             spacing: 10,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: () => setState(() => _selectedColor = "Red"),
//                 child: Text('빨강'),
//                 style: ElevatedButton.styleFrom(backgroundColor: _selectedColor == "Red" ? Colors.red : null),
//               ),
//               ElevatedButton(
//                 onPressed: () => setState(() => _selectedColor = "Green"),
//                 child: Text('초록'),
//                 style: ElevatedButton.styleFrom(backgroundColor: _selectedColor == "Green" ? Colors.green : null),
//               ),
//               ElevatedButton(
//                 onPressed: () => setState(() => _selectedColor = "Blue"),
//                 child: Text('파랑'),
//                 style: ElevatedButton.styleFrom(backgroundColor: _selectedColor == "Blue" ? Colors.blue : null),
//               ),
//             ],
//           ),
//           ElevatedButton(
//             onPressed: _pickImages,
//             child: Text('Pick Images'),
//           ),
//           if (_allImagesPicked) ..._images.asMap().entries.map((entry) {
//             int index = entry.key;
//             Uint8List imageData = entry.value;
//             Map<String, double> percentages = _colorPercentages[index];
//             return ListTile(
//               leading: Image.memory(imageData, width: 100, height: 100, fit: BoxFit.cover),
//               title: Text('Red: ${percentages["Red"]!.toStringAsFixed(2)}%, '
//                           'Green: ${percentages["Green"]!.toStringAsFixed(2)}%, '
//                           'Blue: ${percentages["Blue"]!.toStringAsFixed(2)}%'),
//             );
//           }).toList(),
//           ElevatedButton(
//             onPressed: _allImagesPicked ? _checkResults : null,
//             child: Text('Check Results'),
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                 (Set<MaterialState> states) {
//                   return states.contains(MaterialState.disabled) ? Colors.grey : Colors.blue;
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() => runApp(MaterialApp(home: TakePictureGameApp ()));
