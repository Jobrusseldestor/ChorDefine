import 'package:chordefine/constants/color.dart';
import 'package:chordefine/models/course.dart';
import 'package:chordefine/screens/chord_diagram_screen.dart';
import 'package:chordefine/screens/chord_library_screen.dart';
import 'package:chordefine/screens/details_screen.dart';
import 'package:chordefine/screens/ear_trainer_screen.dart';
import 'package:chordefine/screens/guitar_chords_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
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
                          'Learn',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: CustomIconButton(
                          child: const Icon(Icons.arrow_back),
                          height: 35,
                          width: 35,
                          onTap: () => Navigator.pop(context),
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
                      return CourseContainer(
                        course: courses[index],
                      );
                    },
                    itemCount: courses.length,
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

class CourseContainer extends StatelessWidget {
  final Course course;
  const CourseContainer({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Check the course name to navigate to the correct screen
        if (course.name == 'Learn Basic Chords') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GuitarChordsScreen(title: 'course.name'),
            ),
          );
        } else if (course.name == 'Chord Library') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChordLibraryScreen(),
            ),
          );
        } else if (course.name == 'Ear Trainer') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EarTrainerScreen(),
            ),
          );
        } else if (course.name == 'Chord Diagram') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChordDiagramScreen(),
            ),
          );
        }
      },
      child: Container(
        // Adjust the height for better fit
        height: 170, // Increase height for larger touch area
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                course.thumbnail,
                height: 60,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    course.name,
                    style: const TextStyle(
                      fontSize: 25, // Adjust font size here
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Author: ${course.author}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14), // Adjust author font size
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: course.completedPercentage,
                    backgroundColor: Colors.black12,
                    color: kPrimaryColor,
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
