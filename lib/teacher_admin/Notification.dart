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
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15.0),
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
