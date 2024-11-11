import 'package:flutter/material.dart';
import 'package:untitled2/addmissiondata.dart';
import 'package:untitled2/studentpage.dart';
import 'package:untitled2/teacher_admin/teacher_page.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue, Colors.grey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Title "CollegeLink"
              const Padding(
                padding: EdgeInsets.only(bottom: 90),
                child: Text(
                  "CollegeLink",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Admission Container
              _buildOptionContainer(
                context,
                title: 'Admission',
                icon: Icons.school,
                colors: [
                  const Color.fromARGB(255, 6, 212, 195),
                  const Color.fromARGB(255, 190, 236, 192),
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdmissionData(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Student Container
              _buildOptionContainer(
                context,
                title: 'Student',
                icon: Icons.people,
                colors: [
                  Colors.blue,
                  const Color.fromARGB(255, 41, 62, 80),
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Teacher Container
              _buildOptionContainer(
                context,
                title: 'Teacher',
                icon: Icons.person,
                colors: [
                  const Color(0xFF333A56),
                  const Color.fromARGB(197, 192, 200, 231),
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build individual option containers
  Widget _buildOptionContainer(BuildContext context,
      {required String title,
        required IconData icon,
        required List<Color> colors,
        required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      ),
    );
  }
}
