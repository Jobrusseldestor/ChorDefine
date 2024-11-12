import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:logger/logger.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

final Logger logger = Logger();

class RealTimeScreen extends StatefulWidget {
  const RealTimeScreen({super.key});

  @override
  RealTimeScreenState createState() => RealTimeScreenState();
}

class RealTimeScreenState extends State<RealTimeScreen> {
  late CameraController _controller;
  late FlutterVision vision;
  Interpreter? _interpreter;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  List<String>? _labels;
  bool _isCameraReady = false;
  bool _isDetecting = false;
  bool _isDialogVisible = false;
  bool _isFlashOn = false;
  bool _isUsingUploadedImage = false;
  bool _imageCaptured = false;

  XFile? _uploadedImage;
  String _detectionStatus = "Initializing camera...";

  final double _iouThreshold = 0.5;
  final double _confThreshold = 0.5;
  final double _classThreshold = 0.6;

  final picker = ImagePicker();
  List<String> detectionResults = [];

  @override
  void initState() {
    super.initState();
    _initializeCameras();
    _initializeVision();
  }

  Future<void> _initializeCameras() async {
    logger.i("Initializing cameras...");
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _selectedCameraIndex = 0;
      await _initializeCamera(_cameras[_selectedCameraIndex]);
    } else {
      logger.e("No cameras found on device.");
      setState(() {
        _detectionStatus = "No camera available";
      });
    }
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    try {
      await _controller.initialize();
      await _controller.setFlashMode(FlashMode.off);
      setState(() {
        _isCameraReady = true;
        _detectionStatus = "Camera ready, starting detection...";
      });
      _startRealTimeDetection();
    } catch (e) {
      logger.e("Failed to initialize camera", error: e);
      setState(() {
        _detectionStatus = "Camera initialization failed";
      });
    }
  }

  Future<void> _initializeVision() async {
    logger.i("Loading YOLOv8 model...");
    vision = FlutterVision();
    try {
      await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/major.tflite',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: false,
      );
      logger.i("YOLOv8 model loaded successfully.");
    } catch (e) {
      logger.e("Failed to load YOLOv8 model", error: e);
      setState(() {
        _detectionStatus = "YOLO model load failed";
      });
    }
  }

  void _startRealTimeDetection() {
    if (!_isCameraReady ||
        _isUsingUploadedImage ||
        _controller.value.isStreamingImages) {
      logger.i("Camera is already streaming or not ready.");
      return;
    }
    logger.i("Starting real-time detection...");
    setState(() {
      _detectionStatus = "Detecting...";
    });

    _controller.startImageStream((cameraImage) async {
      if (_isDetecting || _isDialogVisible || !mounted || _imageCaptured)
        return;
      _isDetecting = true;
      _imageCaptured = true;
      detectionResults.clear();

      try {
        logger.i("Processing camera frame for YOLOv8...");
        final result = await vision.yoloOnFrame(
          bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
          imageHeight: cameraImage.height,
          imageWidth: cameraImage.width,
          iouThreshold: _iouThreshold,
          confThreshold: _confThreshold,
          classThreshold: _classThreshold,
        );

        if (result.isNotEmpty) {
          logger.i("YOLO detected banknotes in the frame.");
          setState(() {
            _detectionStatus = "Banknote detected!";
          });
          await _processDetections(result);
        } else {
          logger.i("No banknote detected in the frame.");
          setState(() {
            _detectionStatus = "No banknote detected";
          });
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            _detectionStatus = "Detecting...";
          });
        }
      } catch (e) {
        logger.e("Error during YOLO detection", error: e);
      } finally {
        if (mounted) {
          setState(() {
            _isDetecting = false;
            _imageCaptured = false;
          });
        }
      }
    });
  }

  Future<void> _pickImage() async {
    await _controller.stopImageStream();
    setState(() {
      _isUsingUploadedImage = true;
      _detectionStatus = "Processing uploaded image...";
    });

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedImage = pickedFile;
      });
      final imgBytes = await File(pickedFile.path).readAsBytes();
      final processedImageBytes = await preprocessImage(File(pickedFile.path));
      await _processImage(processedImageBytes);
    }
  }

  Future<Uint8List> preprocessImage(File imageFile) async {
    Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage != null) {
      img.Image resizedImage =
          img.copyResize(originalImage, width: 800, height: 800);
      return Uint8List.fromList(img.encodeJpg(resizedImage));
    } else {
      throw Exception('Failed to decode image');
    }
  }

  Future<void> _processImage(Uint8List imgBytes) async {
    logger.i("Processing picked image for detection...");
    try {
      final result = await vision.yoloOnImage(
        bytesList: imgBytes,
        imageHeight: 800,
        imageWidth: 800,
        iouThreshold: _iouThreshold,
        confThreshold: _confThreshold,
        classThreshold: _classThreshold,
      );

      if (result.isNotEmpty) {
        logger.i("YOLO detected banknotes in the uploaded image.");
        setState(() {
          _detectionStatus = "Banknote detected!";
        });
        await _processDetections(result);
      } else {
        logger.i("No banknote detected in the uploaded image.");
        setState(() {
          _detectionStatus = "No banknote detected";
        });
      }
    } catch (e) {
      logger.e("Error during YOLO detection on uploaded image", error: e);
      setState(() {
        _detectionStatus = "Detection error";
      });
    }
  }

Future<void> _processDetections(List<Map<String, dynamic>> results) async {
  logger.i("Processing YOLO detections...");
  detectionResults.clear();

  for (var res in results) {
    if (res['box'] == null || res['box'].length < 5) continue;

    double yoloConfidence = (res['box'][4] as double) * 100.0;
    if (yoloConfidence < _confThreshold * 100) continue;

    String tag = res['tag'] ?? 'Unknown';
    Object? monetaryValue = _extractMonetaryValue(tag);

    // Check if the detected item is a "Foreign Banknote"
    if (monetaryValue == "Foreign Banknote") {
      detectionResults.add("Foreign Banknote");
      logger.i("Detected: Foreign Banknote");
      continue;
    }

    // Process only if monetaryValue is a number
    if (monetaryValue is int) {
      XFile capturedImage = await _controller.takePicture();
      img.Image croppedImage = img.copyCrop(
        img.decodeImage(await capturedImage.readAsBytes())!,
        x: (res['box'][0] as double).toInt(),
        y: (res['box'][1] as double).toInt(),
        width: (res['box'][2] as double).toInt(),
        height: (res['box'][3] as double).toInt(),
      );
      img.Image resizedCroppedImage = img.copyResize(croppedImage, width: 224, height: 224);
      
      // Pass only numeric monetary values to CNN model
      await _processFraudDetection(resizedCroppedImage, monetaryValue, yoloConfidence);
    }
  }

  if (detectionResults.isNotEmpty) {
    _showDetectionFeedback(detectionResults.join("\n"));
  }
}

Future<void> _processFraudDetection(img.Image croppedImage, int monetaryValue, double yoloConfidence) async {
  logger.i("Starting fraud detection for value: $monetaryValue...");
  try {
    List<double> normalizedValues = croppedImage.getBytes().map((b) => b / 255.0).toList();
    var input = normalizedValues.reshape([1, 224, 224, 3]);
    var output = List.filled(2, 0.0).reshape([1, 2]);

    _interpreter?.run(input, output);
    List<double> probabilities = List<double>.from(output[0]);

    double fakeConfidence = probabilities[0] * 100.0;
    double realConfidence = probabilities[1] * 100.0;

    String resultLabel = realConfidence > fakeConfidence ? "Real" : "Fake";
    String detectionMessage = "$monetaryValue pesos - $resultLabel (Real: ${realConfidence.toStringAsFixed(2)}%, Fake: ${fakeConfidence.toStringAsFixed(2)}%)";
    detectionResults.add(detectionMessage);

    logger.i("Added detection result: $detectionMessage");
  } catch (e) {
    logger.e("Error during fraud detection", error: e);
  }
}


  void _showDetectionFeedback(String message) async {
    if (_isDialogVisible) return;
    setState(() {
      _isDialogVisible = true;
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Banknote Detection Results"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isDialogVisible = false;
                _isUsingUploadedImage = false;
                _imageCaptured = false;
                _detectionStatus = "Ready to detect";
                _uploadedImage = null;
                detectionResults.clear();
              });
              _startRealTimeDetection();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() async {
    if (_isFlashOn) {
      await _controller.setFlashMode(FlashMode.off);
    } else {
      await _controller.setFlashMode(FlashMode.torch);
    }
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  Object? _extractMonetaryValue(String tag) {
    switch (tag) {
      case 'Fifty':
        return 50;
      case 'Five_Hundred':
        return 500;
      case 'One_Hundred':
        return 100;
      case 'One_Thousand':
        return 1000;
      case 'Twenty':
        return 20;
      case 'Two_Hundred':
        return 200;
      case 'Foreign':
        return "Foreign Banknote";
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cameraPreviewWidth = MediaQuery.of(context).size.width * 0.85;
    double cameraPreviewHeight = cameraPreviewWidth * (4 / 3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('YOLOv8 Banknote Detection'),
        backgroundColor: const Color(0xFF11538E),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on,
                color: _isFlashOn ? Color(0xFFF2C948) : Colors.white),
            onPressed: _toggleFlash,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: cameraPreviewWidth,
              height: cameraPreviewHeight,
              child: _isUsingUploadedImage && _uploadedImage != null
                  ? Image.file(File(_uploadedImage!.path))
                  : _isCameraReady
                      ? CameraPreview(_controller)
                      : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
            Text(
              _detectionStatus,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.switch_camera),
                  onPressed: () async {
                    _selectedCameraIndex =
                        (_selectedCameraIndex + 1) % _cameras.length;
                    await _initializeCamera(_cameras[_selectedCameraIndex]);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.upload),
                  onPressed: _pickImage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}