import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers package

class EarTrainerScreen extends StatefulWidget {
  const EarTrainerScreen({Key? key}) : super(key: key);

  @override
  _EarTrainerScreenState createState() => _EarTrainerScreenState();
}

class _EarTrainerScreenState extends State<EarTrainerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Function to play audio from assets
  void _playAudio(String fileName) async {
    await _audioPlayer.play(AssetSource('audio/$fileName'));
  }

  // List of wav files corresponding to the boxes
  final List<String> wavFiles = [
    'a.wav',
    'am.wav',
    'b.wav',
    'bm.wav',
    'c.wav',
    'cm.wav',
    'd.wav',
    'dm.wav',
    'e.wav',
    'em.wav',
    'f.wav',
    'fm.wav',
    'g.wav',
    'gm.wav',
  ];

  // List of labels for each box
  final List<String> labels = [
    'A Major',
    'A Minor',
    'B Major',
    'B Minor',
    'C Major',
    'C Minor',
    'D Major',
    'D Minor',
    'E Major',
    'E Minor',
    'F Major',
    'F Minor',
    'G Major',
    'G Minor',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Ear Trainer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 3 boxes per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 14, // 7 clickable boxes
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Play specific audio based on index
              _playAudio(wavFiles[index]);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(245, 245, 110, 15),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5), // Shadow position
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.music_note,
                      size: 40,
                      color: Color.fromARGB(247, 255, 255, 255),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      labels[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose the player when done
    super.dispose();
  }
}
