import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/add_student.dart';
import 'package:untitled2/attendence_record.dart';
import 'package:untitled2/cources.dart';
import 'package:untitled2/events.dart';
import 'package:untitled2/teacher_admin/teacher_page.dart';
import 'package:untitled2/timetable.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "YOUR_API_KEY", // Your API key
      appId: "YOUR_APP_ID", // Your App ID
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID", // Your Messaging Sender ID
      projectId: "YOUR_PROJECT_ID", // Your Project ID
      authDomain: "YOUR_AUTH_DOMAIN", // Your Auth Domain
      storageBucket: "YOUR_STORAGE_BUCKET", // Your Storage Bucket
      databaseURL: "YOUR_DATABASE_URL", // Your Database URL (if used)
      measurementId: "YOUR_MEASUREMENT_ID", // Your Measurement ID (optional)
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminScreen(),
    );
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar container
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            width: isSidebarOpen ? 250 : 50,
            color: const Color(0xff1b9bda), // Sidebar color
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
                          radius: 50, // Size of CircleAvatar
                        ),
                        const SizedBox(height: 20), // Space below avatar
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
                              MaterialPageRoute(builder: (context) => AddStudentPage()), // Navigate to AddStudentPage
                            );
                          },
                          child: _buildSidebarItem(Icons.school, 'Student'),
                        ),
                      ],
                    ),
                  ),
              ],
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
                      color: Color(0xff1b9bda), // Text color
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
                              _buildGridTile('Add a Student', Icons.person_add, AddStudentPage()),
                              _buildGridTile('Add Attendance', Icons.check, AdminPanel()),
                              _buildGridTile('Timetable', Icons.event, Timetable()),
                              _buildGridTile('Courses', Icons.book, Courses()), // Added Courses container
                              _buildGridTile('Events', Icons.event_note, EventsPage()), // Added Events container
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AdminPanel()), // Navigate to AttendancePage
                                  );
                                },
                                child: _buildGridTile('Attendance Records', Icons.history, AdminPanel()), // Add Attendance Records tile
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: const [
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
                                    color: Color(0xff1b9bda), // Text color
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
        width: 180, // Adjusted width to fit 5 containers in a row
        height: 160, // Adjusted height accordingly
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
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
                backgroundColor: const Color(0xff1b9bda), // Circle avatar color
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
                  color: Color(0xff1b9bda), // Text color
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
        hintStyle: const TextStyle(
          color: Color(0xff1b9bda), // Hint text color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
