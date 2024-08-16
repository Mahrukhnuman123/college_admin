import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherEmail extends StatefulWidget {
  @override
  _TeacherEmailState createState() => _TeacherEmailState();
}

class _TeacherEmailState extends State<TeacherEmail> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getEmailFromId(String id) async {
    try {
      // Fetch user data from Firestore using the provided ID
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(id).get();

      if (userDoc.exists) {
        return userDoc.get('email') as String?;
      } else {
        print('No user found with ID: $id');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  void sendEmail(String toEmail, String id, String password) async {
    final MailOptions mailOptions = MailOptions(
      body: 'ID: $id\nPassword: $password',
      subject: 'Your Account Details',
      recipients: [toEmail],
      isHTML: false,
    );

    try {
      await FlutterMailer.send(mailOptions);
      print('Email sent successfully!');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  void checkAndSendEmail() async {
    String id = _idController.text;
    String password = _passwordController.text;

    String? email = await getEmailFromId(id);

    if (email != null) {
      sendEmail(email, id, password);
    } else {
      // Notify the user if the email is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email not found for the provided ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Email Notification',style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFF333A56),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Center(
          child: Container(
            width: 350,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF333A56), // Blue background color
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'User ID',
                    labelStyle: TextStyle(color: Colors.white), // White label color
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2), // Semi-transparent background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // White text color
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: true, // Mask password input
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: checkAndSendEmail,
                  child: Text('Send Email'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
