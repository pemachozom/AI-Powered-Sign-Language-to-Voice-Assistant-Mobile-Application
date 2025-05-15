import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lagda_ai/dbhelper/mongodb.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lagda_ai/models/userModels.dart';

import 'loginpage.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> token;

  const ProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  String? _profileImagePath;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _profileImagePath = widget.token['photo'];
    _fetchUserData();
  }

  void _refreshProfile() {
    _fetchUserData();
  }

  void _fetchUserData() async {
    var result = await MongoDB.findOne(widget.token['_id']);
    if (result != null) {
      setState(() {
        _userData = result;
      });
    } else {
      print('User data not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            left: 145,
            top: 80,
            child: Text(
              "PROFILE",
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
            child: Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Container(
                width: 320,
                height: 570,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(3, 77, 126, 1),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 280, right: 150),
              child: CircleAvatar(
                radius: 45,
                backgroundImage: _selectedImage != null
                    ? FileImage(File(_selectedImage!.path))
                    : AssetImage(
                            "assets/images/profiles/${widget.token['photo']}")
                        as ImageProvider<Object>?,
              ),
            ),
          ),
          Positioned(
            top: 270,
            left: 180,
            child: Text(
              "${_userData?['name']}",
              style: const TextStyle(fontSize: 20, color: Colors.white),
              maxLines: 2,
            ),
          ),
          const Positioned(
            top: 330,
            left: 75,
            child: Text(
              "CID :",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Positioned(
            top: 365,
            left: 75,
            child: Text(
              "${_userData?['cid']}",
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          const Positioned(
            top: 415,
            left: 75,
            child: Text(
              "Phone : ",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Positioned(
            top: 450,
            left: 75,
            child: Text(
              "${_userData?['phoneNo']}",
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          const Positioned(
            top: 500,
            left: 70,
            child: Text(
              " Emergency Phone: ",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Positioned(
            top: 540,
            left: 78,
            child: Text(
              "${_userData?['emergency']}",
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          Positioned(
            top: 600,
            left: 60,
            right: 60,
            child: SizedBox(
              height: screenHeight * 0.058,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditProfilePopup(
                        token: widget.token,
                        onSelectImage: (XFile? image) {
                          setState(() {
                            _selectedImage = image;
                          });
                        },
                        userData: _userData,
                        onProfileUpdated: _refreshProfile,
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(165, 31, 157, 48),
                ),
                child: const Text('Edit Profile',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Positioned(
            top: 660,
            left: 60,
            right: 60,
            child: SizedBox(
              height: screenHeight * 0.058,
              child: ElevatedButton(
                onPressed: () async {
                  print(widget.token['_id']);

                  // Navigate to Feedback Page
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage(token: widget.token)));

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(164, 218, 68, 38),
                ),
                child: const Text('Log Out',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 21, 35, 1),
    );
  }
}

class EditProfilePopup extends StatefulWidget {
  final Map<String, dynamic> token;
  final Map<String, dynamic>? userData;
  final Function(XFile?) onSelectImage;
  final VoidCallback onProfileUpdated;

  const EditProfilePopup({
    Key? key,
    required this.token,
    required this.onSelectImage,
    required this.userData,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  _EditProfilePopupState createState() => _EditProfilePopupState();
}

class _EditProfilePopupState extends State<EditProfilePopup> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  late TextEditingController _nameController;
  late TextEditingController _cidController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData?['name']);
    _cidController = TextEditingController(text: widget.userData?['cid']);
    _phoneController = TextEditingController(text: widget.userData?['phoneNo']);
    _emergencyController =
        TextEditingController(text: widget.userData?['emergency']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cidController.dispose();
    _phoneController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
      widget.onSelectImage(_selectedImage);
    }
  }

  Future<void> _saveProfile(
    var id,
    String name,
    String cid,
    String phoneNo,
    String emergency,
    String password,
    String photo,
  ) async {
    setState(() {
      _loading = true;
    });

    final data = (
      id: id,
      name: name,
      cid: cid,
      phoneNo: phoneNo,
      emergency: emergency,
      password: password,
      photo: photo,
    );

    var result = await MongoDB.update(data);
    print("result: " + result);
    if (result == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully',
              style: TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 70, left: 20, right: 20),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please try Again',
              style: TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }

    widget.onProfileUpdated();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edit Profile",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _selectedImage != null
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(File(_selectedImage!.path)),
                    )
                  : CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          "assets/images/profiles/${widget.token['photo']}"),
                    ),
              TextButton(
                onPressed: _selectImage,
                child: const Text(
                  "Select Photo",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _cidController,
                decoration: const InputDecoration(
                  labelText: 'CID',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _emergencyController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Phone',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () => _saveProfile(
            widget.token["_id"],
            _nameController.text,
            _cidController.text,
            _phoneController.text,
            _emergencyController.text,
            widget.token['password'].toString(),
            widget.token['photo'].toString(),
          ),
          child: _loading
              ? const CircularProgressIndicator()
              : const Text(
                  "Save",
                  style: TextStyle(color: Colors.black),
                ),
        ),
      ],
      backgroundColor: const Color.fromRGBO(3, 77, 126, 1),
    );
  }
}
