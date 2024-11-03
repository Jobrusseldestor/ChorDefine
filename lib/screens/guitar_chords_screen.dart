import 'package:flutter/material.dart';

class GuitarChordsScreen extends StatelessWidget {
  const GuitarChordsScreen({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Guitar Chords'),automaticallyImplyLeading: false,
      ),
      body: const SingleChildScrollView( // Wrap the body in SingleChildScrollView to prevent overflow
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
              SizedBox(height: 20),
              // Displaying A-G Major chords in alphabetical order
              ChordInfo(
                chordName: 'A Major',
                description: 'A Major is a bright, open-sounding chord used in many genres, especially in pop and rock.',
                imagePath: 'assets/pics/amj.png', // Replace with actual asset path
              ),
              ChordInfo(
                chordName: 'B Major',
                description: 'B Major is a bit harder to play due to its barre position, but essential for songs in major keys.',
                imagePath: 'assets/pics/b.png',
              ),
              ChordInfo(
                chordName: 'C Major',
                description: 'C Major is one of the most fundamental chords in guitar, used in various styles of music.',
                imagePath: 'assets/pics/c.png',
              ),
              ChordInfo(
                chordName: 'D Major',
                description: 'D Major is a high-pitched chord that fits well in folk, pop, and rock songs, easy to transition into.',
                imagePath: 'assets/pics/d.png',
              ),
              ChordInfo(
                chordName: 'E Major',
                description: 'E Major is powerful and resonant, forming the basis for many classic rock and blues tunes.',
                imagePath: 'assets/pics/e.png',
              ),
              ChordInfo(
                chordName: 'F Major',
                description: 'F Major requires a barre, making it a challenge for beginners, but it’s crucial for many genres.',
                imagePath: 'assets/pics/f.png',
              ),
              ChordInfo(
                chordName: 'G Major',
                description: 'G Major is one of the first chords beginners learn, offering a full, rich sound perfect for many styles.',
                imagePath: 'assets/pics/g.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChordInfo extends StatelessWidget {
  final String chordName;
  final String description;
  final String imagePath;

  const ChordInfo({
    Key? key,
    required this.chordName,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chordName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
