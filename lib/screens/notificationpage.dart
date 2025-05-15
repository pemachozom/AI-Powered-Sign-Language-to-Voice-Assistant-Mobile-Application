import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lagda_ai/dbhelper/constant.dart';
import 'package:lagda_ai/models/userModels.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dbhelper/mongodb.dart';

class NotificationPage extends StatefulWidget {
  final Map<String, dynamic> token;

  const NotificationPage({Key? key, required this.token}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Map<String, dynamic>? _userData;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call the function after it's defined
    _getCurrentLocation(); // Fetch the location as well
  }

  void _fetchUserData() async {
    var result = await MongoDB.findOne(widget.token['_id']);
    if (result != null) {
      // Handle the fetched data, for example:
      setState(() {
        _userData = result;
        print("rr $result");
      });
    } else {
      // Handle the case when user data is not found
      print('User data not found.');
    }
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      print("Current Position: $_currentPosition");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // print('Token: ${widget.token["name"]}');

    var text1 = "Medical assistance needed.";
    var text2 = "Need immediate help";
    var text3 = "I'm in danger";
    var text4 = "Please Help Me!";

    void sendMessage(String phoneNumber, String message) async {
      // Replace 'your_message_here' with your actual message
      // URL encode the message
      String locationMessage = '';
      if (_currentPosition != null) {
        locationMessage =
            " I'm here: https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}";
      }
      print("location" + locationMessage);
      String fullMessage = "$message $locationMessage";
      print("fullmessage" + fullMessage);
      String encodedMessage = Uri.encodeFull(fullMessage);

      // Construct the WhatsApp message URL
      String url = "https://wa.me/+975$phoneNumber/?text=$encodedMessage";

      // Convert the URL string to a Uri object
      Uri uri = Uri.parse(url);

      // Check if the URL can be launched
      if (await launchUrl(uri)) {
        // Launch the URL
        await launchUrl(uri);
      } else {
        // Handle error
        throw 'Could not launch $uri';
      }
    }

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
            left: 115,
            top: 80,
            child: Text(
              "NOTIFICATION",
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 300,
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 20, 111, 186).withAlpha(150),
                    borderRadius:
                        BorderRadius.circular(10), // Add border radius of 10
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$text1',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 100,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue, // Blue color
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Handle the onPressed event here
                            // For example, you can call the sendMessage function
                            sendMessage("${_userData?['emergency']}", text1);
                          },
                          icon: Icon(
                            Icons.send, // Message icon
                            color: Colors.white, // Icon color
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  height: 100,
                  width: 300,
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 20, 111, 186).withAlpha(150),
                    borderRadius:
                        BorderRadius.circular(10), // Add border radius of 10
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$text2',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 100,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue, // Blue color
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Handle the onPressed event here
                            // For example, you can call the sendMessage function
                            sendMessage("${_userData?['emergency']}", text2);
                          },
                          icon: Icon(
                            Icons.send, // Message icon
                            color: Colors.white, // Icon color
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  height: 100,
                  width: 300,
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 20, 111, 186).withAlpha(150),
                    borderRadius:
                        BorderRadius.circular(10), // Add border radius of 10
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$text3',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 100,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue, // Blue color
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Handle the onPressed event here
                            // For example, you can call the sendMessage function
                            sendMessage("${_userData?['emergency']}", text3);
                          },
                          icon: Icon(
                            Icons.send, // Message icon
                            color: Colors.white, // Icon color
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  height: 100,
                  width: 300,
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 20, 111, 186).withAlpha(150),
                    borderRadius:
                        BorderRadius.circular(10), // Add border radius of 10
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$text4',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 100,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue, // Blue color
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Handle the onPressed event here
                            // For example, you can call the sendMessage function
                            sendMessage("${_userData?['emergency']}", text4);
                          },
                          icon: Icon(
                            Icons.send, // Message icon
                            color: Colors.white, // Icon color
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Add a SizedBox with a height of 20 between containers
              ],
            ),
          )
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
    );
  }
}
