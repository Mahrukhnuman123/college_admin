import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addRecord() async {
    if (_emailController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _statusController.text.isNotEmpty) {
      // Save the record to Firestore
      await _firestore.collection('attendance').add({
        'email': _emailController.text,
        'date': _dateController.text,
        'status': _statusController.text,
      });

      _emailController.clear();
      _dateController.clear();
      _statusController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Record added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1B9BDA),
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 350,
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1B9BDA).withOpacity(0.9),
                Colors.white.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input fields for adding attendance records
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Student Email'),
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status (Present/Absent)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addRecord,
                child: Text('Add Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
