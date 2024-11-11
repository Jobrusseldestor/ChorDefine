import 'package:flutter/material.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';

class ChordLibraryScreen extends StatefulWidget {
  const ChordLibraryScreen({Key? key}) : super(key: key);

  @override
  _ChordLibraryScreenState createState() => _ChordLibraryScreenState();
}

class _ChordLibraryScreenState extends State<ChordLibraryScreen> {
  final Map<String, List<Map<String, String>>> chordCategories = {
    'A': [
      {'frets': '0 0 2 2 2 0', 'fingers': 'x 0 1 2 3 0', 'chordName': 'A Major'},
      {'frets': '0 0 2 2 1 0', 'fingers': 'X 0 2 3 1 0', 'chordName': 'A Minor'},
      {'frets': '0 0 2 0 2 0', 'fingers': 'X 0 2 0 3 0', 'chordName': 'A7'},
      {'frets': '0 0 2 1 2 0', 'fingers': 'X 0 2 1 3 0', 'chordName': 'A Major 7'},
      {'frets': '0 0 2 0 1 0', 'fingers': 'x 0 2 0 1 0', 'chordName': 'A Minor 7'},
    ],
    'B': [
      {'frets': '0 2 4 4 4 2', 'fingers': 'x 1 2 3 4 1', 'chordName': 'B Major'},
      {'frets': '0 2 4 4 3 2', 'fingers': 'x 1 3 4 2 1', 'chordName': 'B Minor'},
      {'frets': '0 2 1 2 0 0', 'fingers': 'x 2 1 3 0 0', 'chordName': 'B7'},
      {'frets': '0 2 0 2 0 2', 'fingers': 'x 2 0 3 0 4', 'chordName': 'B Minor 7'},
    ],
    'C': [
      {'frets': '0 3 2 0 1 0', 'fingers': 'x 3 2 0 1 0', 'chordName': 'C Major'},
      {'frets': '0 3 2 3 1 0', 'fingers': 'X 3 2 4 1 0', 'chordName': 'C7'},
      {'frets': '0 3 2 0 0 0', 'fingers': 'X 3 2 0 0 0', 'chordName': 'C Major 7'},
    ],
    'D': [
      {'frets': '0 0 0 2 3 2', 'fingers': 'x x 0 1 3 2', 'chordName': 'D Major'},
      {'frets': '0 0 0 2 3 1', 'fingers': 'X x 0 2 3 1', 'chordName': 'D Minor'},
      {'frets': '0 0 0 2 1 2', 'fingers': 'X x 0 2 1 3', 'chordName': 'D7'},
    ],
    'E': [
      {'frets': '0 2 2 1 0 0', 'fingers': '0 2 3 1 0 0', 'chordName': 'E Major'},
      {'frets': '0 2 2 0 0 0', 'fingers': '0 1 2 0 0 0', 'chordName': 'E Minor'},
      {'frets': '0 2 0 1 0 0', 'fingers': '0 2 0 1 0 0', 'chordName': 'E7'},
      {'frets': '0 2 1 1 0 0', 'fingers': '0 3 2 1 0 0', 'chordName': 'E Major 7'},
      {'frets': '0 2 0 0 0 0', 'fingers': '0 1 0 0 0 0', 'chordName': 'E Minor 7'},
    ],
    'F': [
      {'frets': '1 3 3 2 1 1', 'fingers': '1 3 4 2 1 1', 'chordName': 'F Major'},
      {'frets': '1 3 3 1 1 1', 'fingers': '1 3 4 1 1 1', 'chordName': 'F Minor'},
      {'frets': '1 3 1 2 1 1', 'fingers': '1 3 1 2 1 1', 'chordName': 'F7'},
      {'frets': '0 3 2 0 0 0', 'fingers': 'X 3 2 0 0 0', 'chordName': 'F Major 7'},
      {'frets': '0 3 5 3 4 3', 'fingers': 'X 1 3 1 2 1', 'chordName': 'F Minor 7'},
    ],
    'G': [
      {'frets': '3 2 0 0 0 3', 'fingers': '3 2 0 0 0 4', 'chordName': 'G Major'},
      {'frets': '3 1 0 0 0 3', 'fingers': '3 1 0 0 0 4', 'chordName': 'G Minor'},
      {'frets': '3 2 0 0 0 1', 'fingers': '3 2 0 0 0 1', 'chordName': 'G7'},
      {'frets': '3 2 0 0 0 2', 'fingers': '3 2 0 0 0 2', 'chordName': 'G Major 7'},
      {'frets': '3 1 0 0 0 1', 'fingers': '3 1 0 0 0 1', 'chordName': 'G Minor 7'},
    ],
  };

  /// Converts frets data into a readable string, replacing 'X' or '-1' with 'X' for muted strings.
  String parseFrets(String frets) {
    return frets.replaceAll('x', 'X').replaceAll('-1', 'X');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Center(
        child: Text('Chord Library', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
      ),
      automaticallyImplyLeading: false,
    ),
      body: Column(
        children: [
          // Dropdown for instrument selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
               
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: chordCategories.entries.map((entry) {
                String category = entry.key;
                List<Map<String, String>> chords = entry.value;

                return ExpansionTile(
                  title: Text('$category Chords'),
                  children: [
                    GridView.builder(
                      shrinkWrap: true, // Ensures the grid only takes the necessary height
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: chords.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Display 2 chords per row
                        childAspectRatio: 0.7, // Controls the height-to-width ratio for compact layout
                      ),
                      itemBuilder: (context, index) {
                        Map<String, String> chord = chords[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0), // Adds spacing around the chord
                          child: FlutterGuitarChord(
                            frets: parseFrets(chord['frets']!), // Ensure frets are passed as a string
                            fingers: chord['fingers']!, // Fingers as a string
                            baseFret: 1,
                            chordName: chord['chordName']!,
                          ),
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const ChordLibraryScreen(),
  ));
}
