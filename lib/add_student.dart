import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController idcontroller = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> Addstudenttofirebase() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('Users').doc(user.uid).set({
          'Name': nameController.text.trim(),
          'Email': emailController.text.trim(),
          'role': roleController.text.trim(),
          'Password': passwordcontroller.text.trim(),
          'Department': departmentController.text.trim(),
          'id': idcontroller.text.trim(),

          // Never store passwords in plaintext in the database
        });
      }
    } catch (e) {
      print("Error adding student: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:Color(0xFF1B9BDA),
          title: Text('Add a Student',style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(
            color:Colors.white,
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
                      Color(0xFF1B9BDA).withOpacity(0.9),
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
                        hintText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 35),
                    TextField(
                      controller: idcontroller,
                      decoration: InputDecoration(
                        hintText: 'User Id',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 35),
                    MaterialButton(
                      color: Color(0xFF1B9BDA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        Addstudenttofirebase();
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
