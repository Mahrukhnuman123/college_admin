import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimetablePage extends StatefulWidget {
  final String pageTitle;
  final Color appBarColor;
  final Color titleColor;
  final String collectionName;

  TimetablePage({
    required this.pageTitle,
    required this.appBarColor,
    required this.titleColor,
    required this.collectionName,
  });

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final List<String> days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'];
  final List<TextEditingController> _subjectControllers = List.generate(21, (_) => TextEditingController());
  final List<TextEditingController> _timeControllers = List.generate(21, (_) => TextEditingController());
  final List<TextEditingController> _teacherControllers = List.generate(21, (_) => TextEditingController());
  final List<String> departments = ['IT', 'Economic', 'Islamiat'];
  String selectedDepartment = 'IT'; // Default selected department

  void _saveTimetable() {
    for (int i = 0; i < days.length; i++) {
      FirebaseFirestore.instance.collection(widget.collectionName).doc(selectedDepartment)
          .collection('Days').doc(days[i]).set({
        'subjects': [
          {
            'subject': _subjectControllers[i * 3].text,
            'time': _timeControllers[i * 3].text,
            'teacher': _teacherControllers[i * 3].text,
          },
          {
            'subject': _subjectControllers[i * 3 + 1].text,
            'time': _timeControllers[i * 3 + 1].text,
            'teacher': _teacherControllers[i * 3 + 1].text,
          },
          {
            'subject': _subjectControllers[i * 3 + 2].text,
            'time': _timeControllers[i * 3 + 2].text,
            'teacher': _teacherControllers[i * 3 + 2].text,
          },
        ]
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Timetable saved successfully for $selectedDepartment!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.pageTitle,
            style: TextStyle(color: widget.titleColor),
          ),
          backgroundColor: widget.appBarColor,
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
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedDepartment,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDepartment = newValue!;
                      });
                    },
                    items: departments.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1.7),
                      1: FlexColumnWidth(2.5),
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
                                  color: widget.appBarColor,
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
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.blue[50],
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      ),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: _timeControllers[i * 3 + j],
                                      decoration: InputDecoration(
                                        labelText: 'Time',
                                        labelStyle: TextStyle(fontSize: 14),
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.blue[50],
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      ),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: _teacherControllers[i * 3 + j],
                                      decoration: InputDecoration(
                                        labelText: 'Teacher',
                                        labelStyle: TextStyle(fontSize: 14),
                                        border: InputBorder.none,
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
    _teacherControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
