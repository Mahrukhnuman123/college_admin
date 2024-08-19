import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class T_thursday extends StatefulWidget {
  @override
  _T_thursdayState createState() => _T_thursdayState();
}

class _T_thursdayState extends State<T_thursday> {
  final List<Map<String, String>> _entries = List.generate(
    5,
        (index) => {'subject': '', 'time': ''},
  );

  final _formKey = GlobalKey<FormState>();

  void _saveEntries() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Clear existing entries in Firestore for Monday
        var batch = FirebaseFirestore.instance.batch();
        var snapshot = await FirebaseFirestore.instance.collection('T_thursday').get();
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();

        // Add new entries to Firestore
        for (var entry in _entries) {
          await FirebaseFirestore.instance.collection('T_thursday').add(entry);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entries saved successfully!')),
        );
      } catch (e) {
        print("Failed to save entries: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thursday', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF333A56),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Table(
                    border: TableBorder.all(color:Color(0xFF333A56),),
                    children: [
                      _buildTableHeader(),
                      ..._entries.asMap().entries.map((entry) => _buildTableRow(entry.key)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveEntries,
          child: Icon(Icons.save),
          backgroundColor: const Color(0xFF333A56),
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Subject',
            style: TextStyle(color: Color(0xFF333A56), fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Time',
            style: TextStyle(color: Color(0xFF333A56), fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }

  TableRow _buildTableRow(int index) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          initialValue: _entries[index]['subject'],
          decoration: InputDecoration(
            hintText: 'Enter Subject',
            hintStyle: TextStyle(color: Colors.blueGrey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (value) {
            setState(() {
              _entries[index]['subject'] = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a subject';
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          initialValue: _entries[index]['time'],
          decoration: InputDecoration(
            hintText: 'Enter Time',
            hintStyle: TextStyle(color: Colors.blueGrey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (value) {
            setState(() {
              _entries[index]['time'] = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a time';
            }
            return null;
          },
        ),
      ),
    ]);
  }
}

void main() {
  runApp(MaterialApp(
    home: T_thursday(),
  ));
}
