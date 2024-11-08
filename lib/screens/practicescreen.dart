import 'package:chordefine/main.dart';
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

void main() {
  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chord Practice',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PracticeScreen(),
    );
  }
}

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final List<String> exploreItems = [
    'A Major',
    'B Major',
    'C Major',
    'D Major',
    'E Major',
    'F Major',
    'G Major',
  ];

  final PracticeScreenController controller =
      Get.put(PracticeScreenController());

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
        title: const Text('Explore Songs'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProgress()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Chords',
                style: Theme.of(context).textTheme.headline6,
              ),
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
                            builder: (context) => SongDetailsScreen(
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
                                    builder: (context) => SongDetailsScreen(
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

class PracticeScreenController extends GetxController {
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

class SongDetailsScreen extends StatelessWidget {
  final String title;
  final List<String> images;
  final String expectedChord;

  const SongDetailsScreen(
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
                            CameraScreen(expectedChord: expectedChord),
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

class CameraScreen extends StatefulWidget {
  final String expectedChord;

  const CameraScreen({Key? key, required this.expectedChord}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  String output = 'Detecting...';
  bool showProceedButton = false;
  int correctChordCounter = 0;
  bool detectionComplete = false;

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  void loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
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
            output = 'Correct Chord';
            detectionComplete = true;
            showProceedButton = true;
          
        } else {
          output = 'Wrong Chord';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PracticeScreenController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chord Detection'),automaticallyImplyLeading: false,),
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
      floatingActionButton: showProceedButton
          ? FloatingActionButton(
              onPressed: () {
                if (Get.isRegistered<NoteChordController>()) {
                  Get.delete<NoteChordController>();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AudioDetectionScreen(expectedChord: widget.expectedChord),
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
    cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }
}



class NoteChordController extends GetxController {
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

  NoteChordController(this.expectedChord);

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
    Get.find<PracticeScreenController>().markChordAsCompleted(expectedChord);
  }

  @override
  void onClose() {
    _audioRecorder.stop();
    chordDetectionTimer?.cancel();
    super.onClose();
  }
}

class AudioDetectionScreen extends StatelessWidget {
  final String expectedChord;

  const AudioDetectionScreen({Key? key, required this.expectedChord}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<NoteChordController>()) {
      Get.delete<NoteChordController>();
    }
    final controller = Get.put(NoteChordController(expectedChord));

    return Scaffold(
      appBar: AppBar(title: const Text('Chord Recognizer'),automaticallyImplyLeading: false,),
      body: SafeArea(
        child: Center(
          child: Obx(() {
            if (!controller.hasAudioPermission.value) {
              return const Text("No audio permission provided");
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: false,
                  child: Text(
                    "Recognized Note: ${controller.recognizedNote.value}",
                    style: const TextStyle(fontSize: 20),
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
                    MaterialPageRoute(builder: (context) => const MyProgress()),
                  );
                },
                child: const Text('Done'),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}

class MyProgress extends StatelessWidget {
  const MyProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PracticeScreenController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              controller.clearNotifications();
            },
          ),
        ],
      ),
      body: Obx(() {
        return controller.completedChords.isEmpty
            ? const Center(child: Text("No completed chords yet."))
            : ListView.builder(
                itemCount: controller.completedChords.length,
                itemBuilder: (context, index) {
                  final chord = controller.completedChords.elementAt(index);
                  return ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text("Congratulations! You've completed $chord Major."),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const PracticeScreen()),
            (Route<dynamic> route) => false,
          );
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
