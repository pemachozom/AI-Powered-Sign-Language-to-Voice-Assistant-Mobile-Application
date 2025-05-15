import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  final Map<String, dynamic> token;

  const CameraPage({Key? key, required this.token}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> cameras;
  late CameraController? cameraController;
  bool isCameraInitialized = false;
  int direction =
      0; // 0 represents the back camera, 1 represents the front camera
  XFile? videoFile;
  bool isRecording = false;
  Timer? _timer;
  int _startRecordingTime = 0;
  bool _loading = false;
  String? predictedClass;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startCamera(direction);
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isCameraInitialized = true;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void toggleCamera() {
    direction = 1 - direction; // Toggle between 0 and 1
    cameraController!.dispose(); // Dispose the current controller
    startCamera(direction); // Initialize the camera with the new direction
  }

  void toggleRecording() {
    if (!isRecording) {
      startRecording();
    } else {
      stopRecording();
    }
  }

  void startRecording() async {
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        await cameraController!.startVideoRecording();
        _startRecordingTime = DateTime.now().millisecondsSinceEpoch;
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {});
        });
        setState(() {
          isRecording = true;
        });
      } else {
        // If camera controller is not initialized, re-initialize it
        startCamera(direction);
      }
    } catch (e) {
      print(e);
    }
  }

  void stopRecording() async {
    if (cameraController != null && cameraController!.value.isRecordingVideo) {
      await cameraController!.stopVideoRecording().then((value) async {
        setState(() {
          videoFile = value;
          isRecording = false;
          _timer?.cancel();
        });
        if (videoFile != null) {
          showLoadingDialog(); // Show loading dialog
          var response = await sendVideoToApi(videoFile!);
          Navigator.of(context).pop(); // Hide loading dialog
          var responseBody = jsonDecode(response.body)['predicted_class'];
          setState(() {
            predictedClass = responseBody;
          });
          await playPredictedClassAudio(responseBody);
        }
      });
    }
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }

  Future<http.Response> sendVideoToApi(XFile videoFile) async {
    setState(() {
      _loading = true; // Set loading to true when request starts
    });

    // final apiUrl = 'http://10.9.90.205:5001/predict';
    final apiUrl = 'http://172.16.21.159:5001/predict';

    List<int> videoBytes = await videoFile.readAsBytes();
    String base64Video = base64Encode(videoBytes);

    try {
      var response = await http.post(Uri.parse(apiUrl), body: {
        'video': base64Video,
      });
      return response;
    } catch (e) {
      print('Exception while uploading video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network Error. Please try again'),
        ),
      );
      throw e;
    } finally {
      setState(() {
        _loading = false; // Set loading to false when request completes
      });
    }
  }

  Future<void> playPredictedClassAudio(String predictedClass) async {
    String audioPath = 'mainvoices/$predictedClass.mp3';
    await audioPlayer.play(AssetSource(audioPath));
  }

  String getRecordingTime() {
    if (_startRecordingTime == 0) {
      return '00:00';
    }
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int elapsedTimeInSeconds = (currentTime - _startRecordingTime) ~/ 1000;
    int minutes = elapsedTimeInSeconds ~/ 60;
    int seconds = elapsedTimeInSeconds % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr = (seconds < 10) ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 10,
            child: Image.asset(
              'assets/images/dragon.png',
              height: screenHeight * 0.09,
            ),
          ),
          const Positioned(
            left: 128,
            top: 80,
            child: Text(
              "GESTUREFY",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: Image.asset(
              'assets/images/dragon2.png',
              height: screenHeight * 0.09,
            ),
          ),
          Positioned(
            left: 55,
            top: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                isCameraInitialized
                    ? SizedBox(
                        height: screenHeight * 0.5728689275893676,
                        width: screenWidth * 0.7637474541751527,
                        child: Stack(
                          children: [
                            CameraPreview(
                              cameraController!,
                            ), // Display CameraPreview
                            Positioned(
                              top: -10,
                              left: 0,
                              child: SizedBox(
                                width: screenWidth * 0.2036659877800407,
                                height: screenHeight * 0.1145737855178735,
                                child: Image.asset(
                                    'assets/images/cameraborder1.png'),
                              ),
                            ),
                            Positioned(
                              top: -10,
                              right: 20,
                              child: SizedBox(
                                width: screenWidth * 0.2036659877800407,
                                height: screenHeight * 0.1145737855178735,
                                child: Image.asset(
                                    'assets/images/cameraborder2.png'),
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 1,
                              child: SizedBox(
                                width: screenWidth * 0.2036659877800407,
                                height: screenHeight * 0.1145737855178735,
                                child: Image.asset(
                                    'assets/images/cameraborder4.png'),
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              right: 20,
                              child: SizedBox(
                                width: screenWidth * 0.2036659877800407,
                                height: screenHeight * 0.1145737855178735,
                                child: Image.asset(
                                    'assets/images/cameraborder3.png'),
                              ),
                            ),
                          ],
                        ),
                      )
                    // Display CameraPreview if camera is initialized
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                // Display loading indicator while camera is initializing
              ],
            ),
          ),
          if (isRecording)
            Positioned(
              // bottom: screenHeight * 0.5,
              top: screenHeight * 0.82,
              left: screenWidth * 0.5 - 30, // Center horizontally
              child: Text(
                getRecordingTime(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.5 - 140, // Center horizontally
            child: FloatingActionButton(
              onPressed: toggleRecording,
              backgroundColor: const Color.fromRGBO(3, 77, 126, 1),
              child: Icon(
                isRecording ? Icons.stop : Icons.videocam,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.5 + 80, // Adjusted to avoid overlap
            child: FloatingActionButton(
              onPressed: toggleCamera,
              backgroundColor: const Color.fromRGBO(3, 77, 126, 1),
              child: const Icon(
                Icons.switch_camera,
                color: Colors.white,
              ),
            ),
          ),
          if (predictedClass != null)
            Positioned(
              top: screenHeight * 0.72,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              // child: Container(
              //   padding: EdgeInsets.all(10), // Add padding to the container
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.white, // Set the border color
              //       width: 2, // Set the border width
              //     ),
              //     borderRadius: BorderRadius.circular(10), // Add border radius
              //   ),
              child: Text(
                predictedClass!,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
    );
  }
}
