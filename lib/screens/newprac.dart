import 'package:chordefine/models/chords.dart';
import 'package:chordefine/screens/major.dart';
import 'package:chordefine/screens/minor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class pracnew extends StatefulWidget {
  const pracnew({Key? key}) : super(key: key);

  @override
  _pracnewState createState() => _pracnewState();
}

class _pracnewState extends State<pracnew> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(245, 245, 110, 15),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Stack(
                    children: [
                      Align(
                        child: Text(
                          'Chords',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold, // Set the font weight
                                color: Colors.white, // Set the desired color
                                fontSize: 35, // Adjust font size if needed
                                // Set a custom font family if desired
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 10);
                    },
                    shrinkWrap: true,
                    itemBuilder: (_, int index) {
                      return praccontainer(
                        chord: chords[index],
                      );
                    },
                    itemCount: chords.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class praccontainer extends StatelessWidget {
  final chor chord;
  const praccontainer({
    Key? key,
    required this.chord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (chord.name == 'Major Chords') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const PracticeScreenMajor(title: 'Major Chords'),
            ),
          );
        } else if (chord.name == 'Minor Chords') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const PracticeScreenMinor(title: 'Minor Chords'),
            ),
          );
        }
      },
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 255, 251, 247),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                chord.thumbnail,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chord.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chord.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
