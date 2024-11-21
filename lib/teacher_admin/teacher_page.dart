import 'package:flutter/material.dart';
import 'package:untitled2/teacher_admin/add_teacher.dart';
import 'package:untitled2/teacher_admin/notificationteacher.dart';
import 'package:untitled2/teacher_admin/t_email_noti.dart';
import 'package:untitled2/teacher_admin/t_events.dart';
import 'package:untitled2/teacher_admin/teacher%20cources.dart';
import 'package:untitled2/teacher_admin/teacher_timetable.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardContent(),
    NotificationTeacher(),
    TeacherEmailPage(),
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
          color: const Color(0xFF4A5A6A),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: const Color(0xFF4A5A6A),
          animationCurve: Curves.easeInOutCubic,
          animationDuration: const Duration(milliseconds: 500),
          items: const [
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

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Header with Curved Edges using BoxDecoration
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF4A5A6A),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(80),
              bottomRight: Radius.circular(80),
            ),
          ),
          width: double.infinity,
          height: 200.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Teacher Dashboard',
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
        SizedBox(height: 40,),
        // Responsive GridView with Menu Options
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              List<String> titles = [
                'Add Teacher',
                'Timetable',
                'Courses',
                'Events'
              ];
              List<Widget> pages = [
                AddTeacherPage(),
                TimetableTeacher(),
                CoursesTeacher(),
                TeacherEventPage(),
              ];
              List<IconData> icons = [
                Icons.person_add,
                Icons.schedule,
                Icons.book,
                Icons.event
              ];
              return _buildTile(
                context,
                titles[index],
                pages[index],
                icons[index],
              );
            },
          ),
        ),
      ],
    );
  }

  // Method for creating GridView tiles without animation
  Widget _buildTile(BuildContext context, String title, Widget page, IconData icon) {
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF4A5A6A),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF4A5A6A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
