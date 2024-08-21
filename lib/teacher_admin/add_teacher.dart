import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class AddTeacher extends StatefulWidget {
  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController idcontroller = TextEditingController();
  final Uuid _uuid = Uuid();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id; // For Android
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? _uuid.v4(); // For iOS
      } else {
        return _uuid.v4(); // Default UUID for non-mobile platforms
      }
    } catch (e) {
      print("Error getting device ID: $e");
      return _uuid.v4(); // Fallback UUID
    }
  }

  Future<void> addTeacherToFirebase() async {
    try {
      final deviceId = await getDeviceId();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordcontroller.text.trim());

      User? user = userCredential.user;

      if (user != null) {
        final name = nameController.text.trim();
        final email = emailController.text.trim();
        final role = roleController.text.trim();
        final id = idcontroller.text.trim();
        final departments = departmentController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList();

        for (String department in departments) {
          // Add the teacher data to a subcollection under the department document
          await _firestore
              .collection('Users')
              .doc(department)
              .collection('Teachers')
              .doc(user.uid) // Use UID as the document ID
              .set({
                'Name': name,
                'Email': email,
                'Role': role,
                'Department': department,
                'ID': id,
                'Password': passwordcontroller.text.trim(),
                'DeviceId': deviceId,
              })
              .then((_) => print("Teacher added successfully to $department."))
              .catchError((error) =>
                  print("Failed to add teacher to $department: $error"));
        }
      }
    } catch (e) {
      print("Error adding teacher: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF333A56),
          title: Text(
            'Add a Teacher',
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
                      Color(0xFF333A56).withOpacity(0.9),
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
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 35),
                    TextField(
                      controller: departmentController,
                      decoration: InputDecoration(
                        hintText: 'Departments (comma separated)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 35),
                    TextField(
                      controller: idcontroller,
                      decoration: InputDecoration(
                        hintText: 'User ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 35),
                    MaterialButton(
                      color: Color(0xFF333A56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        addTeacherToFirebase();
                      },
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
