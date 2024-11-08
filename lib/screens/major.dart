import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chordefine/main.dart';
import 'package:chordefine/screens/progress.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'dart:async';
import 'dart:math' as math;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Major Chords',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PracticeScreenMajor(title: 'Major Chords',),
    );
  }
}

class PracticeScreenMajor extends StatefulWidget {
  const PracticeScreenMajor({Key? key, required String title}) : super(key: key);


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
    'A Major': ['assets/picture/8.png', 'assets/picture/1.png', 'assets/picture/a.jpg'],
    'B Major': ['assets/picture/9.png', 'assets/picture/2.png', 'assets/picture/b.png'],
    'C Major': ['assets/picture/10.png', 'assets/picture/3.png', 'assets/picture/c.jpg'],
    'D Major': ['assets/picture/11.png', 'assets/picture/4.png', 'assets/picture/d.jpeg'],
    'E Major': ['assets/picture/12.png', 'assets/picture/5.png', 'assets/picture/e.jpg'],
    'F Major': ['assets/picture/13.png', 'assets/picture/6.png', 'assets/picture/f.png'],
    'G Major': ['assets/picture/14.png', 'assets/picture/7.png', 'assets/picture/g.jpg'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Major Chords'),
        automaticallyImplyLeading: false,
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
                          color: Colors.white,
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
                                    : Colors.orange,
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
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text('Tap to view details'),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Color.fromARGB(247, 194, 89, 4)),
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
  final completedChords = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completedChords', completedChords.toList());
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChords = prefs.getStringList('completedChords');
    if (savedChords != null) {
      completedChords.addAll(savedChords);
    }
  }

  void markChordAsCompleted(String chord) {
    completedChords.add(chord);
    saveNotifications();
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
                  .map((imagePath) => Image.asset(imagePath, fit: BoxFit.cover))
                  .toList(),
              options: CarouselOptions(
                height: 400.0,
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CameraScreenMajor(expectedChord: expectedChord),
                      ),
                    );
                  },
                  child: const Text('Proceed'),
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

  const CameraScreenMajor({Key? key, required this.expectedChord}) : super(key: key);

  @override
  _CameraScreenMajorState createState() => _CameraScreenMajorState();
}

class _CameraScreenMajorState extends State<CameraScreenMajor> {
  CameraController? cameraController;
  String output = 'Detecting...';
  bool showProceedButton = false;
  bool detectionComplete = false;
  Timer? detectionTimer;

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();

    // Start the timer to check for correct chord detection every 5 seconds
    startDetectionTimer();
  }

  void loadCamera() {
    final frontCamera = cameras!.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    cameraController = CameraController(frontCamera, ResolutionPreset.medium);

    cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        cameraController!.startImageStream((image) {
          if (!detectionComplete) {
            runModel(image);
          }
        });
      });
    });
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  void startDetectionTimer() {
    detectionTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (!detectionComplete && output == 'Detecting...') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.topSlide,
          title: "Keep Trying!",
          desc: "Still detecting... Make sure you are performing the chord correctly.",
          btnOkOnPress: () {},
          btnOkIcon: Icons.refresh,
        ).show();
      }
    });
  }

  Future<void> runModel(CameraImage image) async {
    var predictions = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      numResults: 1,
      threshold: 0.5,
    );

    if (predictions != null && predictions.isNotEmpty) {
      final detectedChord = predictions.first['label'];

      setState(() {
        if (detectedChord == widget.expectedChord) {
          detectionComplete = true;
          output = '${widget.expectedChord} Major chord is Detected';

          // Show success dialog after detecting the correct chord
          Future.delayed(const Duration(milliseconds: 1500), () {
            setState(() {
              showProceedButton = true;
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.topSlide,
                title: "Congratulations!",
                desc: "You have performed the chord correctly!",
                btnOkOnPress: () {},
                btnOkIcon: Icons.check,
              ).show();
            });

            // Free resources after a delay
            Future.delayed(const Duration(seconds: 2), () async {
              await closeResources();
            });
          });
        } else {
          output = 'Detecting...';
        }
      });
    }
  }

  Future<void> closeResources() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    await Tflite.close();
    cameraController = null;
    detectionTimer?.cancel(); // Cancel the timer when resources are closed
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PracticeScreenMajorController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chord Detection'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Detecting ${widget.expectedChord} Major',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: cameraController == null || !cameraController!.value.isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: AspectRatio(
                        aspectRatio: cameraController!.value.aspectRatio,
                        child: CameraPreview(cameraController!),
                      ),
                    ),
            ),
          ),
          Text(
            output,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
        ],
      ),
      floatingActionButton: showProceedButton
          ? FloatingActionButton(
              onPressed: () {
                if (Get.isRegistered<NoteChordControllerMajor>()) {
                  Get.delete<NoteChordControllerMajor>();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AudioDetectionScreenMajor(expectedChord: widget.expectedChord),
                  ),
                );
              },
              child: const Text('Proceed'),
            )
          : null,
    );
  }

  @override
  void dispose() {
    closeResources();
    detectionTimer?.cancel(); // Cancel the timer when the widget is disposed
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
    await _audioRecorder.start(listener, error, sampleRate: 44100, bufferSize: 1400);
    chordDetectionTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
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
    if (recentFrequencies.isEmpty || (frequency - recentFrequencies.last).abs() > 1.0) {
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
        output.value = "Correct Chord";
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
    } else if (noteSet.contains('#G3') || noteSet.contains('E1') || noteSet.contains('E2')) {
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
    Get.find<PracticeScreenMajorController>().markChordAsCompleted(expectedChord);
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

  const AudioDetectionScreenMajor({Key? key, required this.expectedChord}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<NoteChordControllerMajor>()) {
      Get.delete<NoteChordControllerMajor>();
    }
    final controller = Get.put(NoteChordControllerMajor(expectedChord));
    ever(controller.output, (String output) {
      if (output == "Correct Chord") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: "Congratulations!",
          desc: "You have played the chord correctly!",
          btnOkOnPress: () {},
          btnOkIcon: Icons.check,
        ).show();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chord Recognizer'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Obx(() {
            if (!controller.hasAudioPermission.value) {
              return const Text("No audio permission provided");
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Detecting ${expectedChord} Major',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(fontSize: 20),
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
      floatingActionButton: Obx(() {
        return controller.showDoneButton.value
            ? FloatingActionButton(
                onPressed: () {
                  controller.markChordAsCompleted();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyProgress(isMajor: true)),
                  );
                },
                child: const Text('Done'),
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