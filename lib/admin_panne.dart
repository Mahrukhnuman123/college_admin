import 'package:flutter/material.dart';
import 'package:untitled2/addmissiondata.dart';
import 'package:untitled2/studentpage.dart';
import 'package:untitled2/teacher_admin/teacher_page.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth <= 600;
            return Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  // Curved Top Container with title
                  _buildTopContainer(),
                  const SizedBox(height: 40),

                  // First Row: Admission Container (aligned left)
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdmissionData(),
                                ),
                              );
                            },
                            child: _buildOptionContainer(
                              'Admission',
                              Icons.school,
                              [
                                const Color.fromARGB(255, 6, 212, 195),
                                const Color.fromARGB(255, 190, 236, 192),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Second Row: Student Container (aligned center)
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardPage(),
                                ),
                              );
                            },
                            child: _buildOptionContainer(
                              'Student',
                              Icons.people,
                              [
                                Colors.blue,
                                const Color.fromARGB(255, 41, 62, 80),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Third Row: Teacher Container (aligned right)
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherPage(),
                                ),
                              );
                            },
                            child: _buildOptionContainer(
                              'Teacher',
                              Icons.person,
                              [
                                const Color(0xFF333A56),
                                const Color.fromARGB(197, 192, 200, 231),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build the curved top container
  Widget _buildTopContainer() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.blueGrey,
            Colors.grey,
            Colors.greenAccent,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "CollegeLink",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Choose one to explore your activities",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build individual option containers
  Widget _buildOptionContainer(String title, IconData icon, List<Color> colors) {
    return Container(
      height: 140,
      width: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Spacing between icon and text
        children: [
          // Icon Container
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.blue,
            ),
          ),
          // Text Container
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}
