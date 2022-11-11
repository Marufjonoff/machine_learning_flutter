import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognitionPage extends StatefulWidget {
  const TextRecognitionPage({Key? key}) : super(key: key);

  @override
  State<TextRecognitionPage> createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
      scannedText = "Matnni o'qishda xatolik";
      if (kDebugMode) {
        print("Error");
      }
    }
  }

  Future<void> getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    // final textDetector = GoogleMlKit.vision.textRecognizer();
    final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matnni aniqlash"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: textScanning ? const LinearProgressIndicator() : const SizedBox.shrink(),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, elevation: 0),
            onPressed: () {
              getImage(ImageSource.gallery);
            },
            child: const Icon(Icons.add_photo_alternate),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, elevation: 0),
            onPressed: () {
              getImage(ImageSource.camera);
            },
            child: const Icon(Icons.add_a_photo),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          if (imageFile == null && !textScanning)
          const Text("Rasmni yuklang", style: TextStyle(fontSize: 18),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(scannedText, style: const TextStyle(fontSize: 13),),
          ),
          if (imageFile == null && !textScanning)
            Container(
              height: MediaQuery.of(context).size.width/2,
              width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.deepPurple),
            ),
          if (imageFile != null)
            Image.file(File(imageFile!.path), fit: BoxFit.fill),
        ],
      ),
    );
  }
}
