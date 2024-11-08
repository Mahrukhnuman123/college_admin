import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/add_student.dart';
import 'package:untitled2/addmissiondata.dart';
import 'package:untitled2/events.dart';
import 'package:untitled2/firebase_options.dart';
import 'package:untitled2/studentpage.dart';
import 'package:untitled2/teacher_admin/teacher_page.dart';


class dashboardpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          // Check if the width is less than or equal to a certain threshold (e.g., 600px)
          bool isMobile = constraints.maxWidth <= 600;
          if (isMobile) {
            return Container(
                color: Colors.black45,
                height: double.infinity,
                width: double.infinity,
                child: Column(children: [
                  SizedBox(
                    height: 80,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdmissionData()));
                    },
                    child: Container(
                      height: 170,
                      width: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 6, 212, 195),
                            const Color.fromARGB(255, 190, 236, 192)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          // The circular shape with the admission icon
                          Padding(
                            padding: const EdgeInsets.all(
                                10.0), // Add padding to create space around the circle
                            child: Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons
                                    .school, // Replace with the appropriate admission icon
                                size: 35,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          // The existing Row content
                          Expanded(
                            child: Text(
                              'Admission', // Corrected "Addmisiion Statics" to "Admission Statics"
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardPage()));
                    },
                    child: Container(
                      height: 170,
                      width: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            const Color.fromARGB(255, 41, 62, 80)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Positions elements at both ends
                        children: [
                          // Text on the left side
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0), // Adds some padding to the left
                            child: Text(
                              'Student',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Circle with icon on the right side
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0), // Adds some padding to the right
                            child: Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.school, // Student icon
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TeacherPage()));
                    },
                    child: Container(
                        height: 170,
                        width: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF333A56),
                              Color.fromARGB(197, 192, 200, 231),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // The circular shape with the admission icon
                            Padding(
                              padding: const EdgeInsets.all(
                                  10.0), // Add padding to create space around the circle
                              child: Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons
                                      .school, // Replace with the appropriate admission icon
                                  size: 35,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            // The existing Row content
                            Expanded(
                              child: Text(
                                'Teacher', // Corrected "Addmisiion Statics" to "Admission Statics"
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  ),
                ]));
          }
          return Container(
            height: 800,
            width: 700,
            color: Colors.blue,
          );
        }),
      ),
    );
  }
}
