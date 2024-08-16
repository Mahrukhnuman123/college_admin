import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class T_Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<T_Courses> {
  final Map<String, Map<String, List<String>>> courses = {
    'BS IT': {
      'Semester 1': [],
      'Semester 2': [],
      'Semester 3': [],
      'Semester 4': [],
      'Semester 5': [],
      'Semester 6': [],
      'Semester 7': [],
      'Semester 8': [],
    },
    'BS English': {
      'Semester 1': [],
      'Semester 2': [],
      'Semester 3': [],
      'Semester 4': [],
      'Semester 5': [],
      'Semester 6': [],
      'Semester 7': [],
      'Semester 8': [],
    },
    'BS IST': {
      'Semester 1': [],
      'Semester 2': [],
      'Semester 3': [],
      'Semester 4': [],
      'Semester 5': [],
      'Semester 6': [],
      'Semester 7': [],
      'Semester 8': [],
    },
    'BS CS': {
      'Semester 1': [],
      'Semester 2': [],
      'Semester 3': [],
      'Semester 4': [],
      'Semester 5': [],
      'Semester 6': [],
      'Semester 7': [],
      'Semester 8': [],
    },
    'BS Psychology': {
      'Semester 1': [],
      'Semester 2': [],
      'Semester 3': [],
      'Semester 4': [],
      'Semester 5': [],
      'Semester 6': [],
      'Semester 7': [],
      'Semester 8': [],
    },
    'BS Physics': {
      'Semester 1': [],
      'Semester 2': [],
      'Semester 3': [],
      'Semester 4': [],
      'Semester 5': [],
      'Semester 6': [],
      'Semester 7': [],
      'Semester 8': [],
    },
    'BS Education': {
      'Semester 1': [],
      'Semester 2': [],
      'Semester 3': [],
      'Semester 4': [],
      'Semester 5': [],
      'Semester 6': [],
      'Semester 7': [],
      'Semester 8': [],
    },
    // Add other departments here
  };

  final Map<String, String> departmentImages = {
    'BS IT': 'assets/bsit.jpg',
    'BS English': 'assets/bsenglish.jpg',
    // Add other department images here
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CourseListView(
        courses: courses,
        departmentImages: departmentImages,
      ),
    );
  }
}

class CourseListView extends StatelessWidget {
  final Map<String, Map<String, List<String>>> courses;
  final Map<String, String> departmentImages;

  CourseListView({required this.courses, required this.departmentImages});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF333A56),
          title: Text('Courses',style: TextStyle(color: Colors.white),),
        ),
        body: ListView.builder(
          itemCount: courses.keys.length,
          itemBuilder: (context, index) {
            String department = courses.keys.elementAt(index);
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  department,
                  style: TextStyle(color: Color(0xFF333A56), fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DepartmentView(
                        department: department,
                        semesters: courses[department]!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class DepartmentView extends StatelessWidget {
  final String department;
  final Map<String, List<String>> semesters;

  DepartmentView({required this.department, required this.semesters});

  @override
  Widget build(BuildContext context) {
    List<String> semesterKeys = semesters.keys.toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF333A56),
          title: Text(
            '$department - Semesters',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
              color: Colors.white),
        ),
        body: ListView.builder(
          itemCount: semesterKeys.length,
          itemBuilder: (context, index) {
            String semester = semesterKeys[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  semester,
                  style: TextStyle(color: Color(0xFF333A56), fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SemesterView(
                        department: department,
                        semester: semester,
                        subjects: semesters[semester]!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class SemesterView extends StatelessWidget {
  final String department;
  final String semester;
  final List<String> subjects;

  SemesterView({required this.department, required this.semester, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF333A56),
          title: Text(
            '$department - $semester',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
              color: Colors.white),
        ),
        body: ListView.builder(
          itemCount: subjects.length + 1,
          itemBuilder: (context, index) {
            if (index == subjects.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSubjectView(
                          department: department,
                          semester: semester,
                          subjects: subjects,
                        ),
                      ),
                    );
                  },
                  child: Text('Add Subject',style: TextStyle(color: Color(0xFF333A56),),

                  ),
                ),
              );
            }
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  subjects[index],
                  style: TextStyle(color: Color(0xFF333A56), fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectView(
                        department: department,
                        semester: semester,
                        subject: subjects[index],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
class AddSubjectView extends StatelessWidget {
  final String department;
  final String semester;
  final List<String> subjects;

  AddSubjectView({required this.department, required this.semester, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Subjects',style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFF333A56),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSubjectContainer(context, 1),
              SizedBox(height: 20),
              _buildSubjectContainer(context, 2),
              SizedBox(height: 20),
              _buildSubjectContainer(context, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectContainer(BuildContext context, int index) {
    TextEditingController subjectController = TextEditingController();
    return Column(
      children: [
        TextField(
          controller: subjectController,
          decoration: InputDecoration(
            labelText: 'Subject Name $index',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            String newSubject = subjectController.text;
            if (newSubject.isNotEmpty) {
              subjects.add(newSubject);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectView(
                    department: department,
                    semester: semester,
                    subject: newSubject,
                  ),
                ),
              );
            }
          },
          child: Text(
            'Add Subject',
            style: TextStyle(color: Color(0xFF333A56)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SubjectView extends StatefulWidget {
  final String department;
  final String semester;
  final String subject;

  SubjectView({required this.department, required this.semester, required this.subject});

  @override
  _SubjectViewState createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF333A56),
          title: Text(
            widget.subject,
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: _image == null
                    ? Center(
                  child: Text(
                    'No image selected.',
                    style: TextStyle(color: Color(0xFF333A56), fontSize: 18),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    _image!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF333A56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
