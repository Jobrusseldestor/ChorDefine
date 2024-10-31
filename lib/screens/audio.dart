import 'package:camera/camera.dart';
import 'package:chordefine/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  int selectedCameraIndex = 0; // Track the selected camera (0 for back, 1 for front)

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  // Load camera based on selectedCameraIndex
  loadCamera() {
    cameraController = CameraController(
      cameras![selectedCameraIndex],
      ResolutionPreset.medium,
    );
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream((imageStream) {
          cameraImage = imageStream;
          runModel();
        });
      });
    });
  }

  // Run model on the camera image
  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  // Load the TFLite model
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  // Toggle between front and back cameras
  void toggleCamera() async {
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    await cameraController?.stopImageStream();
    await cameraController?.dispose();

    setState(() {
      cameraController = null;
    });

    loadCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChorDefine')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: cameraController == null || !cameraController!.value.isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ),
            ),
          ),
          Text(
            output,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleCamera,
        child: const Icon(Icons.switch_camera),
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }
}
