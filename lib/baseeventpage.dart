import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BaseEventPage extends StatefulWidget {
  final String collectionName; // Collection name pass karenge (events ya t_events)
  final Color appBarColor;

  const BaseEventPage({
    required this.collectionName,
    required this.appBarColor,
  });

  @override
  _BaseEventPageState createState() => _BaseEventPageState();
}

class _BaseEventPageState extends State<BaseEventPage> {
  final List<EventCard> eventCards = [];

  Future<void> _fetchEvents() async {
    final snapshot =
    await FirebaseFirestore.instance.collection(widget.collectionName).get();
    setState(() {
      eventCards.clear();
      for (var doc in snapshot.docs) {
        eventCards.add(EventCard(
          eventId: doc.id,
          eventData: doc.data(),
          collectionName: widget.collectionName,
        ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Events',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: widget.appBarColor,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.appBarColor.withOpacity(0.7),
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
                  child: const Text(
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
                        eventCards.add(EventCard(
                          collectionName: widget.collectionName,
                        ));
                      });
                    },
                    child: const Text('Add New Event'),
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
  final String? eventId;
  final Map<String, dynamic>? eventData;
  final String collectionName;

  EventCard({this.eventId, this.eventData, required this.collectionName});

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
    if (widget.eventData != null) {
      eventNameController.text = widget.eventData!['name'] ?? '';
      eventDateController.text = widget.eventData!['date'] ?? '';
      eventDescriptionController.text = widget.eventData!['description'] ?? '';
    }
  }

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
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('${widget.collectionName}/${eventNameController.text}.jpg');
        await storageRef.putFile(_image!);

        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection(widget.collectionName).add({
          'name': eventNameController.text,
          'date': eventDateController.text,
          'description': eventDescriptionController.text,
          'image': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event saved successfully!')),
        );

        eventNameController.clear();
        eventDateController.clear();
        eventDescriptionController.clear();
        setState(() {
          _image = null;
        });

        (context.findAncestorStateOfType<_BaseEventPageState>())?._fetchEvents();
      } catch (e) {
        print('Error saving event: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save event! Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteEvent() async {
    try {
      if (widget.eventId != null) {
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.eventId)
            .delete();

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('${widget.collectionName}/${eventNameController.text}.jpg');
        await storageRef.delete();

        (context.findAncestorStateOfType<_BaseEventPageState>())?._fetchEvents();
      }
    } catch (e) {
      print('Error deleting event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event! Error: $e')),
      );
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
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: _image == null
                    ? Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.add_a_photo, size: 50),
                )
                    : Image.file(
                  _image!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: eventNameController,
                    decoration: const InputDecoration(labelText: 'Event Name'),
                  ),
                  TextField(
                    controller: eventDateController,
                    decoration: const InputDecoration(labelText: 'Event Date'),
                  ),
                  TextField(
                    controller: eventDescriptionController,
                    decoration: const InputDecoration(labelText: 'Event Description'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _saveEvent, child: const Text('Save Event')),
                  if (widget.eventId != null)
                    ElevatedButton(
                      onPressed: _deleteEvent,
                      child: const Text('Delete Event'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

