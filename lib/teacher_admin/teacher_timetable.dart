import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherTimetable extends StatefulWidget {
  @override
  _TeacherTimetableState createState() => _TeacherTimetableState();
}

class _TeacherTimetableState extends State<TeacherTimetable> {
  final List<String> days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
  final List<TextEditingController> _subjectControllers = List.generate(21, (_) => TextEditingController());
  final List<TextEditingController> _timeControllers = List.generate(21, (_) => TextEditingController());
  final List<TextEditingController> _nameControllers = List.generate(21, (_) => TextEditingController());

  void _saveTimetable() {
    for (int i = 0; i < days.length; i++) {
      FirebaseFirestore.instance.collection('TeacherTimetable').doc(days[i]).set({
        'subjects': [
          {
            'subject': _subjectControllers[i * 3].text,
            'time': _timeControllers[i * 3].text,
            'name': _nameControllers[i * 3].text,
          },
          {
            'subject': _subjectControllers[i * 3 + 1].text,
            'time': _timeControllers[i * 3 + 1].text,
            'name': _nameControllers[i * 3].text,
          },
          {
            'subject': _subjectControllers[i * 3 + 2].text,
            'time': _timeControllers[i * 3 + 2].text,
            'name': _nameControllers[i * 3].text,
          },
        ]
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Timetable saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Timetable',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF333A56),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveTimetable,
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(1.5), // Increased width of the days column
                  1: FlexColumnWidth(2.5), // Adjusted other columns to maintain balance
                  2: FlexColumnWidth(2.5),
                  3: FlexColumnWidth(2.5),
                },
                border: TableBorder.all(color: Colors.black, width: 1),
                children: [
                  for (int i = 0; i < days.length; i++)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            days[i],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333A56),
                            ),
                          ),
                        ),
                        for (int j = 0; j < 3; j++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _subjectControllers[i * 3 + j],
                                  decoration: InputDecoration(
                                    labelText: 'Subject',
                                    labelStyle: TextStyle(fontSize: 14),
                                    border: InputBorder.none, // Remove underline
                                    filled: true,
                                    fillColor: Colors.blue[50],
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  ),
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8), // Space between fields
                                TextField(
                                  controller: _timeControllers[i * 3 + j],
                                  decoration: InputDecoration(
                                    labelText: 'Time',
                                    labelStyle: TextStyle(fontSize: 14),
                                    border: InputBorder.none, // Remove underline
                                    filled: true,
                                    fillColor: Colors.blue[50],
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  ),
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8), // Space between fields
                                TextField(
                                  controller: _nameControllers[i * 3 + j],
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: TextStyle(fontSize: 14),
                                    border: InputBorder.none, // Remove underline
                                    filled: true,
                                    fillColor: Colors.blue[50],
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  ),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectControllers.forEach((controller) => controller.dispose());
    _timeControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: TeacherTimetable(),
  ));
}
