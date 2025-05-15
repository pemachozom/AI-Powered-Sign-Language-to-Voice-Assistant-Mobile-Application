import 'dart:async';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:lagda_ai/screens/camerapage.dart';
import 'package:lagda_ai/screens/learningpage.dart';
import 'package:lagda_ai/screens/notificationpage.dart';
import 'package:lagda_ai/screens/profilepage.dart';

import 'loginpage.dart';

class homepage extends StatefulWidget {
  final Map<String, dynamic> token;

  // Constructor
  const homepage({super.key, required this.token});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int index = 1;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(hours: 20), () {
      // Show Pop-up Dialog
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent dismissing by tapping outside or pressing the back button
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                Colors.transparent, // Make the background transparent
            content: Container(
              decoration: BoxDecoration(
                color: Colors.blue, // Set the background color to blue
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Text("Session Expired",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  Text("Press OK to login again.",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text('OK', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //   builder: (BuildContext context) => const LoginPage(),
                      // ));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
        color: const Color.fromARGB(255, 20, 111, 186).withAlpha(150),
        animationDuration: const Duration(milliseconds: 800),
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            label: 'Notify',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.camera,
              color: Colors.white,
            ),
            label: 'Camera',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.book,
              color: Colors.white,
            ),
            label: 'Learn',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.perm_identity,
              color: Colors.white,
            ),
            label: 'Profile',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ],
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        height: 70,
      ),
      body: getSelectedWidget(index),
      backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
    );
  }

  Widget getSelectedWidget(int index) {
    switch (index) {
      case 0:
        return NotificationPage(token: widget.token);
      case 1:
        return CameraPage(token: widget.token);
      case 2:
        return LearningPage(token: widget.token); // Add the BookPage case

      case 3:
        return ProfilePage(token: widget.token);

      default:
        return CameraPage(token: widget.token);
    }
  }
}
