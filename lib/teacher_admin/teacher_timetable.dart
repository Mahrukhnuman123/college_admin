
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/teacher_admin/t_fri.dart';
import 'package:untitled2/teacher_admin/t_mon.dart';
import 'package:untitled2/teacher_admin/t_sat.dart';
import 'package:untitled2/teacher_admin/t_sun.dart';
import 'package:untitled2/teacher_admin/t_thurs.dart';
import 'package:untitled2/teacher_admin/t_tues.dart';
import 'package:untitled2/teacher_admin/t_wed.dart';

class TeacherTimetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Timetable',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor:  Color(0xFF333A56),
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
                  _buildDayCard(context, 'Monday', T_monday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Tuesday', T_tuesday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Wednesday',T_wednesday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Thursday', T_thursday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Friday', T_friday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Saturday', T_saturday()),
                  SizedBox(height: 20.0),
                  _buildDayCard(context, 'Sunday', T_sunday()),
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
        shadowColor: Color(0xFF333A56),
        child: Container(
          height: 60,
          width: 500, // Full width to fill the column
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF333A56).withOpacity(0.9),
                Colors.white.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
    home: TeacherTimetable(),
  ));
}
