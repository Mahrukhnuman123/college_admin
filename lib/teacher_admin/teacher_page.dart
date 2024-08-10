
import 'package:flutter/material.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/teacher_admin/add_attendence.dart';
import 'package:untitled2/teacher_admin/add_teacher.dart';
import 'package:untitled2/teacher_admin/teacher_timetable.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<Teacher> {
  bool isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar container
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: height,
              width: isSidebarOpen ? 250 : 50,
              color: const Color(0xFF333A56), // Changed sidebar color
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isSidebarOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isSidebarOpen = !isSidebarOpen;
                      });
                    },
                  ),
                  if (isSidebarOpen)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50, // Adjusted size of CircleAvatar// Replace with your image asset
                          ),
                          const SizedBox(height: 20), // Adjusted space below avatar
                          _buildSidebarItem(Icons.dashboard, 'Dashboard'),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Teacher()),
                              );
                            },
                            child: _buildSidebarItem(Icons.person, 'Teacher'),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AdminScreen()),
                              );
                            },
                            child:
                            _buildSidebarItem(Icons.school, 'Student'),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Navbar
                Container(
                  height: 50,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Home / Admin / Dashboard',
                    style: TextStyle(
                      color: Color(0xFF333A56), // Changed text color
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Grey container holding the five containers and notice board
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildGridTile('Add a Teacher', Icons.person_add, AddTeacher()),
                              _buildGridTile('Add Attendence', Icons.check, AddAttendence()),
                              _buildGridTile('Timetable', Icons.event,TeacherTimetable()),
                              // Added Courses container
                            ],
                          ),
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Notice Board',
                                  style: TextStyle(
                                    color: Color(0xFF333A56), // Changed text color
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildNoticeInput('Notice 1'),
                                const SizedBox(height: 10),
                                _buildNoticeInput('Notice 2'),
                                const SizedBox(height: 10),
                                _buildNoticeInput('Notice 3'),
                                const SizedBox(height: 10),
                                _buildNoticeInput('Notice 4'),
                                const SizedBox(height: 10),
                                _buildNoticeInput('Notice 5'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildGridTile(String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: 400, // Adjusted width to fit 5 containers in a row
        height: 200, // Adjusted height accordingly
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFF333A56), // Changed circle avatar color
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF333A56), // Changed text color
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeInput(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xFF333A56)), // Changed hint text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Teacher(),
  ));
}
