import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'dart:typed_data';

// Main screen displaying a list of songs
class CourseScreen3 extends StatefulWidget {
  const CourseScreen3({Key? key}) : super(key: key);

  @override
  _CourseScreen3State createState() => _CourseScreen3State();
}

class _CourseScreen3State extends State<CourseScreen3> {
  final List<String> exploreItems = [
    'Happy Birthday',
    'Perfect',
    'Im Yours',
    'Country Roads',
    'Let it Be',
  ];

  final List<String> songArtist = [
    'Traditional',
    'Ed Sheeran',
    'Jason Mraz',
    'John Denver',
    'The Beatles',
  ];

  // Map each song title to its list of SongLines (lyrics and notes)
  final Map<String, List<SongLine>> songData = {
    'Happy Birthday': [
      SongLine(lyrics: "Happy birthday to you", note: "G1", chord: "G"),
      SongLine(lyrics: "Happy birthday to you", note: "D1", chord: "D"),
      SongLine(lyrics: "Happy birthday dear friend", note: "C1", chord: "C"),
      SongLine(lyrics: "Happy birthday to you!", note: "G1", chord: "G"),
    ],
    'Perfect': [
      SongLine(lyrics: "Baby, I'm", note: "E1", chord: "E"), // Em is correct
      SongLine(lyrics: "dancing in", note: "C2", chord: "C"), // C major
      SongLine(lyrics: "the dark,", note: "G1", chord: "G"), // G major
      SongLine(lyrics: "with you", note: "D1", chord: "D"), // D major
      SongLine(
          lyrics: "between my arms", note: "E1", chord: "E"), // Em is correct
      SongLine(lyrics: "barefoot on the grass,", note: "C2", chord: "C"),
      SongLine(lyrics: "listening", note: "G1", chord: "G"),
      SongLine(lyrics: "to our favorite song", note: "D1", chord: "D"),
      SongLine(lyrics: "when you said you looked", note: "C2", chord: "C"),
      SongLine(lyrics: "a mess,", note: "G1", chord: "G"),
      SongLine(lyrics: "I whispered", note: "D1", chord: "D"),
      SongLine(
          lyrics: "underneath my breath",
          note: "E1",
          chord: "E"), // Em is correct
      SongLine(lyrics: "But you heard it,", note: "C2", chord: "C"),
      SongLine(lyrics: "darling you", note: "G1", chord: "G"),
      SongLine(lyrics: "look perfect", note: "D1", chord: "D"),
      SongLine(lyrics: "tonight", note: "G1", chord: "G"),
    ],
    'Im Yours': [
      SongLine(lyrics: "So I won't,", note: "G1", chord: "G"),
      SongLine(lyrics: "hesitate", note: "D1", chord: "D"),
      SongLine(lyrics: "No, more, no more", note: "E1", chord: "E"),
      SongLine(lyrics: "It cannot wait, I'm sure", note: "C2", chord: "C"),
      SongLine(lyrics: "There's no need,", note: "G1", chord: "G"),
      SongLine(lyrics: "To complicate", note: "D1", chord: "D"),
      SongLine(lyrics: "Our time is short", note: "E1", chord: "E"),
      SongLine(lyrics: "This is our fate, I'm yours", note: "C2", chord: "C"),
    ],
    'Country Roads': [
      SongLine(lyrics: "Country Roads,", note: "G1", chord: "G"),
      SongLine(lyrics: "take me home,", note: "D1", chord: "D"),
      SongLine(lyrics: "to the place,", note: "E1", chord: "E"),
      SongLine(lyrics: "I belong", note: "C2", chord: "C"),
      SongLine(lyrics: "West Virginia,", note: "G1", chord: "G"),
      SongLine(lyrics: "mountain mama,", note: "D1", chord: "D"),
      SongLine(lyrics: "take me home,", note: "C2", chord: "C"),
      SongLine(lyrics: "country roads,", note: "G1", chord: "G"),
      SongLine(lyrics: "Country Roads,", note: "G1", chord: "G"),
      SongLine(lyrics: "take me home,", note: "D1", chord: "D"),
      SongLine(lyrics: "to the place,", note: "E1", chord: "E"),
      SongLine(lyrics: "I belong", note: "C2", chord: "C"),
      SongLine(lyrics: "West Virginia,", note: "G1", chord: "G"),
      SongLine(lyrics: "mountain mama,", note: "D1", chord: "D"),
      SongLine(lyrics: "take me home,", note: "C2", chord: "C"),
      SongLine(lyrics: "country roads,", note: "G1", chord: "G"),
    ],
    'Let it Be': [
      SongLine(lyrics: "Let it be,", note: "A1", chord: "A"),
      SongLine(lyrics: "let it be,", note: "G1", chord: "G"),
      SongLine(lyrics: "let it be,", note: "F1", chord: "F"),
      SongLine(lyrics: "let it be,", note: "C1", chord: "C"),
      SongLine(lyrics: "There will be,", note: "C1", chord: "C"),
      SongLine(lyrics: "an answer,", note: "G1", chord: "G"),
      SongLine(lyrics: "Let it be,", note: "F1", chord: "F"),
      SongLine(lyrics: "Let it be,", note: "A1", chord: "A"),
      SongLine(lyrics: "let it be,", note: "G1", chord: "G"),
      SongLine(lyrics: "let it be,", note: "F1", chord: "F"),
      SongLine(lyrics: "let it be,", note: "C1", chord: "C"),
      SongLine(lyrics: "Whisper words,", note: "C1", chord: "C"),
      SongLine(lyrics: "of wisdom,", note: "G1", chord: "G"),
      SongLine(lyrics: "let it be,", note: "F1", chord: "F"),
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 110, 15),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Basic Guitar Songs',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: exploreItems.length,
                  itemBuilder: (context, index) {
                    final songTitle = exploreItems[index];
                    final artist = songArtist[index];
                    return GestureDetector(
                      onTap: () {
                        final songLines = songData[songTitle] ?? [];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LyricsScreen(
                              title: songTitle,
                              artist: artist,
                              songLines: songLines,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.music_note,
                              size: 60,
                              color: Color.fromARGB(245, 245, 110, 15),
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
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    artist,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 153, 153, 153),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Tap to view lyrics and chords',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ],
                              ),
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

// Lyrics screen with sing-along functionality
class LyricsScreen extends StatelessWidget {
  final String title;
  final String artist;
  final List<SongLine> songLines;

  const LyricsScreen({
    Key? key,
    required this.title,
    required this.artist,
    required this.songLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Delete any existing NoteChordController instance before putting a new one
    if (Get.isRegistered<NoteChordController>()) {
      Get.delete<NoteChordController>();
    }
    final controller = Get.put(NoteChordController(currentSong: songLines));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(247, 240, 136, 51),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            Text(
              artist,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        // Wrap main content in Center widget to center it vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center content vertically
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: songLines.map((line) {
                      return Text(
                        "${line.lyrics} - Chord: ${line.chord}",
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'Courier', height: 1.3),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (!controller.hasAudioPermission.value) {
                  return const Text("No audio permission provided");
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10.0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Lyrics:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text(
                        controller
                            .currentSong[controller.currentIndex.value].lyrics,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Expected Chord: ${controller.currentSong[controller.currentIndex.value].chord}",
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Detected Chord: ${controller.detectedChord.value}",
                        style:
                            const TextStyle(fontSize: 24, color: Colors.green),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Sing-Along controller with dynamic song data
class NoteChordController extends GetxController {
  final List<SongLine> currentSong;
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  var hasAudioPermission = false.obs;
  var currentPitch = 0.0.obs;
  var detectedChord = ''.obs; // Change from recognizedNote to detectedChord
  var currentIndex = 0.obs;

  NoteChordController({required this.currentSong});

  @override
  void onInit() {
    super.onInit();
    recordPerm();
  }

  Future<void> recordPerm() async {
    if (await Permission.microphone.request().isGranted) {
      hasAudioPermission.value = true;
      startCapture();
    }
  }

  Future<void> startCapture() async {
    await _audioRecorder.start(listener, error,
        sampleRate: 44100, bufferSize: 1400);
  }

  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();
    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      currentPitch.value = result.pitch;
      detectedChord.value = findChord(result.pitch);

      // Check if detected chord matches the expected chord
      if (detectedChord.value == currentSong[currentIndex.value].chord) {
        if (currentIndex.value < currentSong.length - 1) {
          currentIndex.value++;
        } else {
          currentIndex.value = 0; // Reset for replay
        }
      }
    }
  }

  String findChord(double frequency) {
    double minDifference = double.infinity;
    String closestNote = '';

    noteFrequencies.forEach((freq, note) {
      double difference = (frequency - freq).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestNote = note;
      }
    });

    // Convert single note to a List before passing to identifyChord
    return identifyChord([closestNote]);
  }

  void error(Object e) {
    print('Error in audio capture: $e');
  }

  @override
  void onClose() {
    _audioRecorder.stop();
    super.onClose();
  }
}

class SongLine {
  final String lyrics;
  final String note;
  final String chord; // Add chord property

  SongLine({
    required this.lyrics,
    required this.note,
    required this.chord,
  });
}

String identifyChord(List<String> notes) {
  Set<String> noteSet = notes.toSet();

  // Improved chord detection by adding more specific minor chord checks
  // Check for A major and A minor
  if (noteSet.contains('A1') || noteSet.contains('A2')) {
    return 'A'; // A minor
  } else if (noteSet.contains('A1') || noteSet.contains('A2')) {
    return 'Am';

    // Check for B major and B minor
  } else if (noteSet.contains('B1') || noteSet.contains('B2')) {
    return 'B'; // B minor
  } else if (noteSet.contains('B1') || noteSet.contains('B2')) {
    return 'Bm';

    // Check for C major and C minor
  } else if (noteSet.contains('C2') || noteSet.contains('C3')) {
    return 'C'; // C minor
  } else if (noteSet.contains('C2') || noteSet.contains('C3')) {
    return 'Cm';

    // Check for D major and D minor
  } else if (noteSet.contains('D1') || noteSet.contains('D3')) {
    return 'D'; // D minor
  } else if (noteSet.contains('D1') || noteSet.contains('D3')) {
    return 'Dm';

    // Check for E major and E minor
  } else if (noteSet.contains('E1') || noteSet.contains('E2')) {
    return 'E'; // E minor
  } else if (noteSet.contains('E1') || noteSet.contains('E2')) {
    return 'Em';

    // Check for F major and F minor
  } else if (noteSet.contains('F1') || noteSet.contains('F2')) {
    return 'F'; // F minor
  } else if (noteSet.contains('F1') || noteSet.contains('F2')) {
    return 'Fm';

    // Check for G major and G minor
  } else if (noteSet.contains('G1') || noteSet.contains('G2')) {
    return 'G'; // G minor
  } else if (noteSet.contains('G1') || noteSet.contains('G2')) {
    return 'Gm';
  } else {
    return 'N/C';
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
