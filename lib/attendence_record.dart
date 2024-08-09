import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final List<Map<String, String>> _attendanceRecords = [];

  void _addRecord() {
    if (_dateController.text.isNotEmpty && _statusController.text.isNotEmpty) {
      setState(() {
        _attendanceRecords.add({
          'date': _dateController.text,
          'status': _statusController.text,
        });
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
              child: ListView.builder(
                itemCount: _attendanceRecords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Date: ${_attendanceRecords[index]['date']}'),
                    subtitle: Text('Status: ${_attendanceRecords[index]['status']}'),
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
