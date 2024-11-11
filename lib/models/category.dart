import 'package:chordefine/screens/learnscreen.dart';
import 'package:chordefine/screens/lyricspage.dart';
import 'package:chordefine/screens/newprac.dart';
import 'package:chordefine/screens/tunerscreen.dart';
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
    thumbnail: 'assets/pics/learnlogo.png',
    destinationScreen: const CourseScreen(),
  ),
  Category(
    name: 'Practice',
    thumbnail: 'assets/pics/practicelogo.png',
    destinationScreen: const pracnew(),
  ),
  Category(
    name: 'Explore',
    thumbnail: 'assets/pics/explorelogo.png',
    destinationScreen: const CourseScreen3(),
  ),
  Category(
    name: 'Tuner',
    thumbnail: 'assets/pics/tunerlogo.png',
    destinationScreen: const TunerScreen(),
  ),
];
