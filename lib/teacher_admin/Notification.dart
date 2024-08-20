 import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationPage extends StatelessWidget {
  final TextEditingController _notificationController = TextEditingController();

  void _sendNotification() {
    if (_notificationController.text.isNotEmpty) {
      // Reference to the Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref("notifications");

      // Save the notification to Realtime Database
      ref.push().set({
        'message': _notificationController.text,
        'timestamp': ServerValue.timestamp,
      });

      // Clear the text field after sending the notification
      _notificationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notification'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: 350.0,
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
              TextField(
                controller: _notificationController,
                decoration: InputDecoration(
                  labelText: 'Notification Message',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
