import 'package:chordefine/main.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(const MyApp());
}

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

  final Map<String, List<String>> songImages = {
    'A Major': ['assets/pics/Aimage.png', 'assets/pics/Ahand.jpg'],
    'B Major': ['assets/pics/Cimage.png', 'assets/pics/Chand.jpg'],
    'C Major': ['assets/pics/Dimage.png', 'assets/pics/Dhand.jpeg'],
    'D Major': ['assets/pics/Eimage.png', 'assets/pics/Ehand.jpg'],
    'E Major': ['assets/pics/Aimage.png', 'assets/pics/Ahand.jpg'],
    'F Major': ['assets/pics/Bimage.jpg', 'assets/pics/Bhand.jpeg'],
    'G Major': ['assets/pics/Cimage.png', 'assets/pics/Chand.jpg'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Songs'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Guitar Songs',
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
                              expectedChord: songTitle.split(" ")[0], // Extracts "A" from "A Major"
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_box_outline_blank,
                              color: Colors.grey,
                            ),
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
                              icon: const Icon(Icons.arrow_forward, color: Colors.blue),
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

class SongDetailsScreen extends StatelessWidget {
  final String title;
  final List<String> images;
  final String expectedChord;

  const SongDetailsScreen({Key? key, required this.title, required this.images, required this.expectedChord}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                        builder: (context) => CameraScreen(expectedChord: expectedChord),
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
  int correctChordCounter = 0;
  int wrongChordCounter = 0;
  int selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
    // startWrongChordTimer();
  }

  void loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        cameraController!.startImageStream((image) {
          runModel(image);
        });
      });
    });
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_u.tflite",
      labels: "assets/labels.txt",
    );
  }
  void toggleCamera() async {
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    await cameraController?.stopImageStream();
    await cameraController?.dispose();

    setState(() {
      cameraController = null;
    });

    loadCamera();
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
          output = widget.expectedChord;
          showCorrectChordDialog(); 
        } else {
          output = 'Wrong Chord';
        }
      });

      // if (correctChordCounter >= 2) { // detected for 2 seconds
      //   showCorrectChordDialog();
      // }
    }
  }

  void showCorrectChordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Correct Chord!"),
          content: const Text("Proceed to audio detection?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AudioDetectionScreen()));
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // void startWrongChordTimer() {
  //   Future.delayed(const Duration(seconds: 10), () {
  //     if (wrongChordCounter >= 10) { // no correct chord detected for 10 seconds
  //       showTipsCarousel();
  //     }
  //   });
  // }

  // void showTipsCarousel() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Chord Tips"),
  //         content: CarouselSlider(
  //           items: [
  //             Image.asset('assets/pics/Aimage.png', fit: BoxFit.cover),
  //             Image.asset('assets/pics/Ahand.jpg', fit: BoxFit.cover),
  //           ],
  //           options: CarouselOptions(
  //             height: 300.0,
  //             enableInfiniteScroll: false,
  //             enlargeCenterPage: true,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("Close"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chord Detection')),
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
        onPressed: () {},
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

class AudioDetectionScreen extends StatelessWidget {
  const AudioDetectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Detection')),
      body: Center(
        child: const Text(
          "Audio Detection Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}