import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool barcodeScanning = false;

  XFile? imageFile;

  String barcodeRes = "";

  final List<BarcodeFormat> formats = [BarcodeFormat.all];

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        barcodeScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getBarcodeScanner(pickedImage);
      }
    } catch (e) {
      barcodeScanning = false;
      imageFile = null;
      setState(() {});
      barcodeRes = "Barcodeni o'qishda xatolik";
      if (kDebugMode) {
        print("Error");
      }
    }
  }

  Future<void> getBarcodeScanner(XFile image) async {
    final barcodeScanner = BarcodeScanner(formats: formats);
    final List<Barcode> barcodes = await barcodeScanner.processImage(InputImage.fromFilePath(image.path));

    for (Barcode barcode in barcodes) {
      if (barcode.displayValue != null) {
        barcodeRes = barcode.displayValue!;
        setState(() {});
      }
    }
    barcodeScanner.close();
    barcodeScanning = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barcode"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: barcodeScanning
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Barcode => $barcodeRes",
              style: const TextStyle(fontSize: 25),
            ),
          ),
          const SizedBox(height: 20),
          if (imageFile == null && !barcodeScanning)
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
