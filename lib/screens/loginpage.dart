import 'package:flutter/material.dart';
import 'package:lagda_ai/screens/homepage.dart';
import 'package:lagda_ai/screens/signup.dart';
import 'package:local_auth/local_auth.dart'; // For fingerprint authentication
import 'package:shared_preferences/shared_preferences.dart';

import '../dbhelper/mongodb.dart';

enum UserType { general, careGiver }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var cidController = TextEditingController();
  var passwordController = TextEditingController();
  bool _isButtonDisabled = false;
  bool _isLoading = false;
  bool _isFingerprintLoading = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadCID(); // Load the saved CID when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/b1.png',
              height: screenHeight * 0.16,
              width: screenWidth * 0.35,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/b2.png',
              height: screenHeight * 0.16,
              width: screenWidth * 0.35,
            ),
          ),
          Positioned(
            bottom: -5,
            left: 0,
            child: Image.asset(
              'assets/images/b4.png',
              height: screenHeight * 0.16,
              width: screenWidth * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/b3.png',
              height: screenHeight * 0.16,
              width: screenWidth * 0.35,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/backgroundlogo.png',
              width: screenWidth * 0.77,
              height: screenHeight * 0.35,
            ),
          ),
          Positioned(
            top: 150,
            left: 20,
            child: Image.asset(
              'assets/images/wallpaper.png',
              width: screenWidth * 0.89,
              height: screenHeight * 0.23,
            ),
          ),
          const Positioned(
            top: 85,
            left: 85,
            child: Text(
              'Welcome Back!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 380,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: TextFieldWithLabel(
                  label: 'Enter CID Number',
                  controller: cidController,
                ),
              ),
            ),
          ),
          Positioned(
            top: 460,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    child: TextFieldWithLabel(
                      label: 'Enter Password',
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print('Forgot Password?');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: const Text(
                      'Create new account?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60, // Adjusted position above the Login button
            left: 40,
            right: 40,
            child: GestureDetector(
              onTap: () {
                _authenticateManuallyWithFingerprint(); // Function to handle fingerprint authentication
              },
              child: Image.asset(
                'assets/images/fingerprint.png', // Replace with your fingerprint icon asset path
                height: 80,
                width: 80,
              ),
            ),
          ),
          Positioned(
            top: 660,
            left: 40,
            right: 40,
            child: _isLoading || _isFingerprintLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : SizedBox(
                    height: screenHeight * 0.058,
                    child: ElevatedButton(
                      onPressed: _isLoading || _isFingerprintLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                                _isButtonDisabled = true;
                              });
                              await _performLogin();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(165, 31, 157, 48),
                      ),
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
    );
  }

  Future<void> _loadCID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCID = prefs.getString('cid');
    if (savedCID != null) {
      cidController.text = savedCID;
    }
  }

  Future<void> _authenticateManuallyWithFingerprint() async {
    setState(() {
      _isFingerprintLoading = true;
    });
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        await _performFingerprintLogin();
      }
    } catch (e) {
      print("Error during fingerprint authentication: $e");
    }
    setState(() {
      _isFingerprintLoading = false;
    });
  }

  Future<void> _performFingerprintLogin() async {
    var enteredCID = cidController.text;

    if (enteredCID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CID Number is required")),
      );
      return;
    }

    try {
      List<Map<String, dynamic>> userDataList = await MongoDB.getData();

      Map<String, dynamic>? userData = userDataList.firstWhere(
        (user) => user['cid'] == enteredCID,
      );

      if (userData != null) {
        _successMessage(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => homepage(token: userData),
          ),
        );
        await _saveCID(enteredCID);
      } else {
        _errorMessage(context);
      }
    } catch (e) {
      print("Error during login: $e");
      _errorMessage(context);
    }
  }

  Future<void> _performLogin() async {
    var enteredCID = cidController.text;
    var enteredPassword = passwordController.text;

    if (enteredCID.isEmpty || enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CID Number and Password are required")),
      );
      return;
    }

    try {
      Map<String, dynamic>? userData = await MongoDB.findCid(enteredCID);

      if (userData == null) {
        _errorMessage(context);
        return;
      }

      var hashedEnteredPassword = MongoDB.hashPassword(enteredPassword);

      if (userData['password'] == hashedEnteredPassword) {
        _successMessage(context);
        await _saveCID(enteredCID);
        setState(() {
          _isButtonDisabled =
              true; // Disables the fingerprint button on successful login
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => homepage(token: userData),
            ),
          );
        });
      } else {
        _errorMessage(context);
      }
    } catch (e) {
      print("Error during login: $e");
      _errorMessage(context);
    }
  }

  Future<void> _saveCID(String cid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cid', cid);
  }

  _successMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(8),
          height: 80,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 70, 134, 72),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Success",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Successfully logged in",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ))
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 3,
      ),
    );
  }

  _errorMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(8),
          height: 80,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 165, 60, 37),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Error",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Please Login Again",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ))
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 3,
      ),
    );
  }
}

class TextFieldWithLabel extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextStyle? textStyle;
  final TextEditingController? controller;

  const TextFieldWithLabel({
    super.key,
    required this.label,
    this.obscureText = false,
    this.textStyle,
    this.controller,
  });

  @override
  _TextFieldWithLabelState createState() => _TextFieldWithLabelState();
}

class _TextFieldWithLabelState extends State<TextFieldWithLabel> {
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText ? _obscureText : false,
      cursorColor: Colors.white,
      cursorHeight: 25,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: _focusNode.hasFocus ? Colors.blue : Colors.white,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      focusNode: _focusNode,
      controller: widget.controller,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
