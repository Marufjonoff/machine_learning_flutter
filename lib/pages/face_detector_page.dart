import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  bool faceDetecting = false;

  XFile? imageFile;

  String result = "";

  List<Rect> rect = <Rect>[];
  var tmp;

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage != null) {
        tmp = (await pickedImage.readAsBytes()) as XFile?;
        tmp = (await decodeImageFromList(tmp)) as XFile?;
      }

      if (pickedImage != null) {
        faceDetecting = true;
        imageFile = pickedImage;
        setState(() {});
        detectFace(pickedImage);
      }
    } catch (e) {
      faceDetecting = false;
      imageFile = null;
      setState(() {});
      result = "Faceni o'qishda xatolik";
      if (kDebugMode) {
        print("Error");
      }
    }
  }

  Future<void> detectFace(XFile image) async {
    result = '';
    final options = FaceDetectorOptions();
    FaceDetector faceDetector = FaceDetector(options: options);
    List<Face> faces = await faceDetector.processImage(InputImage.fromFilePath(image.path));

    if (rect.isNotEmpty) {
      rect = <Rect>[];
    }

    for (Face face in faces) {
      rect.add(face.boundingBox);
    }

    setState(() {
      faceDetecting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yuzni aniqlash"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: faceDetecting
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          if (imageFile == null && !faceDetecting)
            const Text(
              "Rasmni yuklang",
              style:  TextStyle(fontSize: 18),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              result,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          if (imageFile == null && !faceDetecting)
            Container(
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.deepPurple),
            ),
          if (imageFile != null)
            Center(
              child: FittedBox(
                child: SizedBox(
                       width: tmp.width.toDouble(),
                       height: tmp.height.toDouble(),
                  child: CustomPaint(
                    painter:
                    FacePainter(rect: rect, imageFile: tmp),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
class FacePainter extends CustomPainter {
  List<Rect> rect;
  var imageFile;

  FacePainter({required this.rect, required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
}
