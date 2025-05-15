import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';

class VideoLearning extends StatefulWidget {
  final Map<String, dynamic> token;

  const VideoLearning({Key? key, required this.token}) : super(key: key);

  @override
  _VideoLearningState createState() => _VideoLearningState();
}

class _VideoLearningState extends State<VideoLearning> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = "";
  final TextEditingController _textController = TextEditingController();
  late VideoPlayerController _videoController;
  bool _showVideo = false;
  bool _isLoading = false;
  double _playbackSpeed = 1.0;
  bool _noMatchFound = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeVideoController();
  }

  void _initializeVideoController() {
    _videoController = VideoPlayerController.network(
      'https://drive.google.com/uc?export=download&id=1iGdQ2O8aujib388rpwWoxw_KDhTNYiCQ',
    )
      ..addListener(() {
        if (_videoController.value.hasError) {
          print(
              'Video Player Error: ${_videoController.value.errorDescription}');
        }
      })
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _speech.stop();
    _videoController.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _searchText = val.recognizedWords;
              _textController.text = _searchText;
            });
            _search();
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _search() async {
    setState(() {
      _isLoading = true;
      _noMatchFound = false;
    });

    await Future.delayed(Duration(seconds: 1));

    String inputText = _textController.text.toLowerCase();
    String videoUrl = "";

    switch (inputText) {
      case "kuzuzangpo":
        videoUrl =
            'https://drive.google.com/uc?export=download&id=1pr9GhBhaS5uJB3cmcNq87uCOEZ2Y4z7H';
        break;
      case "washroom":
        videoUrl =
            'https://drive.google.com/uc?export=download&id=1nU30OxFBVOuacOFl8mh0jWab7su95Jsq';
        break;
      case "diarrhea":
        videoUrl =
            'https://drive.google.com/uc?export=download&id=1B2RovX5LmEXoAE0nPxYfeSsJeJ3-kvgH';
        break;
      case "eye problem":
        videoUrl =
            'https://drive.google.com/uc?export=download&id=1CbMEDME7W_-Yu2bsKoJQKqMBM4Y3j1-2';
        break;
      case "side pain":
        videoUrl =
            'https://drive.google.com/uc?export=download&id=1Fx-T2OeRkn53XZ4S9ek4JdXuyXMmZWSx';
        break;
      case "stomach pain":
        videoUrl =
            'https://drive.google.com/uc?export=download&id=1wkabXKAkqS6pXR_Kbm0tacUDZPgCocZE';
        break;
      case "vomit":
        videoUrl =
            'https://drive.google.com/uc?export=download&id=1h-tte-XW6SaFU-g_T6L5gE4qxC5Idwzz';
        break;
      default:
        setState(() {
          _showVideo = false;
          _noMatchFound = true;
        });
        _videoController.pause();
        setState(() {
          _isLoading = false;
        });
        return;
    }

    _showVideo = true;

    // Dispose of the old video controller
    await _videoController.dispose();

    // Initialize the new video controller
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..addListener(() {
        if (_videoController.value.hasError) {
          print(
              'Video Player Error: ${_videoController.value.errorDescription}');
        }
      })
      ..initialize().then((_) {
        _videoController.play();
        setState(() {
          _isLoading = false;
        });
      });
  }

  void _playPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
        _videoController.setPlaybackSpeed(_playbackSpeed);
      }
    });
  }

  void _rewind() {
    final currentPosition = _videoController.value.position;
    _videoController.seekTo(currentPosition - const Duration(seconds: 10));
  }

  void _forward() {
    final currentPosition = _videoController.value.position;
    _videoController.seekTo(currentPosition + const Duration(seconds: 10));
  }

  void _slowDown() {
    setState(() {
      _playbackSpeed = (_playbackSpeed - 0.25).clamp(0.25, 2.0);
      _videoController.setPlaybackSpeed(_playbackSpeed);
    });
  }

  void _speedUp() {
    setState(() {
      _playbackSpeed = (_playbackSpeed + 0.25).clamp(0.25, 2.0);
      _videoController.setPlaybackSpeed(_playbackSpeed);
    });
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
            top: 150,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: _isListening ? 'Listening...' : 'Search...',
                      hintStyle: const TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: _search,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.white),
                  onPressed: _listen,
                ),
              ],
            ),
          ),
          Positioned(
            top: 280,
            left: 20,
            right: 20,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : _showVideo && _videoController.value.isInitialized
                    ? Column(
                        children: [
                          Container(
                            width: screenWidth * 0.5,
                            height: screenHeight * 0.4,
                            child: AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                          VideoProgressIndicator(
                            _videoController,
                            allowScrubbing: true,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.replay_10,
                                    color: Colors.white),
                                onPressed: _rewind,
                              ),
                              IconButton(
                                icon: Icon(
                                  _videoController.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                onPressed: _playPause,
                              ),
                              IconButton(
                                icon: const Icon(Icons.forward_10,
                                    color: Colors.white),
                                onPressed: _forward,
                              ),
                              IconButton(
                                icon: const Icon(Icons.fast_rewind,
                                    color: Colors.white),
                                onPressed: _slowDown,
                              ),
                              IconButton(
                                icon: const Icon(Icons.fast_forward,
                                    color: Colors.white),
                                onPressed: _speedUp,
                              ),
                            ],
                          ),
                          Text(
                            'Speed: ${_playbackSpeed.toStringAsFixed(2)}x',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    : _noMatchFound
                        ? Center(
                            child: Text(
                              'Unable to find related videos',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                child: const Icon(
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
