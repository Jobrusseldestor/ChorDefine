import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chordefine/main.dart';
import 'package:chordefine/screens/progress.dart';
import 'package:chordefine/screens/tunerscreen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:camera/camera.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image/image.dart' as img;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Major Chords',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PracticeScreenMajor(
        title: 'Major Chords',
      ),
    );
  }
}

class PracticeScreenMajor extends StatefulWidget {
  const PracticeScreenMajor({Key? key, required String title})
      : super(key: key);

  @override
  _PracticeScreenMajorState createState() => _PracticeScreenMajorState();
}

class _PracticeScreenMajorState extends State<PracticeScreenMajor> {
  final List<String> exploreItems = [
    'A Major',
    'B Major',
    'C Major',
    'D Major',
    'E Major',
    'F Major',
    'G Major',
  ];

  final PracticeScreenMajorController controller =
      Get.put(PracticeScreenMajorController());

  final Map<String, List<String>> songImages = {
    'A Major': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/17.png',
      'assets/picture/1.png',
      'assets/picture/a.jpg'
    ],
    'B Major': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/19.png',
      'assets/picture/2.png',
      'assets/picture/b.png'
    ],
    'C Major': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/20.png',
      'assets/picture/3.png',
      'assets/picture/cmajor.png'
    ],
    'D Major': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/21.png',
      'assets/picture/4.png',
      'assets/picture/dmajor.png'
    ],
    'E Major': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/22.png',
      'assets/picture/5.png',
      'assets/picture/e.jpg'
    ],
    'F Major': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/23.png',
      'assets/picture/6.png',
      'assets/picture/fmajor.png'
    ],
    'G Major': [
      'assets/picture/13.png',
      'assets/picture/12.png',
      'assets/picture/24.png',
      'assets/picture/7.png',
      'assets/picture/g.jpg'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Major Chords',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: exploreItems.length,
                  itemBuilder: (context, index) {
                    final songTitle = exploreItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChordDetailsMajor(
                              title: songTitle,
                              images: songImages[songTitle]!,
                              expectedChord: songTitle
                                  .split(" ")[0], // Extracts "A" from "A Major"
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(245, 245, 110, 15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() {
                              return Icon(
                                controller.completedChords.contains(songTitle)
                                    ? Icons.music_note
                                    : Icons.music_note_outlined,
                                color: controller.completedChords
                                        .contains(songTitle)
                                    ? Colors.green
                                    : const Color.fromARGB(255, 255, 255, 255),
                              );
                            }),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songTitle,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Tap to view details',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Color.fromARGB(247, 255, 255, 255)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChordDetailsMajor(
                                      title: songTitle,
                                      images: songImages[songTitle]!,
                                      expectedChord: songTitle.split(" ")[0],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PracticeScreenMajorController extends GetxController {
  final completedChords = <String>{}.obs; // Using Set to prevent duplicates

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('majorCompletedChords', completedChords.toList());
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChords = prefs.getStringList('majorCompletedChords');
    if (savedChords != null) {
      completedChords.addAll(savedChords);
    }
  }

  void addCompletedChord(String chord) {
    if (!completedChords.contains(chord)) {
      completedChords.add(chord);
      saveNotifications(); // Save after adding a new chord
    }
  }

  void clearNotifications() {
    completedChords.clear();
    saveNotifications();
  }
}

class ChordDetailsMajor extends StatelessWidget {
  final String title;
  final List<String> images;
  final String expectedChord;

  const ChordDetailsMajor(
      {Key? key,
      required this.title,
      required this.images,
      required this.expectedChord})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              items: images
                  .map((imagePath) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(15), // Circular border
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(2, 4), // Position of shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(15), // Match radius
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 500.0,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                autoPlay: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      minimumSize: const Size(150, 50),
                      backgroundColor: const Color.fromARGB(245, 245, 110, 15)),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CameraScreenMajor(expectedChord: expectedChord),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      minimumSize: const Size(150, 50),
                      backgroundColor: const Color.fromARGB(245, 245, 110, 15)),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CameraScreenMajor extends StatefulWidget {
  final String expectedChord;

  const CameraScreenMajor({Key? key, required this.expectedChord})
      : super(key: key);

  @override
  _CameraScreenMajorState createState() => _CameraScreenMajorState();
}

class _CameraScreenMajorState extends State<CameraScreenMajor> {
  late CameraController _controller;
  late FlutterVision _vision;
  bool _isCameraReady = false;
  bool _isDetecting = false;
  bool _showProceedButton = false;
  String _detectionStatus = '...';
  XFile? _capturedImage;
  bool _showDetectionButton = true;

  final double _iouThreshold = 0.5;
  final double _confThreshold = 0.5;
  final double _classThreshold = 0.6;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeModel();
  }

  Future<void> _initializeCamera() async {
    final camera = cameras
        .firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);
    _controller = CameraController(camera, ResolutionPreset.medium);

    await _controller.initialize();
    if (!mounted) return;
    setState(() => _isCameraReady = true);
  }

  Future<void> _initializeModel() async {
    _vision = FlutterVision();
    await _vision.loadYoloModel(
      modelPath: 'assets/major.tflite',
      labels: 'assets/labels.txt',
      modelVersion: "yolov8",
    );
  }

  Future<void> _captureAndDetect() async {
    if (!_isCameraReady || _isDetecting) return;

    setState(() {
      _detectionStatus = "Capturing Chord...";
      _showDetectionButton = false; // Hide button on tap
    });

    _capturedImage = await _controller.takePicture();

    if (_capturedImage != null) {
      setState(() => _detectionStatus = "Processing Chord...");
      _processImage(await _capturedImage!.readAsBytes());
    }
  }

  Future<void> _processImage(Uint8List imgBytes) async {
    _isDetecting = true;
    try {
      final resizedBytes = await _preprocessImage(imgBytes);
      final results = await _vision.yoloOnImage(
        bytesList: resizedBytes,
        imageHeight: 640,
        imageWidth: 640,
        iouThreshold: _iouThreshold,
        confThreshold: _confThreshold,
        classThreshold: _classThreshold,
      );

      if (results.isNotEmpty) {
        final detectedChord = results[0]['tag'];
        if (detectedChord == widget.expectedChord) {
          _showSuccessDialog();
        } else {
          setState(() => _detectionStatus = 'Incorrect chord detected');
          _showFailDialog();
        }
      } else {
        setState(() => _detectionStatus = 'Incorrect chord detected');
        _showFailDialog();
      }
    } catch (e) {
      print("Detection error: $e");
    } finally {
      _isDetecting = false;
    }
  }

  Future<Uint8List> _preprocessImage(Uint8List imgBytes) async {
    img.Image? originalImage = img.decodeImage(imgBytes);
    if (originalImage != null) {
      img.Image resizedImage =
          img.copyResize(originalImage, width: 640, height: 640);
      return Uint8List.fromList(img.encodeJpg(resizedImage));
    } else {
      throw Exception('Failed to decode image');
    }
  }

  void _showSuccessDialog() {
    setState(() {
      _detectionStatus = '${widget.expectedChord} Major chord detected';
      _showProceedButton = true;
    });

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Congratulations!",
      desc: "You have performed the chord correctly!",
      btnOkOnPress: () {},
    ).show();
  }

  void _showFailDialog() {
    Future.delayed(Duration(seconds: 3), () {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        btnOkText: "Retry",
        title: "Keep Trying!",
        desc: "Make sure you are performing the chord correctly.",
        btnOkOnPress: () {
          _captureAndDetect();
        },
      ).show();
    });
  }

  Future<void> _closeResources() async {
    await _controller.stopImageStream();
    await _controller.dispose();
    await _vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Detecting ${widget.expectedChord} Major Chord',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: _isCameraReady
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              Text(
                _detectionStatus,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              if (_showDetectionButton)
                ElevatedButton(
                  onPressed: _captureAndDetect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(245, 245, 110,
                        15), // Set your desired button color here
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12), // Optional padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Optional rounded corners
                    ),
                  ),
                  child: const Text(
                    "Start Detection",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                _closeResources();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PracticeScreenMajor(title: 'Major Chords')),
                );
              },
              backgroundColor: const Color.fromARGB(245, 245, 110, 15),
              child: const Icon(Icons.cancel),
            ),
          ),
        ],
      ),
      floatingActionButton: _showProceedButton
          ? FloatingActionButton(
              onPressed: () {
                _closeResources();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioDetectionScreenMajor(
                        expectedChord: widget.expectedChord),
                  ),
                );
              },
              backgroundColor: const Color.fromARGB(245, 245, 110, 15),
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _closeResources();
    super.dispose();
  }
}

class NoteChordControllerMajor extends GetxController {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);

  var hasAudioPermission = false.obs;
  var currentPitch = 0.0.obs;
  var recognizedNote = ''.obs;
  var recognizedChord = ''.obs;
  var output = 'Listening...'.obs;
  var showDoneButton = false.obs;
  bool detectionComplete = false;

  final List<double> recentFrequencies = [];
  static const int frequencyBufferSize = 12;

  Timer? chordDetectionTimer;
  String expectedChord = '';

  NoteChordControllerMajor(this.expectedChord);

  @override
  void onInit() {
    super.onInit();
    requestAudioPermission();
  }

  Future<void> requestAudioPermission() async {
    if (await Permission.microphone.request().isGranted) {
      hasAudioPermission.value = true;
      startCapture();
    }
  }

  Future<void> startCapture() async {
    await _audioRecorder.start(listener, error,
        sampleRate: 44100, bufferSize: 1400);
    chordDetectionTimer =
        Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!detectionComplete) {
        recognizeChord();
      }
    });
  }

  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();
    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      currentPitch.value = result.pitch;
      updateRecentFrequencies(result.pitch);
      recognizedNote.value = findClosestNote(result.pitch);
    }
  }

  void updateRecentFrequencies(double frequency) {
    if (recentFrequencies.isEmpty ||
        (frequency - recentFrequencies.last).abs() > 1.0) {
      recentFrequencies.add(frequency);
      if (recentFrequencies.length > frequencyBufferSize) {
        recentFrequencies.removeAt(0);
      }
    }
  }

  String findClosestNote(double frequency) {
    double minDifference = double.infinity;
    String closestNote = '';

    noteFrequencies.forEach((freq, note) {
      double difference = (frequency - freq).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestNote = note;
      }
    });

    return minDifference < 2.0 ? closestNote : '';
  }

  void recognizeChord() {
    List<String> currentNotes = recentFrequencies
        .map((freq) => findClosestNote(freq))
        .where((note) => note.isNotEmpty)
        .toSet()
        .toList();

    if (currentNotes.length >= 3) {
      recognizedChord.value = identifyChord(currentNotes);

      if (recognizedChord.value == expectedChord) {
        output.value = "Correct! You played $expectedChord";
        detectionComplete = true;
        showDoneButton.value = true;
      } else if (!detectionComplete) {
        output.value = "Wrong Chord";
      }
    } else {
      recognizedChord.value = 'Not enough notes for chord';
    }
  }

  String identifyChord(List<String> notes) {
    Set<String> noteSet = notes.toSet();

    if (noteSet.contains('A1') && noteSet.contains('A2')) {
      return 'A';
    } else if (noteSet.contains('B1')) {
      return 'B';
    } else if (noteSet.contains('C2') || noteSet.contains('C3')) {
      return 'C';
    } else if (noteSet.contains('D3') || noteSet.contains('D1')) {
      return 'D';
    } else if (noteSet.contains('#G3') ||
        noteSet.contains('E1') ||
        noteSet.contains('E2')) {
      return 'E';
    } else if (noteSet.contains('F1') || noteSet.contains('F2')) {
      return 'F';
    } else if (noteSet.contains('G1') || noteSet.contains('G2')) {
      return 'G';
    } else {
      return 'Unknown chord';
    }
  }

  void error(Object e) {
    print('Error in audio capture: $e');
  }

  void markChordAsCompleted() {
    Get.find<PracticeScreenMajorController>().addCompletedChord(expectedChord);
  }

  @override
  void onClose() {
    _audioRecorder.stop();
    chordDetectionTimer?.cancel();
    super.onClose();
  }
}

class AudioDetectionScreenMajor extends StatelessWidget {
  final String expectedChord;

  const AudioDetectionScreenMajor({Key? key, required this.expectedChord})
      : super(key: key);

  
  @override
  
  Widget build(BuildContext context) {
    if (Get.isRegistered<NoteChordControllerMajor>()) {
      Get.delete<NoteChordControllerMajor>();
    }
    int wrongchordcount = 0;
    final controller = Get.put(NoteChordControllerMajor(expectedChord));
    ever(controller.output, (String output) {
      if (output == "Correct! You played $expectedChord") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          showCloseIcon: true,
          animType: AnimType.topSlide,
          title: "Congratulations!",
          desc: "You have played the chord correctly!",
          btnOkOnPress: () {},
          btnOkIcon: Icons.check,
        ).show();
      } else {
        wrongchordcount++;
        if(wrongchordcount == 3){
        Future.delayed(Duration(seconds: 2), () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            btnOkText: "Tune",
            title: "Wrong Chord!",
            btnCancelOnPress: () {},
            desc: "Have you tuned your guitar?",
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TunerScreen()),
              );
            },
          ).show();
        });
        wrongchordcount = 0;
        }
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Obx(() {
                if (!controller.hasAudioPermission.value) {
                  return const Text("No audio permission provided");
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        'Detecting ${expectedChord} Major',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Image.asset(
                        'assets/images/mike.png', // Placeholder for the microphone image
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Recognized Chord: ${controller.recognizedChord.value}",
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      controller.output.value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: controller.output.value == "Correct Chord"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PracticeScreenMajor(
                            title: 'Major Chords',
                          )),
                );
              },
              backgroundColor: const Color.fromARGB(245, 245, 110, 15),
              child: const Icon(Icons.cancel),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return controller.showDoneButton.value
            ? FloatingActionButton(
                onPressed: () {
                  controller.markChordAsCompleted();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyProgress()),
                  );
                },
                backgroundColor: const Color.fromARGB(245, 245, 110, 15),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}

var noteFrequencies = {
  32.7: 'C1',
  34.65: '#C1',
  36.71: 'D1',
  38.89: '#D1',
  41.2: 'E1',
  43.65: 'F1',
  46.25: '#F1',
  49.0: 'G1',
  51.91: '#G1',
  55.0: 'A1',
  58.27: '#A1',
  61.74: 'B1',
  65.41: 'C2',
  69.3: '#C2',
  73.42: 'D2',
  77.78: '#D2',
  82.41: 'E2',
  87.31: 'F2',
  92.5: '#F2',
  98.0: 'G2',
  103.83: '#G2',
  110.0: 'A2',
  116.54: '#A2',
  123.47: 'B2',
  130.81: 'C3',
  138.59: '#C3',
  146.83: 'D3',
  155.56: '#D3',
  164.81: 'E3',
  174.61: 'F3',
  185.0: '#F3',
  196.0: 'G3',
  207.65: '#G3',
  220.0: 'A3',
  233.08: '#A3',
  246.94: 'B3',
  261.63: 'C4',
  277.18: '#C4',
  293.66: 'D4',
  311.13: '#D4',
  329.63: 'E4',
  349.23: 'F4',
  369.99: '#F4',
  392.0: 'G4',
  415.3: '#G4',
  440.0: 'A4',
  466.16: '#A4',
  493.88: 'B4',
  523.25: 'C5',
  554.37: '#C5',
  587.33: 'D5',
  622.25: '#D5',
  659.25: 'E5',
  698.46: 'F5',
  739.99: '#F5',
  783.99: 'G5',
  830.61: '#G5',
  880.0: 'A5',
  932.33: '#A5',
  987.77: 'B5',
  1046.5: 'C6',
  1108.73: '#C6',
  1174.66: 'D6',
  1244.51: '#D6',
  1318.51: 'E6',
  1396.91: 'F6',
  1479.98: '#F6',
  1567.98: 'G6',
  1661.22: '#G6',
  1760.0: 'A6',
  1864.66: '#A6',
  1975.53: 'B6',
  2093.0: 'C7',
};
