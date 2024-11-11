import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPageBase extends StatefulWidget {
  final String collectionName;
  final String appBarTitle;
  final Color appBarColor;
  final Color buttonColor;
  final Color buttonTextColor;

  const NotificationPageBase({
    Key? key,
    required this.collectionName,
    required this.appBarTitle,
    required this.appBarColor,
    required this.buttonColor,
    required this.buttonTextColor,
  }) : super(key: key);

  @override
  _NotificationPageBaseState createState() => _NotificationPageBaseState();
}

class _NotificationPageBaseState extends State<NotificationPageBase> {
  final TextEditingController _notificationController = TextEditingController();
  String selectedDepartment = 'IT'; // Default selected department
  late CollectionReference _notificationsRef;

  @override
  void initState() {
    super.initState();
    _updateNotificationsRef();
  }

  // Update the reference based on selected department
  void _updateNotificationsRef() {
    _notificationsRef = FirebaseFirestore.instance
        .collection(widget.collectionName)
        .doc(selectedDepartment)
        .collection(widget.collectionName);
  }

  // Method to send a notification
  void _sendNotification() {
    if (_notificationController.text.isNotEmpty) {
      _notificationsRef.add({
        'message': _notificationController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _notificationController.clear();
    }
  }

  // Method to delete a notification
  void _deleteNotification(String notificationId) {
    _notificationsRef.doc(notificationId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        title: Center(child: Text(widget.appBarTitle)),
        actions: [
          DropdownButton<String>(
            value: selectedDepartment,
            onChanged: (String? newValue) {
              setState(() {
                selectedDepartment = newValue!;
                _updateNotificationsRef();
              });
            },
            items: <String>['IT', 'Economic', 'Islamiat'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: 350.0,
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.appBarColor.withOpacity(0.9),
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _notificationController,
                      decoration: InputDecoration(
                        labelText: 'Notification Message',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _sendNotification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.buttonColor,
                        foregroundColor: widget.buttonTextColor,
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text('Send'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: _buildNotificationsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the notifications list
  Widget _buildNotificationsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _notificationsRef.orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading notifications'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No notifications sent yet.'));
        }

        final notificationsList = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notificationsList.length,
          itemBuilder: (context, index) {
            final notification = notificationsList[index];
            final message = notification['message'] as String;
            final notificationId = notification.id;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteNotification(notificationId);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
