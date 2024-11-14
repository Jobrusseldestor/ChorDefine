import 'package:flutter/material.dart';

class GuitarChordsScreen extends StatelessWidget {
  const GuitarChordsScreen({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Basic Guitar Chords',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // Displaying each chord inside a decorated container
              ChordBox(
                chordName: 'A Major',
                description:
                    'A Major is a bright, open-sounding chord used in many genres, especially in pop and rock.',
                imagePath: 'assets/picture/17.png',
              ),
              SizedBox(height: 16),
              ChordBox(
                chordName: 'B Major',
                description:
                    'B Major is a bit harder to play due to its barre position, but essential for songs in major keys.',
                imagePath: 'assets/picture/19.png',
              ),
              SizedBox(height: 16),
              ChordBox(
                chordName: 'C Major',
                description:
                    'C Major is one of the most fundamental chords in guitar, used in various styles of music.',
                imagePath: 'assets/picture/20.png',
              ),
              SizedBox(height: 16),
              ChordBox(
                chordName: 'D Major',
                description:
                    'D Major is a high-pitched chord that fits well in folk, pop, and rock songs, easy to transition into.',
                imagePath: 'assets/picture/21.png',
              ),
              SizedBox(height: 16),
              ChordBox(
                chordName: 'E Major',
                description:
                    'E Major is powerful and resonant, forming the basis for many classic rock and blues tunes.',
                imagePath: 'assets/picture/22.png',
              ),
              SizedBox(height: 16),
              ChordBox(
                chordName: 'F Major',
                description:
                    'F Major requires a barre, making it a challenge for beginners, but it’s crucial for many genres.',
                imagePath: 'assets/picture/23.png',
              ),
              SizedBox(height: 16),
              ChordBox(
                chordName: 'G Major',
                description:
                    'G Major is one of the first chords beginners learn, offering a full, rich sound perfect for many styles.',
                imagePath: 'assets/picture/24.png',
              ),
              ChordBox(
                chordName: 'A Minor',
                description:
                    'A Minor has a moody, somber tone and is often used to convey emotion in various genres.',
                imagePath: 'assets/picture/14.png',
              ),
              ChordBox(
                chordName: 'B Minor',
                description:
                    'B Minor is often found in ballads and blues, adding depth and warmth to a song’s feel.',
                imagePath: 'assets/picture/14.png',
              ),
              ChordBox(
                chordName: 'C Minor',
                description:
                    'C Minor evokes a dramatic, introspective sound, frequently appearing in rock and classical music.',
                imagePath: 'assets/picture/cminor1.jpg',
              ),
              ChordBox(
                chordName: 'D Minor',
                description:
                    'D Minor has a dark, melancholic sound, often used in folk and classical music to convey sadness.',
                imagePath: 'assets/picture/15.png',
              ),
              ChordBox(
                chordName: 'E Minor',
                description:
                    'E Minor is one of the most popular minor chords, known for its versatility and moody sound.',
                imagePath: 'assets/picture/16.png',
              ),
              ChordBox(
                chordName: 'F Minor',
                description:
                    'F Minor brings a deep, rich quality to music, commonly used in soul and pop for its emotional resonance.',
                imagePath: 'assets/picture/fminor1.jpg',
              ),
              ChordBox(
                chordName: 'G Minor',
                description:
                    'G Minor has a mysterious, evocative tone, popular in both classical compositions and modern genres.',
                imagePath: 'assets/picture/gminor1.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Define ChordBox widget to display each chord info in a box with rounded border
class ChordBox extends StatelessWidget {
  final String chordName;
  final String description;
  final String imagePath;

  const ChordBox({
    Key? key,
    required this.chordName,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Add consistent spacing
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(150, 245, 110, 15),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              height: 120,
              width: 98,
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

