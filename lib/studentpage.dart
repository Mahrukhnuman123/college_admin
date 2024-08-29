import 'package:flutter/material.dart';
import 'package:untitled2/add_student.dart';
import 'package:untitled2/courses_student.dart';
import 'package:untitled2/events.dart';
import 'package:untitled2/timetable.dart';
import 'package:untitled2/email_notification.dart';
import 'package:untitled2/teacher_admin/Notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // Pages for the navigation bar
  final List<Widget> _pages = [
    DashboardPageContent(),
    NotificationPage(), // Your existing notification page
    EmailPage(),  // Your existing email notification page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFF1B9BDA).withOpacity(0.9),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color(0xFF1B9BDA).withOpacity(0.9),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
          Icon(Icons.email, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class DashboardPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Container with Curved Edges
        ClipPath(
          clipper: TopCurveClipper(),
          child: Container(
            color: Color(0xFF1B9BDA).withOpacity(0.9),
            width: double.infinity,
            height: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Student/Admin/Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        // GridView with Menu Options
        Expanded(
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            padding: EdgeInsets.all(16.0),
            children: [
              _buildGridTile(
                context,
                'Add a Student',
                AddStudentPage(),
                Icons.person_add, // Icon for adding a student
              ),
              _buildGridTile(
                context,
                'Timetable',
                Timetable(),
                Icons.schedule, // Icon for timetable
              ),
              _buildGridTile(
                context,
                'Courses',
                CoursesStudent(),
                Icons.book, // Icon for courses
              ),
              _buildGridTile(
                context,
                'Events',
                Event(),
                Icons.event, // Icon for events
              ),
            ],
          ),
        ),
      ],
    );
  }

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
                backgroundColor: Color(0xff1b9bda),
                child: Icon(
                  icon, // Use the passed icon here
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xff1b9bda),
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
}

// Custom Clipper for Curved Edges
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
