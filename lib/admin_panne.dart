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
          color: Colors.white, // Background color set to white
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo and Title Section
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/Logo.png', // Path to your logo image
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),

              // Title Text "CollegeLink"

              const Text(
                "College Link",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF1B9BDA),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30), // Increased spacing below title

              // Containers in Rows
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First Row with two containers: Admission and Student
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Second Row with the "Teacher" container centered
                    Center(
                      child: _buildOptionContainer(
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40), // Spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build individual option containers
  Widget _buildOptionContainer(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<Color> colors,
        required Function() onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 10),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
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
            const SizedBox(height: 10),
            // Text
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
