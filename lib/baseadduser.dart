import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class BaseAddPage extends StatefulWidget {
  final String pageTitle;
  final Color appBarColor;
  final Color containerColor;
  final Color buttonColor;
  final String roleType;

  BaseAddPage({
    required this.pageTitle,
    required this.appBarColor,
    required this.containerColor,
    required this.buttonColor,
    required this.roleType,
  });

  @override
  _BaseAddPageState createState() => _BaseAddPageState();
}

class _BaseAddPageState extends State<BaseAddPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController idController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? _uuid.v4();
      } else {
        return _uuid.v4();
      }
    } catch (e) {
      print("Error getting device ID: $e");
      return _uuid.v4(); // Fallback UUID
    }
  }

  Future<void> addToFirebase() async {
    try {
      final deviceId = await getDeviceId();

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        final role = roleController.text.trim();
        final id = idController.text.trim();
        final department = departmentController.text.trim();

        await _firestore
            .collection('Users')
            .doc(department)
            .collection(widget.roleType)
            .doc(user.uid)
            .set({
          'Name': nameController.text.trim(),
          'Email': emailController.text.trim(),
          'Role': role,
          'Department': department,
          'ID': id,
          'Password': passwordController.text.trim(),
          'DeviceId': deviceId,
        })
            .then((_) => print("${widget.roleType} added successfully."))
            .catchError((error) => print("Failed to add ${widget.roleType}: $error"));
      }
    } catch (e) {
      print("Error adding ${widget.roleType}: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.appBarColor,
          title: Text(
            widget.pageTitle,
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: 350,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.containerColor.withOpacity(0.9),
                      Colors.white.withOpacity(0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 3.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: roleController,
                      decoration: InputDecoration(
                        hintText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: departmentController,
                      decoration: InputDecoration(
                        hintText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        hintText: 'User ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 35),
                    MaterialButton(
                      color: widget.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: addToFirebase,
                      child: Text(
                        'ADD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
