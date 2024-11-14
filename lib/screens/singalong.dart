import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'dart:async';

var noteFrequencies = {
  32.7: 'C1', 34.65: '#C1', 36.71: 'D1', 38.89: '#D1', 41.2: 'E1',
  43.65: 'F1', 46.25: '#F1', 49.0: 'G1', 51.91: '#G1', 55.0: 'A1',
  58.27: '#A1', 61.74: 'B1', 65.41: 'C2', 69.3: '#C2', 73.42: 'D2',
  77.78: '#D2', 82.41: 'E2', 87.31: 'F2', 92.5: '#F2', 98.0: 'G2',
  103.83: '#G2', 110.0: 'A2', 116.54: '#A2', 123.47: 'B2', 130.81: 'C3',
  138.59: '#C3', 146.83: 'D3', 155.56: '#D3', 164.81: 'E3', 174.61: 'F3',
  185.0: '#F3', 196.0: 'G3', 207.65: '#G3', 220.0: 'A3', 233.08: '#A3',
  246.94: 'B3', 261.63: 'C4', 277.18: '#C4', 293.66: 'D4', 311.13: '#D4',
  329.63: 'E4', 349.23: 'F4', 369.99: '#F4', 392.0: 'G4', 415.3: '#G4',
  440.0: 'A4', 466.16: '#A4', 493.88: 'B4', 523.25: 'C5', 554.37: '#C5',
  587.33: 'D5', 622.25: '#D5', 659.25: 'E5', 698.46: 'F5', 739.99: '#F5',
  783.99: 'G5', 830.61: '#G5', 880.0: 'A5', 932.33: '#A5', 987.77: 'B5',
  1046.5: 'C6', 1108.73: '#C6', 1174.66: 'D6', 1244.51: '#D6', 1318.51: 'E6',
  1396.91: 'F6', 1479.98: '#F6', 1567.98: 'G6', 1661.22: '#G6', 1760.0: 'A6',
  1864.66: '#A6', 1975.53: 'B6', 2093.0: 'C7',
}; 

class SongLine {
  final String lyrics;
  final String note;
  SongLine({required this.lyrics, required this.note});
}

final List<SongLine> happyBirthdaySong = [
  SongLine(lyrics: "Happy birthday to you", note: "A1"),
  SongLine(lyrics: "Happy birthday to you", note: "A1"),
  SongLine(lyrics: "Happy birthday dear friend", note: "C2"),
  SongLine(lyrics: "Happy birthday to you!", note: "B2"),
];

class NoteChordController extends GetxController {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  var hasAudioPermission = false.obs;
  var currentPitch = 0.0.obs;
  var recognizedNote = ''.obs;
  final List<SongLine> currentSong = happyBirthdaySong;  
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    recordPerm();
  }

  recordPerm() async {
    if (await Permission.microphone.request().isGranted) {
      hasAudioPermission.value = true;
      startCapture();
    }
  }

  Future<void> startCapture() async {
    await _audioRecorder.start(listener, error, sampleRate: 44100, bufferSize: 1400);
  }

  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();
    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      currentPitch.value = result.pitch;
      recognizedNote.value = findClosestNote(result.pitch);
      if (recognizedNote.value == currentSong[currentIndex.value].note) {
        if (currentIndex.value < currentSong.length - 1) {
          currentIndex.value++;
        } else {
          currentIndex.value = 0; // Reset for replay
        }
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

  void error(Object e) {
    print('Error in audio capture: $e');
  }

  @override
  void onClose() {
    _audioRecorder.stop();
    super.onClose();
  }
}


class SingAlongScreen extends StatelessWidget {
  const SingAlongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NoteChordController());

    return Scaffold(
      appBar: AppBar(title: const Text('Sing-Along')),
      body: SafeArea(
        child: Center(
          child: Obx(() {
            if (!controller.hasAudioPermission.value) {
              return const Text("No audio permission provided");
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Lyrics:",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  controller.currentSong[controller.currentIndex.value].lyrics,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                Text(
                  "Expected Note: ${controller.currentSong[controller.currentIndex.value].note}",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                Text(
                  "Detected Note: ${controller.recognizedNote.value}",
                  style: TextStyle(fontSize: 24, color: Colors.green),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}



