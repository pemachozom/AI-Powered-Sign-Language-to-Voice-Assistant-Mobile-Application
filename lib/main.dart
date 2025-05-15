import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lagda_ai/screens/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MongoDB.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture To Voice',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //  Use Timer to delay the navigation after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/border3.png',
              height: 140,
              width: 140,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/border4.png',
              height: 140,
              width: 140,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/border2.png',
              height: 140,
              width: 140,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/border1.png',
              height: 140,
              width: 140,
            ),
          ),
          Positioned(
            top: 200,
            left: 72,
            child: SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(
                bottom: 280,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'AI Powered Sign Language',
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 130, 130),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'to',
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 130, 130),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Voice Assistant',
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 130, 130),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(
                bottom: 100,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Developed By: ',
                    style: TextStyle(
                      color: Color.fromARGB(99, 83, 85, 85),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Team SynchroTech',
                    style: TextStyle(
                      color: Color.fromARGB(99, 83, 85, 85),
                      fontSize: 13,
                    ),
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
