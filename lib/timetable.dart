
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/fri.dart';
import 'package:untitled2/mon.dart';
import 'package:untitled2/sat.dart';
import 'package:untitled2/sun.dart';
import 'package:untitled2/thurs.dart';
import 'package:untitled2/tues.dart';
import 'package:untitled2/wed.dart';

class Timetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Timetable',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1B9BDA),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDayCard(context, 'Monday', Monday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Tuesday', Tuesday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Wednesday', wednesday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Thursday', Thursday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Friday', Friday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Saturday', Saturday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Sunday', Sunday()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, String day, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: const Color(0xFF1B9BDA),
        child: Container(
          height: 60,
          width: 500, // Full width to fill the column
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0077B6), Color(0xFF0096C7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18, // Adjusted font size for better fit
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Timetable(),
  ));
}
