import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machine_learning_flutter/pages/barcode_scanner_page.dart';
import 'package:machine_learning_flutter/pages/face_detector_page.dart';
import 'package:machine_learning_flutter/pages/image_labeling_page.dart';
import 'package:machine_learning_flutter/pages/text_recognition_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  push(Widget page) {
    Navigator.push(context, CupertinoPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine Learning Example"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: (){
                push(const TextRecognitionPage());
              },
              color: Color.fromRGBO(Random().nextInt(200), Random().nextInt(200), Random().nextInt(200), 1.0),
              elevation: 0,
              height: 50,
              minWidth: MediaQuery.of(context).size.width/2,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Colors.transparent
                )
              ),
              child: const Text("Matnni aniqlash", style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: (){
                push(const BarcodeScannerPage());
              },
              color: Color.fromRGBO(Random().nextInt(200), Random().nextInt(200), Random().nextInt(200), 1.0),
              elevation: 0,
              height: 50,
              minWidth: MediaQuery.of(context).size.width/2,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                      color: Colors.transparent
                  )
              ),
              child: const Text("Barcode skaner", style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: (){
                push(const FaceDetectorPage());
              },
              color: Color.fromRGBO(Random().nextInt(200), Random().nextInt(200), Random().nextInt(200), 1.0),
              elevation: 0,
              height: 50,
              minWidth: MediaQuery.of(context).size.width/2,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                      color: Colors.transparent
                  )
              ),
              child: const Text("Face detector", style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: (){
                push(const ImageLabelingPage());
              },
              color: Color.fromRGBO(Random().nextInt(200), Random().nextInt(200), Random().nextInt(200), 1.0),
              elevation: 0,
              height: 50,
              minWidth: MediaQuery.of(context).size.width/2,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                      color: Colors.transparent
                  )
              ),
              child: const Text("Image Labeling",  style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
