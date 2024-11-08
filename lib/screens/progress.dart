import 'package:chordefine/screens/major.dart';
import 'package:chordefine/screens/minor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChordProgressController extends GetxController {
  var completedMajorChords = <String>[].obs;
  var completedMinorChords = <String>[].obs;

  void clearNotifications({required bool isMajor}) {
    if (isMajor) {
      completedMajorChords.clear();
    } else {
      completedMinorChords.clear();
    }
  }
}

class MyProgress extends StatelessWidget {
  final bool isMajor;

  const MyProgress({Key? key, required this.isMajor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChordProgressController());
    final ChordProgressController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Chords"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              controller.clearNotifications(isMajor: isMajor);
            },
          ),
        ],
      ),
      body: Obx(() {
        final completedChords = isMajor
            ? controller.completedMajorChords
            : controller.completedMinorChords;

        return completedChords.isEmpty
            ? Center(child: Text("No completed chords yet."))
            : ListView.builder(
                itemCount: completedChords.length,
                itemBuilder: (context, index) {
                  final chord = completedChords[index];
                  return ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text("Congratulations! You've completed $chord ${isMajor ? 'Major' : 'Minor'}."),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => isMajor
                  ? const PracticeScreenMajor(title: 'Major Chords')
                  : const PracticeScreenMinor(title: 'Minor Chords'),
            ),
            (Route<dynamic> route) => false,
          );
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}