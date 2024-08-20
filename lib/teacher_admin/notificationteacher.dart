import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationTeacher extends StatefulWidget {
  @override
  _NotificationTeacherState createState() => _NotificationTeacherState();
}

class _NotificationTeacherState extends State<NotificationTeacher> {
  final TextEditingController _notificationController = TextEditingController();

  void _sendNotification() {
    if (_notificationController.text.isNotEmpty) {
      // Reference to the Firestore collection
      CollectionReference ref = FirebaseFirestore.instance.collection('T_notifications');

      // Save the notification to Firestore
      ref.add({
        'message': _notificationController.text,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification sent successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send notification: $error')),
        );
      });

      // Clear the text field after sending the notification
      _notificationController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message')),
      );
    }
  }

  @override
  void dispose() {
    _notificationController.dispose();
    super.dispose();
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
                  foregroundColor: Color(0xFF333A56),
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
