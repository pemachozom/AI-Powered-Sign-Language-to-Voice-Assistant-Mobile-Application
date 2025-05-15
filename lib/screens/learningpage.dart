import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lagda_ai/screens/alphanumtranslation.dart';
import 'package:lagda_ai/screens/dzongkhatranslation.dart';
import 'package:lagda_ai/screens/dzoyang.dart';
import 'package:lagda_ai/screens/englishdigits.dart';
import 'package:lagda_ai/screens/videolearning.dart';
import 'package:video_player/video_player.dart';
import 'videolearning.dart'; // Import the VideoLearning page

class LearningPage extends StatefulWidget {
  final Map<String, dynamic> token;

  const LearningPage({super.key, required this.token});

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late FlutterTts flutterTts;
  late AudioPlayer audioPlayer;
  bool _isPlayingVideo = false;
  String _currentVideoPath = '';
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    audioPlayer = AudioPlayer();
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _playNumberAudio(int index) async {
    String audioPath = 'numbers/$index.mp3';
    await audioPlayer.play(AssetSource(audioPath));
  }

  void _playAlphabetAudio(String name) async {
    String audioPath = 'ka/$name.mp3';
    await audioPlayer.play(AssetSource(audioPath));
  }

  void _showNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 7, 58, 100),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 500, // Adjust height as needed or calculate dynamically
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Numbers",
                    textAlign: TextAlign.center, // Center text horizontally
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: 11,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _playNumberAudio(index);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              index.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Expanded(
                              child: Image.asset(
                                'assets/images/$index.png',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlphabetDialog(BuildContext context) {
    final List<Map<String, String>> alphabetData = [
      {'name': 'ka', 'text': 'ཀ'},
      {'name': 'kha', 'text': 'ཁ'},
      {'name': 'ga', 'text': 'ག'},
      {'name': 'nga', 'text': 'ང'},
      {'name': 'cha', 'text': 'ཅ'},
      {'name': 'chha', 'text': 'ཆ'},
      {'name': 'jaa', 'text': 'ཇ'},
      {'name': 'nya', 'text': 'ཉ'},
      // Add other alphabets here if needed
    ];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 7, 58, 100),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 600,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Alphabets",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: alphabetData.length,
                    itemBuilder: (context, index) {
                      String imageName = alphabetData[index]['name']!;
                      String displayText = alphabetData[index]['text']!;
                      return GestureDetector(
                        onTap: () {
                          _playAlphabetAudio(imageName);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              displayText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                'assets/images/$imageName.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 7),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBasicImagesDialog(BuildContext context) {
    final List<Map<String, String>> itemsData = [
      {'name': 'sleeping', 'text': 'Sleep', 'type': 'image'},
      {'name': 'sad', 'text': 'Sad', 'type': 'image'},
      {'name': 'school', 'text': 'School', 'type': 'image'},
      {'name': 'handwash', 'text': 'Wash', 'type': 'image'},
      {'name': 'washroom', 'text': 'Washroom', 'type': 'image'},
      {'name': 'happy', 'text': 'Happy', 'type': 'image'},
      {'name': 'eating', 'text': 'Eat', 'type': 'video'},
      {'name': 'drinking', 'text': 'Drink', 'type': 'video'},
      {'name': 'cleaning', 'text': 'Clean', 'type': 'video'}
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color.fromARGB(255, 7, 58, 100),
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 575,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Basic Images",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _isPlayingVideo
                          ? Container(
                              width: double.infinity,
                              height: 200, // Set your desired height
                              constraints: BoxConstraints(
                                maxWidth: 270, // Set your desired maxWidth
                                maxHeight: 200, // Set your desired maxHeight
                              ),
                              child: VideoPlayerWidget(
                                videoPath: _currentVideoPath,
                                onVideoEnd: () {
                                  setState(() {
                                    _isPlayingVideo = false;
                                    _currentVideoPath = '';
                                  });
                                },
                              ),
                            )
                          : PageView.builder(
                              itemCount: itemsData.length,
                              itemBuilder: (context, index) {
                                String itemName = itemsData[index]['name']!;
                                String displayText = itemsData[index]['text']!;
                                String itemType = itemsData[index]['type']!;

                                return GestureDetector(
                                  onTap: () {
                                    itemType = 'video';
                                    if (itemType == 'video') {
                                      setState(() {
                                        _isPlayingVideo = true;
                                        _currentVideoPath =
                                            'assets/basicvideo/$itemName.mp4';
                                      });
                                    } else {
                                      _speak(displayText);
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/$itemName.png',
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        displayText,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
          Positioned(
            left: 159,
            top: 80,
            child: Text(
              "LEARN",
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
            top: screenHeight * 0.2,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoLearning(token: widget.token),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/videolearn.png',
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.09,
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  "Video Learn",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showNumberDialog(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/numbers.png',
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.09,
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  "Numbers",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showAlphabetDialog(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/alphabets.png',
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.09,
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  "གསལ་བྱེད་",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showBasicImagesDialog(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/basics.png',
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.09,
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  "Basics",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AlphaNumTranslation(token: widget.token),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/english.png',
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.09,
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  "English ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DzongkhaTranslation(token: widget.token),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/dzongkha.png',
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.09,
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  "གསལ་བྱེད་ སུམ་ཅུ།",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DigitsTranslation(token: widget.token),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/digits.png',
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.09,
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  "Digits ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DzongkhaYang(token: widget.token),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/yangzhi.png',
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.09,
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  "དབྱངས་བཞི།",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final VoidCallback onVideoEnd;

  const VideoPlayerWidget({required this.videoPath, required this.onVideoEnd});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(() {
          if (!_controller.value.isPlaying &&
              _controller.value.position == _controller.value.duration) {
            widget.onVideoEnd();
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}

void main() {
  runApp(MaterialApp(
    home: LearningPage(token: {}),
  ));
}
