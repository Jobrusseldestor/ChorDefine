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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Displaying each chord inside a decorated container
              ChordBox(
                chordName: 'A Major',
                description:
                    'A Major is a bright, open-sounding chord used in many genres, especially in pop and rock.',
                imagePath: 'assets/pics/amj.png',
                
              ),
              const SizedBox(height: 16),
              ChordBox(
                chordName: 'B Major',
                description:
                    'B Major is a bit harder to play due to its barre position, but essential for songs in major keys.',
                imagePath: 'assets/pics/b.png',
              ),
              const SizedBox(height: 16),
              ChordBox(
                chordName: 'C Major',
                description:
                    'C Major is one of the most fundamental chords in guitar, used in various styles of music.',
                imagePath: 'assets/pics/c.png',
              ),
              const SizedBox(height: 16),
              ChordBox(
                chordName: 'D Major',
                description:
                    'D Major is a high-pitched chord that fits well in folk, pop, and rock songs, easy to transition into.',
                imagePath: 'assets/pics/d.png',
              ),
              const SizedBox(height: 16),
              ChordBox(
                chordName: 'E Major',
                description:
                    'E Major is powerful and resonant, forming the basis for many classic rock and blues tunes.',
                imagePath: 'assets/pics/e.png',
              ),
              const SizedBox(height: 16),
              ChordBox(
                chordName: 'F Major',
                description:
                    'F Major requires a barre, making it a challenge for beginners, but it’s crucial for many genres.',
                imagePath: 'assets/pics/f.png',
              ),
              const SizedBox(height: 16),
              ChordBox(
                chordName: 'G Major',
                description:
                    'G Major is one of the first chords beginners learn, offering a full, rich sound perfect for many styles.',
                imagePath: 'assets/pics/g.png',
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(247, 194, 89, 4).withOpacity(0.2),
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
                const SizedBox(height: 8),
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