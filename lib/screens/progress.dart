import 'dart:ui';
import 'package:chordefine/screens/major.dart';
import 'package:chordefine/screens/minor.dart';
import 'package:chordefine/screens/newprac.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProgress extends StatelessWidget {
  const MyProgress({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  // Initialize both Major and Minor controllers
  Get.lazyPut(() => PracticeScreenMajorController());
  Get.lazyPut(() => PracticeScreenMinorController());
  final PracticeScreenMajorController majorController = Get.find();
  final PracticeScreenMinorController minorController = Get.find();

  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      flexibleSpace: Stack(
        children: [
          _buildGlassMorphicAppBar(),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Completed Chords",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              onPressed: () {
                majorController.clearNotifications();
                minorController.clearNotifications();
              },
            ),
          ),
        ],
      ),
    ),
    body: Stack(
      children: [
        _buildGlassMorphicBackground(),
        Column(
          children: [
            Expanded(
              child: Obx(() {
                // Get completed chords from both controllers
                final majorChords = majorController.completedChords.toList();
                final minorChords = minorController.completedChords.toList();

                if (majorChords.isEmpty && minorChords.isEmpty) {
                  return const Center(
                      child: Text("No completed chords yet."));
                }

                return ListView(
                  children: [
                    if (majorChords.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Major Chords",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var chord in majorChords)
                        ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: Text(
                            "Congratulations! You've completed $chord Major.",
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                    if (minorChords.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Minor Chords",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var chord in minorChords)
                        ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: Text(
                            "Congratulations! You've completed $chord Minor.",
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
        // Replace FloatingActionButton with Positioned ElevatedButton
        Positioned(
          bottom: 80, // Adjust to control vertical position
          right: 10,  // Adjust to control horizontal position
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => pracnew(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 247, 228, 200),
              shape: CircleBorder(),
              padding: EdgeInsets.all(16),
            ),
            child: const Icon(Icons.arrow_back, color:Color.fromARGB(247, 194, 89, 4)),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildGlassMorphicAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(20), right: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color.fromARGB(247, 194, 89, 4).withOpacity(0.2),
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20)),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassMorphicBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(247, 194, 89, 4).withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
