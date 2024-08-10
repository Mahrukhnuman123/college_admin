import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final DatabaseReference _attendanceRef = FirebaseDatabase.instance.ref('attendance');

  void _addRecord() async {
    if (_dateController.text.isNotEmpty && _statusController.text.isNotEmpty) {
      await _attendanceRef.push().set({
        'date': _dateController.text,
        'status': _statusController.text,
      });

      _dateController.clear();
      _statusController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields for adding attendance records
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
            SizedBox(height: 20),
            // Displaying attendance records
            Expanded(
              child: FirebaseAnimatedList(
                query: _attendanceRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final data = snapshot.value as Map?;
                  final date = data?['date'] ?? '';
                  final status = data?['status'] ?? '';
                  return ListTile(
                    title: Text('Date: $date'),
                    subtitle: Text('Status: $status'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
