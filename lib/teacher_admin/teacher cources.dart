import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class CoursesTeacher extends StatefulWidget {
  @override
  _CoursesTeachertState createState() => _CoursesTeachertState();
}

class _CoursesTeachertState extends State<CoursesTeacher> {
  final List<String> departments = ['Economics', 'IT', 'Islamiat'];
  String? selectedDepartment;

  final Map<String, List<Map<String, String>>> semesters = {
    'Semester 1': [],
    'Semester 2': [],
    'Semester 3': [],
    'Semester 4': [],
    'Semester 5': [],
    'Semester 6': [],
    'Semester 7': [],
    'Semester 8': [],
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:  const Color(0xFF4A5A6A),
            title: Text(
              'Select Department',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.pop(context); // Navigate back when pressed
              },
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: selectedDepartment,
                hint: Text('Choose Department'),
                items: departments.map((String department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDepartment = newValue;
                  });

                  if (newValue != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SemesterView(
                          semesters: semesters,
                          department: newValue,
                        ),
                      ),
                    );
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SemesterView extends StatelessWidget {
  final Map<String, List<Map<String, String>>> semesters;
  final String department; // Add department

  SemesterView({required this.semesters, required this.department});

  @override
  Widget build(BuildContext context) {
    List<String> semesterKeys = semesters.keys.toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:  const Color(0xFF4A5A6A),
          title: Text(
            '$department - Semesters',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
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
                  style: TextStyle(
                      color: const Color(0xFF4A5A6A), fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SemesterSubjectsView(
                        semester: semester,
                        department: department, // Pass department
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


class SemesterSubjectsView extends StatelessWidget {
  final String semester;
  final String department;

  SemesterSubjectsView({required this.semester, required this.department});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:const Color(0xFF4A5A6A),
          title: Text(
            '$department - $semester',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Subjects')
                    .doc(department)
                    .collection(semester)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print('Error fetching subjects: ${snapshot.error}');
                    return Center(child: Text('Error fetching subjects'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No subjects available.'));
                  }

                  List<DocumentSnapshot> subjects = snapshot.data!.docs;
                  print('Subjects Data: $subjects');

                  return ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      var subjectData = subjects[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(subjectData['name'] ?? 'No name'),
                          subtitle: Text(subjectData['department'] ?? 'No department'),
                          leading: subjectData['image'] != null
                              ? Image.network(
                            subjectData['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : null,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectView(
                                  semester: semester,
                                  subject: subjectData['name'] ?? 'No name',
                                  imagePath: subjectData['image'] ?? '',
                                  department: subjectData['department'] ?? 'Unknown',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSubjectView(
                        semester: semester,
                        department: department,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Add Subject',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A5A6A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AddSubjectView extends StatefulWidget {
  final String department; // Department is now fixed
  final String semester;

  AddSubjectView({required this.department, required this.semester});

  @override
  _AddSubjectViewState createState() => _AddSubjectViewState();
}

class _AddSubjectViewState extends State<AddSubjectView> {
  final TextEditingController subjectController = TextEditingController();
  File? _image;



  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image selected.')));
    }
  }

  Future<void> _uploadSubject() async {
    if (subjectController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields and select an image.')));
      return;
    }

    String subjectName = subjectController.text;
    String fileName = Uuid().v4(); // Generate a unique filename using UUID
    String departmentPath = 'subjects/${widget.department}/${widget.semester}/$fileName.jpg';

    try {
      // Upload image to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child(departmentPath);
      await storageRef.putFile(_image!);
      String imageUrl = await storageRef.getDownloadURL();

      // Debug log
      print('Image URL: $imageUrl');

      // Store subject information in Firestore
      await FirebaseFirestore.instance
          .collection('Subjects')
          .doc(widget.department)
          .collection(widget.semester)
          .doc(subjectName)
          .set({
        'name': subjectName,
        'department': widget.department,
        'image': imageUrl,
      });

      Navigator.pop(context);
    } catch (e) {
      // Debug log
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload subject.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Subject', style: TextStyle(color: Colors.white)),
          backgroundColor:  const Color(0xFF4A5A6A),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView( // To prevent overflow
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Removed department selection since it's fixed
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  const Color(0xFF4A5A6A),
                  ),
                ),
                SizedBox(height: 20),
                _image != null
                    ? Image.file(
                  _image!,
                  height: 200,
                )
                    : Text('No image selected.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadSubject,
                  child: Text('Add Subject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  const Color(0xFF4A5A6A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SubjectView extends StatelessWidget {
  final String department;
  final String semester;
  final String subject;
  final String imagePath;

  SubjectView({
    required this.department,
    required this.semester,
    required this.subject,
    required this.imagePath,
  });

  Future<void> _deleteSubject(BuildContext context) async {
    try {
      // Delete image from Firebase Storage
      Reference storageRef = FirebaseStorage.instance.refFromURL(imagePath);
      await storageRef.delete();

      // Delete subject from Firestore
      await FirebaseFirestore.instance
          .collection('Subjects')
          .doc(department)
          .collection(semester)
          .doc(subject)
          .delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subject deleted successfully.')));

      // Go back to previous screen
      Navigator.pop(context);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete subject.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(subject, style: TextStyle(color: Colors.white)),
          backgroundColor:  const Color(0xFF4A5A6A),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Subject'),
                    content: Text('Are you sure you want to delete this subject?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmDelete) {
                  _deleteSubject(context);
                }
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '$department - $semester',
                style: TextStyle(
                    color:  const Color(0xFF4A5A6A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Image.network(
              imagePath,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              subject,
              style: TextStyle(
                color: const Color(0xFF4A5A6A),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



