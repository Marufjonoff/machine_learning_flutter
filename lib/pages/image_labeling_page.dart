import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelingPage extends StatefulWidget {
  const ImageLabelingPage({Key? key}) : super(key: key);

  @override
  State<ImageLabelingPage> createState() => _ImageLabelingPageState();
}

class _ImageLabelingPageState extends State<ImageLabelingPage> {
  bool imageLabelingCheck = false;

  XFile? imageFile;

  String imageLabel = "";

  final List<BarcodeFormat> formats = [BarcodeFormat.all];

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageLabelingCheck = true;
        imageFile = pickedImage;
        setState(() {});
        getImageLabeling(pickedImage);
      }
    } catch (e) {
      imageLabelingCheck = false;
      imageFile = null;
      setState(() {});
      imageLabel = "Imageni o'qishda xatolik";
      if (kDebugMode) {
        print("Error");
      }
    }
  }

  Future<void> getImageLabeling(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler = ImageLabeler(options: ImageLabelerOptions());
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    StringBuffer sb = StringBuffer();
    for(ImageLabel imageLabel in labels) {
      String lblText = imageLabel.label;
      double confidence = imageLabel.confidence;
      sb.write(lblText);
      sb.write(" : ");
      sb.write((confidence * 100).toStringAsFixed(2));
      sb.write("%\n");
    }
    imageLabeler.close();
    imageLabel = sb.toString();
    imageLabelingCheck = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Labeling"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: imageLabelingCheck
              ? const LinearProgressIndicator()
              : const SizedBox.shrink(),
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
        children: [
          const SizedBox(height: 20),
          imageFile == null && !imageLabelingCheck ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Rasmni yuklang",
              style: TextStyle(fontSize: 20),
            ),
          ) :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Rasmni tanish \n$imageLabel",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          if (imageFile == null && !imageLabelingCheck)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.deepPurple),
            ),
          if (imageFile != null)
            Image.file(File(imageFile!.path), fit: BoxFit.fill),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
