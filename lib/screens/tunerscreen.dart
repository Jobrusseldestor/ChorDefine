import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';


const midGreyColor = Color.fromARGB(247, 255, 255, 255);

const blackGreyColor = Color.fromARGB(247, 255, 255, 255);

// Text Styles
const styleGreenSmall = TextStyle(color: Colors.green, fontSize: 13);
const styleBlackSmall = TextStyle(color: Colors.white, fontSize: 13);
const styleBlackMedium = TextStyle(color: Colors.white, fontSize: 16);
const styleWhiteSmall = TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 13);
const styleWhiteMedium = TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16);
const styleWhiteBig =
    TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 32, fontWeight: FontWeight.bold);

// Tuner Controller
class TunerController extends GetxController {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);

  final maxRange = 25;
  final maxToTune = 3;

  var hasAudioPermission = false.obs;
  var currentPitch = 0.0.obs;
  var pitchToCompare = 0.0.obs;
  var isInRange = false.obs;
  var isTuned = false.obs;
  var selectedTune = "".obs;

  RxDouble markerPositionX = 0.0.obs;

  var chordsFrecuency = [
    329.63, // E4
    246.94, // B3
    196.00, // G3
    146.83, // D3
    110.00, // A2
    82.41,  // E2
  ];

  @override
  void onInit() {
    super.onInit();
    Wakelock.enable();
    recordPerm();
  }

  void selectChord(chordIndex, tuneChord) {
    pitchToCompare.value = chordsFrecuency[chordIndex];
    selectedTune.value = tuneChord;
  }

  void compareWithPitch() {
    if (currentPitch.value >= (pitchToCompare.value - maxRange) &&
        currentPitch.value <= (pitchToCompare.value + maxRange)) {
      isInRange.value = true;
      markerPositionX.value =
          (((currentPitch.value - pitchToCompare.value) * 3) + 100).toDouble();
    } else {
      isInRange.value = false;
      markerPositionX.value = currentPitch.value > (pitchToCompare.value + maxRange)
          ? 180.0 - 24
          : 24;
    }

    isTuned.value = currentPitch.value > (pitchToCompare.value - maxToTune) &&
                    currentPitch.value < (pitchToCompare.value + maxToTune);
  }

  recordPerm() async {
    if (await Permission.microphone.request().isGranted) {
      hasAudioPermission.value = true;
      startCapture();
    }
  }

  Future<void> startCapture() async {
    await _audioRecorder.start(listener, error,
        sampleRate: 44100, bufferSize: 3000);
  }

  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();
    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      currentPitch.value = result.pitch;
      compareWithPitch();
    }
  }

  void error(Object e) {
    // Handle error
  }
}

// Vertical Line Painter
class VerticalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color.fromARGB(245, 245, 110, 15)
      ..strokeWidth = 2;

    final double centerX = size.width / 2;
    const double startY = 0;
    final double endY = size.height;

    canvas.drawLine(
      Offset(centerX, startY),
      Offset(centerX, endY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Tuner Marker
class TunerMarker extends StatelessWidget {
  const TunerMarker({super.key});

  @override
  Widget build(BuildContext context) {
    var tunerController = Get.find<TunerController>();

    return SizedBox(
      width: 200,
      height: 130,
      child: Stack(
        children: [
          Obx(
            () => AnimatedPositioned(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 300),
              left: tunerController.markerPositionX.value - (48 / 2),
              top: 50.0,
              child: Column(
                children: [
                  Icon(
                    Icons.location_on,
                    color: tunerController.isTuned.value
                        ? Colors.green
                        : Colors.black,
                    size: 48.0,
                    semanticLabel: 'Guitar Tuner',
                  ),
                  Text(
                    tunerController.currentPitch.value.toStringAsFixed(2),
                    style: styleWhiteSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Guitar Button
class GuitarButton extends StatelessWidget {
  final Color chordColor;
  final int chordIndex;
  final String chordText;

  const GuitarButton({
    super.key,
    required this.chordColor,
    required this.chordIndex,
    required this.chordText,
  });

  @override
  Widget build(BuildContext context) {
    var tunerController = Get.find<TunerController>();

    return Obx(() => OutlinedButton(
          style: ButtonStyle(
            fixedSize: const MaterialStatePropertyAll(Size(70, 70)),
            side: MaterialStateProperty.all(
              BorderSide(color: chordColor, width: 2),
            ),
            backgroundColor: tunerController.selectedTune.value == chordText
                ? MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0))
                : MaterialStateProperty.all<Color>(const Color.fromARGB(245, 245, 110, 15)),
          ),
          onPressed: () => tunerController.selectChord(chordIndex, chordText),
          child: Text(
            chordText,
            style: tunerController.selectedTune.value == chordText
                ? styleBlackMedium
                : styleWhiteMedium,
          ),
        ));
  }
}

// Tuner Screen
// Tuner Screen
class TunerScreen extends StatelessWidget {
  const TunerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tunerController = Get.put(TunerController());

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
                // Back Button
                
                const SizedBox(height: 15),
                Expanded(
                  child: Center(
                    child: Obx(
                      () => tunerController.hasAudioPermission.value
                          ? Container(
                              width: double.infinity,
                              color: blackGreyColor,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: CustomPaint(
                                      painter: VerticalLinePainter(),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text(
                                            tunerController.selectedTune.value == ""
                                                ? "Select string..."
                                                : tunerController.selectedTune.value,
                                            style: styleWhiteBig,
                                          ),
                                        ),
                                        Text(
                                          tunerController.pitchToCompare.value.toString(),
                                          style: styleWhiteSmall,
                                        ),
                                        tunerController.selectedTune.value == ""
                                            ? Container()
                                            : const TunerMarker(),
                                        tunerController.isTuned.value
                                            ? const Text(
                                                "Tuned",
                                                style: styleGreenSmall,
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              color: blackGreyColor,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/mute.png',
                                      width: double.infinity,
                                      height: 100,
                                    ),
                                    const Text(
                                      "No audio permission provided",
                                      style: styleWhiteMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    color: midGreyColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GuitarButton(
                                  chordColor: Colors.black,
                                  chordIndex: 3,
                                  chordText: "D3"),
                              GuitarButton(
                                  chordColor: Colors.black,
                                  chordIndex: 4,
                                  chordText: "A2"),
                              GuitarButton(
                                  chordColor: Colors.black,
                                  chordIndex: 5,
                                  chordText: "E2"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/images/guitar.png',
                                width: double.infinity,
                                height: 350,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GuitarButton(
                                  chordColor: Colors.black,
                                  chordIndex: 2,
                                  chordText: "G3"),
                              GuitarButton(
                                  chordColor: Colors.black,
                                  chordIndex: 1,
                                  chordText: "B3"),
                              GuitarButton(
                                  chordColor: Colors.black,
                                  chordIndex: 0,
                                  chordText: "E4"),
                            ],
                          ),
                        ),
                      ],
                    ),
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