import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: T_events(),
    );
  }
}

class T_events extends StatefulWidget {
  @override
  _T_eventsState createState() => _T_eventsState();
}

class _T_eventsState extends State<T_events> {
  List<Widget> eventCards = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('T_events').get();
    final events = snapshot.docs.map((doc) {
      return EventCard(documentId: doc.id);
    }).toList();

    setState(() {
      eventCards = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Event',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF333A56),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF333A56).withOpacity(0.7),
                Colors.white.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ...eventCards,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        eventCards.add(EventCard(documentId: 'new_event')); // Placeholder, replace with actual logic if needed
                      });
                    },
                    child: Text('Add New Event'),
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

class EventCard extends StatefulWidget {
  final String documentId;

  EventCard({required this.documentId});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.documentId != 'new_event') {
      _fetchEventDetails();
    }
  }

  Future<void> _fetchEventDetails() async {
    final doc = await FirebaseFirestore.instance.collection('T_events').doc(widget.documentId).get();
    if (doc.exists) {
      final data = doc.data();
      eventNameController.text = data?['name'] ?? '';
      eventDateController.text = data?['date'] ?? '';
      eventDescriptionController.text = data?['description'] ?? '';
      // Load the image URL if necessary
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveEvent() async {
    if (_image != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child('events/${eventNameController.text}.jpg');
        await storageRef.putFile(_image!);
        final imageUrl = await storageRef.getDownloadURL();

        if (widget.documentId == 'new_event') {
          await FirebaseFirestore.instance.collection('T_events').add({
            'name': eventNameController.text,
            'date': eventDateController.text,
            'description': eventDescriptionController.text,
            'image': imageUrl,
          });
        } else {
          await FirebaseFirestore.instance.collection('T_events').doc(widget.documentId).update({
            'name': eventNameController.text,
            'date': eventDateController.text,
            'description': eventDescriptionController.text,
            'image': imageUrl,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event saved successfully!')));
        setState(() {
          _image = null;
        });
      } catch (e) {
        print('Error saving event: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save event! Please try again. Error: $e')));
      }
    }
  }

  Future<void> _deleteEvent() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('events/${eventNameController.text}.jpg');
      await storageRef.delete();

      await FirebaseFirestore.instance.collection('T_events').doc(widget.documentId).delete();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event deleted successfully!')));
      Navigator.pop(context); // Pop the current screen to refresh
    } catch (e) {
      print('Error deleting event: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete event! Please try again. Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Icon(Icons.add_a_photo, size: 50),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: eventDateController,
                    decoration: InputDecoration(
                      labelText: 'Event Date',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: eventDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Event Description',
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saveEvent,
                        child: Text('Save Event'),
                      ),
                      SizedBox(width: 16),
                      if (widget.documentId != 'new_event')
                        ElevatedButton(
                          onPressed: _deleteEvent,
                          child: Text('Delete Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
