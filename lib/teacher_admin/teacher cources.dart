import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class CoursesTeacher extends StatelessWidget {
  final List<String> departments = ['Economic', 'IT', 'Islamiat'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF333A56),
          title: Text('Select Department', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: DropdownButtonFormField<String>(
            hint: Text('Choose Department'),
            items: departments.map((dep) => DropdownMenuItem(value: dep, child: Text(dep))).toList(),
            onChanged: (dep) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SemesterView(department: dep!),
              ),
            ),
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ),
    );
  }
}

class SemesterView extends StatelessWidget {
  final String department;

  SemesterView({required this.department});

  @override
  Widget build(BuildContext context) {
    final semesters = List.generate(8, (i) => 'Semester ${i + 1}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFF333A56),
        title: Text('$department - Semesters', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: semesters
            .map((sem) => ListTile(
          title: Text(sem, style: TextStyle(color: Color(0xFF333A56))),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SemesterSubjectsView(department: department, semester: sem),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}

class SemesterSubjectsView extends StatelessWidget {
  final String department;
  final String semester;

  SemesterSubjectsView({required this.department, required this.semester});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF333A56),
        title: Text('$department - $semester', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Subjects').doc(department).collection(semester).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No subjects available.'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['department']),
                leading: data['image'] != null ? Image.network(data['image'], width: 50) : null,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectView(
                      department: department,
                      semester: semester,
                      subject: data['name'],
                      imagePath: data['image'],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSubjectView(department: department, semester: semester),
          ),
        ),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF333A56),
      ),
    );
  }
}

class AddSubjectView extends StatefulWidget {
  final String department, semester;

  AddSubjectView({required this.department, required this.semester});

  @override
  _AddSubjectViewState createState() => _AddSubjectViewState();
}

class _AddSubjectViewState extends State<AddSubjectView> {
  final TextEditingController subjectController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() => _image = picked != null ? File(picked.path) : null);
  }

  Future<void> _uploadSubject() async {
    if (subjectController.text.isEmpty || _image == null) return;

    try {
      final fileName = Uuid().v4();
      final ref = FirebaseStorage.instance
          .ref()
          .child('subjects/${widget.department}/${widget.semester}/$fileName.jpg');
      await ref.putFile(_image!);
      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('Subjects')
          .doc(widget.department)
          .collection(widget.semester)
          .doc(subjectController.text)
          .set({'name': subjectController.text, 'image': imageUrl, 'department': widget.department});

      Navigator.pop(context);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Subject', style: TextStyle(color: Color(0xFF333A56)))),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: subjectController, decoration: InputDecoration(labelText: 'Subject Name')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _pickImage, child: Text('Select Image')),
            if (_image != null) Image.file(_image!, height: 150),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _uploadSubject, child: Text('Add Subject')),
          ],
        ),
      ),
    );
  }
}

class SubjectView extends StatelessWidget {
  final String department, semester, subject, imagePath;

  SubjectView({required this.department, required this.semester, required this.subject, required this.imagePath});

  Future<void> _deleteSubject(BuildContext context) async {
    try {
      await FirebaseStorage.instance.refFromURL(imagePath).delete();
      await FirebaseFirestore.instance.collection('Subjects').doc(department).collection(semester).doc(subject).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Subject deleted.')));
      Navigator.pop(context);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteSubject(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$department - $semester', style: TextStyle(fontSize: 18, color: Color(0xFF333A56))),
          SizedBox(height: 20),
          Image.network(imagePath, height: 200),
        ],
      ),
    );
  }
}
