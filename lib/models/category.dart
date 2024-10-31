import 'package:chordefine/screens/course_screen.dart';
import 'package:chordefine/screens/course_screen2.dart';
import 'package:chordefine/screens/course_screen3.dart';
import 'package:chordefine/screens/course_screen4.dart';
import 'package:chordefine/screens/practicescreen.dart';
import 'package:flutter/material.dart';

class Category {
  String thumbnail;
  String name;
  int noOfCourses;
  Widget destinationScreen;

  Category({
    required this.name,
    required this.noOfCourses,
    required this.thumbnail,
    required this.destinationScreen,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Learn',
    noOfCourses: 55,
    thumbnail: 'assets/pics/learn.png',
    destinationScreen: const CourseScreen(),
  ),
  Category(
    name: 'Practice',
    noOfCourses: 20,
    thumbnail: 'assets/pics/practice.png',
    destinationScreen: const PracticeScreen(),
  ),
  Category(
    name: 'Explore',
    noOfCourses: 16,
    thumbnail: 'assets/pics/explore.png',
    destinationScreen: const CourseScreen3(),
  ),
  Category(
    name: 'Tuner',
    noOfCourses: 25,
    thumbnail: 'assets/pics/tuner.png',
    destinationScreen: const TunerScreen(),
  ),
];
