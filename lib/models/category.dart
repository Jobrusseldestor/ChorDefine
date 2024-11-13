import 'package:chordefine/screens/learnscreen.dart';
import 'package:chordefine/screens/lyricspage.dart';
import 'package:chordefine/screens/newprac.dart';
import 'package:chordefine/screens/tunerscreen.dart';
import 'package:flutter/material.dart';

class Category {
  String thumbnail;
  String name;
  Widget destinationScreen;
  String definition;

  Category({
    required this.name,
    required this.thumbnail,
    required this.destinationScreen,
    required this.definition,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Learn',
    definition: 'Get familiar with the basic concepts of chords.',
    thumbnail: 'assets/pics/learnlogo.png',
    destinationScreen: const CourseScreen(),
  ),
  Category(
    name: 'Practice',
    definition: ' Practice the chords through computer vision and sound detection.',
    thumbnail: 'assets/pics/practicelogo.png',
    destinationScreen: const pracnew(),
  ),
  Category(
    name: 'Explore',
    definition: 'Explore and jam along with your favorite songs.',
    thumbnail: 'assets/pics/explorelogo.png',
    destinationScreen: const CourseScreen3(),
  ),
  Category(
    name: 'Tuner',
    definition: 'Set up your guitar to tune.',
    thumbnail: 'assets/pics/tunerlogo.png',
    destinationScreen: const TunerScreen(),
  ),
];
