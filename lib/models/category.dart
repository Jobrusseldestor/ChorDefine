import 'package:chordefine/screens/course_screen.dart';
import 'package:chordefine/screens/audiodetect.dart';
import 'package:chordefine/screens/course_screen3.dart';
import 'package:chordefine/screens/course_screen4.dart';
import 'package:chordefine/screens/practicescreen.dart';
import 'package:flutter/material.dart';

class Category {
  String thumbnail;
  String name;
  Widget destinationScreen;

  Category({
    required this.name,
    required this.thumbnail,
    required this.destinationScreen,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Learn',
    thumbnail: 'assets/pics/learn.png',
    destinationScreen: const CourseScreen(),
  ),
  Category(
    name: 'Practice',
    thumbnail: 'assets/pics/practice.png',
    destinationScreen: const PracticeScreen(),
  ),
  Category(
    name: 'Explore',
    thumbnail: 'assets/pics/explore.png',
    destinationScreen: const CourseScreen3(),
  ),
  Category(
    name: 'Tuner',
    thumbnail: 'assets/pics/tuner.png',
    destinationScreen: const TunerScreen(),
  ),
];
