import 'package:flutter/material.dart';
import 'package:lagda_ai/dbhelper/mongodb.dart';
import 'package:lagda_ai/models/userModels.dart';
import 'package:mongo_dart/mongo_dart.dart' as db;

import 'loginpage.dart';

enum UserType { general, careGiver }

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String _confirmPassword = '';

  // Create controllers for each text field
  var id = db.ObjectId();
  var nameController = TextEditingController();
  var cidController = TextEditingController();
  var phonenoController = TextEditingController();
  var emergencyController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/b1.png',
              height: 140,
              width: 140,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/b2.png',
              height: 140,
              width: 140,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/b4.png',
              height: 140,
              width: 140,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/b3.png',
              height: 140,
              width: 140,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/backgroundlogo.png',
              width: 300,
              height: 300,
            ),
          ),
          Positioned(
            top: 130,
            left: 20,
            child: Image.asset(
              'assets/images/wallpaper.png',
              width: 350,
              height: 200,
            ),
          ),
          const Positioned(
            top: 60,
            left: 120,
            child: Text(
              'Welcome!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 310,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: TextFieldWithLabel(
                  label: 'Enter User Name',
                  textStyle: const TextStyle(
                      color: Color.fromARGB(255, 209, 36, 36), fontSize: 15),
                  controller: nameController,
                ),
              ),
            ),
          ),
          Positioned(
            top: 370,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: TextFieldWithLabel(
                  label: 'Enter CID Number',
                  controller: cidController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ),
          Positioned(
            top: 430,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: TextFieldWithLabel(
                  label: 'Enter Phone Number',
                  controller: phonenoController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ),
          Positioned(
            top: 490,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: TextFieldWithLabel(
                  label: 'Enter Emergency Phone Number',
                  controller: emergencyController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ),
          Positioned(
            top: 550,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    child: TextFieldWithLabel(
                      label: 'Enter Password',
                      obscureText: true,
                      controller: passwordController,
                    ),
                  ),
                  Container(
                    child: TextFieldWithLabel(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Already Signed Up?',
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
            top: 780,
            left: 40,
            right: 40,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateCid(cidController.text) &&
                      _validatePhoneNumber(phonenoController.text) &&
                      _validatePhoneNumber(emergencyController.text) &&
                      passwordController.text ==
                          confirmPasswordController.text) {
                    _insertData(
                      nameController.text,
                      cidController.text,
                      phonenoController.text,
                      emergencyController.text,
                      passwordController.text,
                      0,
                    );
                  } else {
                    String message =
                        "Password and Confirm Password do not match";
                    if (!_validateCid(cidController.text)) {
                      message =
                          "CID must be 11 digits long and contain only numbers";
                    } else if (!_validatePhoneNumber(phonenoController.text)) {
                      message =
                          "Phone number must be 8 digits long and contain only numbers";
                    } else if (!_validatePhoneNumber(
                        emergencyController.text)) {
                      message =
                          "Emergency phone number must be 8 digits long and contain only numbers";
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(165, 31, 157, 48),
                ),
                child: const Text('Sign Up',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
    );
  }

  bool _validateCid(String cid) {
    final RegExp cidRegExp = RegExp(r'^\d{11}$');
    return cidRegExp.hasMatch(cid);
  }

  bool _validatePhoneNumber(String phone) {
    final RegExp phoneRegExp = RegExp(r'^\d{8}$');
    return phoneRegExp.hasMatch(phone);
  }

  Future<void> _insertData(String name, String cid, String phoneNo,
      String emergency, String password, int count) async {
    var id = db.ObjectId();
    final data = MongoDbModel(
      id: id,
      name: name,
      cid: cid,
      phoneNo: phoneNo,
      emergency: emergency,
      password: password,
      photo: "defaultprofile.png",
    );

    var result = await MongoDB.insert(data);
    print(result);
    if (result == "success") {
      _clearall();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registered Successfully")));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _clearall() {
    nameController.clear();
    cidController.clear();
    emergencyController.clear();
    phonenoController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}

class TextFieldWithLabel extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextStyle? textStyle;
  final Function(String)? onTextChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const TextFieldWithLabel({
    super.key,
    required this.label,
    this.obscureText = false,
    this.textStyle,
    this.onTextChanged,
    this.controller,
    this.keyboardType,
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
      keyboardType: widget.keyboardType,
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
      onChanged: (value) {
        if (widget.onTextChanged != null) {
          widget.onTextChanged!(value);
        }
      },
      controller: widget.controller,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
