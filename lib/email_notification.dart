import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class EmailNotification extends StatefulWidget {
  @override
  _EmailNotificationState createState() => _EmailNotificationState();
}

class _EmailNotificationState extends State<EmailNotification> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  Future<void> sendEmail(String email, String name, String id, String password) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendEmail');
      final response = await callable.call({
        'email': email,
        'name': name,
        'id': id,
        'password': password,
      });

      if (response.data['success']) {
        print('Email sent successfully!');
      } else {
        print('Failed to send email');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Map<String, String>?> getUserDetailsFromId(String id) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Students')  // Check this collection name
          .doc(id)
          .get();

      if (userDoc.exists) {
        return {
          'email': userDoc.get('email') as String,
          'name': userDoc.get('name') as String,
        };
      } else {
        print('No user found with ID: $id');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  void checkAndSendEmail() async {
    String id = _idController.text;
    String password = _passwordController.text;

    Map<String, String>? userDetails = await getUserDetailsFromId(id);

    if (userDetails != null) {
      String email = userDetails['email']!;
      String name = userDetails['name']!;
      await sendEmail(email, name, id, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email not found for the provided ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: Colors.white),
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
                obscureText: true,
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
    );
  }
}
