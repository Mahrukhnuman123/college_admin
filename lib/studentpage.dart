import 'package:flutter/material.dart';
import 'package:untitled2/add_student.dart';
import 'package:untitled2/courses_student.dart';
import 'package:untitled2/events.dart';
import 'package:untitled2/studentnotification.dart';
import 'package:untitled2/timetable.dart';
import 'package:untitled2/email_notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SafeArea(child: DashboardPageContent()),
    SafeArea(child: NotificationStudent()),
    SafeArea(child: StudentEmailPage()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: _pages[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          color: const Color(0xFF1B9BDA).withOpacity(0.9),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: const Color(0xFF1B9BDA).withOpacity(0.9),
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 500),
          items: const <Widget>[
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.notifications, size: 30, color: Colors.white),
            Icon(Icons.email, size: 30, color: Colors.white),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// Dashboard Content without Animation
class DashboardPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        children: [
          // Stylish Header Section using BoxDecoration
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B9BDA), Color(0xFF1179A5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade700.withOpacity(0.4),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(80.0),
                bottomRight: Radius.circular(80.0),
              ),
            ),
            width: double.infinity,
            height: 200.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Student Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage Your Activities',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
           const SizedBox( height: 40),
          // Grid Menu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SafeArea(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  children: [
                    _buildGridTile(context, 'Add Student', AddStudentPage(), Icons.person_add),
                    _buildGridTile(context, 'Timetable', TimetableStudent(), Icons.schedule),
                    _buildGridTile(context, 'Courses', CoursesStudent(), Icons.book),
                    _buildGridTile(context, 'Events', StudentEventPage(), Icons.event),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Grid Tile without Animation
  Widget _buildGridTile(BuildContext context, String title, Widget page, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.8),
                child: Icon(icon, color: const Color(0xFF1B9BDA), size: 35),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1B9BDA),
                  fontSize: 18,
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
}
