import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class DzongkhaTranslation extends StatefulWidget {
  final Map<String, dynamic> token;

  const DzongkhaTranslation({Key? key, required this.token}) : super(key: key);

  @override
  State<DzongkhaTranslation> createState() => _DzongkhaTranslationState();
}

class _DzongkhaTranslationState extends State<DzongkhaTranslation> {
  late List<CameraDescription> cameras;
  late CameraController? cameraController;
  bool isCameraInitialized = false;
  int direction =
      0; // 0 represents the back camera, 1 represents the front camera
  XFile? imageFile;
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
    super.dispose();
  }

  void toggleCamera() {
    direction = 1 - direction; // Toggle between 0 and 1
    cameraController!.dispose(); // Dispose the current controller
    startCamera(direction); // Initialize the camera with the new direction
  }

  void captureImage() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        imageFile = await cameraController!.takePicture();
        if (imageFile != null) {
          showLoadingDialog(); // Show loading dialog
          var response = await sendImageToApi(imageFile!);
          Navigator.of(context).pop(); // Hide loading dialog
          var responseBody = jsonDecode(response.body)['predicted_class'];
          setState(() {
            predictedClass = responseBody;
          });
          await playPredictedClassAudio(responseBody);
        }
      } catch (e) {
        print(e);
      }
    } else {
      // If camera controller is not initialized, re-initialize it
      startCamera(direction);
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

  Future<http.Response> sendImageToApi(XFile imageFile) async {
    setState(() {
      _loading = true; // Set loading to true when request starts
    });

    // final apiUrl = 'http://10.9.90.205:5004/predict';
    // final apiUrl = 'http://192.168.1.48:5004/predict';
    final apiUrl = 'http://192.168.47.115:5004/predict';

    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    try {
      var response = await http.post(Uri.parse(apiUrl), body: {
        'image': base64Image,
      });
      return response;
    } catch (e) {
      print('Exception while uploading image: $e');
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
    String audioFile = '';

    switch (predictedClass) {
      case 'ka(ཀ)':
        audioFile = 'audios/ka.mp3';
        break;
      case 'kha(ཁ)':
        audioFile = 'audios/kha.mp3';
        break;
      case 'ga(ག)':
        audioFile = 'audios/ga.mp3';
        break;
      case 'nga(ང)':
        audioFile = 'audios/nga.mp3';
        break;
      case 'cha(ཅ)':
        audioFile = 'audios/cha.mp3';
        break;
      case 'chha(ཆ)':
        audioFile = 'audios/chha.mp3';
        break;
      case 'ja(ཇ)':
        audioFile = 'audios/jaa.mp3';
        break;
      case 'nya(ཉ)':
        audioFile = 'audios/nya.mp3';
        break;
      case 'geeku(ི)':
        audioFile = 'audios/geeku.mp3';
        break;
      case 'zabchu(ུ)':
        audioFile = 'audios/zhabchu.mp3';
        break;
      case 'dembo(ེ)':
        audioFile = 'audios/dembo.mp3';
        break;
      case 'naro(ོ)':
        audioFile = 'audios/naro.mp3';
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Audio for the predicted class is not available'),
          ),
        );
        return;
    }

    if (audioFile.isNotEmpty) {
      await audioPlayer.play(AssetSource(audioFile));
    }
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
              "TRANSLATE",
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
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.13,
            left: screenWidth * 0.5 - 140, // Center horizontally
            child: FloatingActionButton(
              onPressed: captureImage,
              backgroundColor: const Color.fromRGBO(3, 77, 126, 1),
              child: const Icon(
                Icons.camera,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.13,
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
              child: Text(
                predictedClass!,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
    );
  }
}
