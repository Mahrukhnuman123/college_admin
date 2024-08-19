import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class T_events extends StatefulWidget {
  @override
  _T_eventsState createState() => _T_eventsState();
}

class _T_eventsState extends State<T_events> {
  final List<EventCard> eventCards = [];

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
                        eventCards.add(EventCard());
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
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }
  Future<void> _saveEvent() async {
    if (_image != null) {
      try {
        // Upload the image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('events/${eventNameController.text}.jpg');

        await storageRef.putFile(_image!);

        // Get the download URL of the uploaded image
        final imageUrl = await storageRef.getDownloadURL();

        // Save the event details along with the image URL to Firestore
        await FirebaseFirestore.instance.collection('T_events').add({
          'name': eventNameController.text,
          'date': eventDateController.text,
          'description': eventDescriptionController.text,
          'image': imageUrl,
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event saved successfully!')),
        );

        // Clear the input fields after saving
        eventNameController.clear();
        eventDateController.clear();
        eventDescriptionController.clear();
        setState(() {
          _image = null;
        });
      } catch (e) {
        print('Error saving event: $e'); // Add this line for detailed error output
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save event! Please try again. Error: $e')),
        );
      }

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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
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
                  ElevatedButton(
                    onPressed: () {
                      _saveEvent();
                    },
                    child: Text('Save Event'),
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
