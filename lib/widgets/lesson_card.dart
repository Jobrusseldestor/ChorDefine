import 'package:chordefine/constants/icons.dart';
import 'package:chordefine/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  const LessonCard({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        lesson.isPlaying
            ? Image.asset(
                'assets/icons/play.png',
                height: 45,
              )
            : Image.asset(
                'assets/icons/play_next.png',
                height: 45,
              ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                lesson.duration,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        lesson.isCompleted
            ? Image.asset(
                'assets/icons/done.png',
                height: 30,
              )
            : Image.asset(
                'assets/icons/lock.png',
                height: 30,
              ),
      ],
    );
  }
}
