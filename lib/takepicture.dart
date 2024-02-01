import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mooner_interface/stage.dart';
//import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
void main() => runApp(TakePictureGameApp());

class TakePictureGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TakePictureGameScreen(),
    );
  }
}

class TakePictureGameScreen extends StatefulWidget {
  @override
  _TakePictureGameScreenState createState() => _TakePictureGameScreenState();
}

class _TakePictureGameScreenState extends State<TakePictureGameScreen> {
  List<File> images = [];

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      print(images.length);
      if (pickedFile != null && images.length <= 2) {
        images.add(File(pickedFile.path));
      }
      if (images.length > 2)  {
        _showResultDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center, 
          children: <Widget>[
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_stage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.file(
                images[index],
                fit: BoxFit.cover, // 이미지를 셀에 꽉 차게 표시
                          ),
                        );
                      },
                ),
              ),
              IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: getImage,),
          ]
          ),
        
            ],
            
            ),
          ),
      );
  }
  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Game Over'),
          content: Text('잘하셨어요!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewStage()),
                      );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
