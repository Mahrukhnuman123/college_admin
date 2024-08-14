import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/teacher_admin/add_attendence.dart';
import 'package:untitled2/teacher_admin/add_teacher.dart';
import 'package:untitled2/teacher_admin/teacher_timetable.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  bool isSidebarOpen = true;
  Uint8List? _uploadedImageBytes;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imageBase64 = prefs.getString('sidebarImage');
    if (imageBase64 != null) {
      setState(() {
        _uploadedImageBytes = base64Decode(imageBase64);
      });
    }
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _uploadedImageBytes = result.files.first.bytes;
        });
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('sidebarImage', base64Encode(_uploadedImageBytes!));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image upload is not supported on web.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;

    return Scaffold(
      body: Column(
        children: [
          // Sidebar container with curved edges
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF333A56),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(isSidebarOpen ? (isMobile ? 30 : 30) : 0),
                topLeft: Radius.circular(isSidebarOpen ? (isMobile ? 30 : 30) : 0),
              ),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isSidebarOpen ? (isMobile ? 250 : 200) : 50, // Adjusted height
              width: width,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isSidebarOpen ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isSidebarOpen = !isSidebarOpen;
                      });
                    },
                  ),
                  if (isSidebarOpen)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _uploadedImageBytes != null
                                      ? MemoryImage(_uploadedImageBytes!)
                                      : null,
                                  child: _uploadedImageBytes == null
                                      ? Icon(Icons.camera_alt, color: Colors.white, size: 30)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 20),
                              _buildSidebarItem(Icons.dashboard, 'Dashboard'),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  // Handle navigation to Teacher page
                                },
                                child: _buildSidebarItem(Icons.person, 'Teacher'),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AdminScreen()),
                                  );
                                },
                                child: _buildSidebarItem(Icons.school, 'Student'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Main content with grid view
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
                      color: const Color(0xFF333A56),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(18.0),
                    child: GridView.count(
                      crossAxisCount: isMobile ? 2 : 4, // Adjust for mobile or desktop view
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _buildGridTile('Add a Teacher', Icons.person_add, AddTeacher()),
                        _buildGridTile('Add Attendance', Icons.check, AddAttendence()),
                        _buildGridTile('Timetable', Icons.event, TeacherTimetable()),
                      ],
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
        height: 100,
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
                backgroundColor: const Color(0xFF333A56),
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
                  color: const Color(0xFF333A56),
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
