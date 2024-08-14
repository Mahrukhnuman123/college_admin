import 'dart:typed_data';
import 'dart:convert'; // For base64 encoding/decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _eventController = TextEditingController();
  List<Map<String, dynamic>> _events = [];
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEvents = prefs.getString('events');
    if (storedEvents != null) {
      final List<dynamic> eventsJson = jsonDecode(storedEvents);
      setState(() {
        _events = eventsJson.map((event) {
          final imageBytes = event['image'] != null ? base64Decode(event['image']) : null;
          return {
            'event': event['event'],
            'image': imageBytes != null ? Uint8List.fromList(imageBytes) : null,
          };
        }).toList();
      });
    }
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = _events.map((event) {
      return {
        'event': event['event'],
        'image': event['image'] != null ? base64Encode(event['image']!) : null,
      };
    }).toList();
    prefs.setString('events', jsonEncode(eventsJson));
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) { // This block will run only on mobile platforms
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedImageBytes = result.files.first.bytes;
          print('Image bytes length: ${_selectedImageBytes?.length}');
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image upload is not supported on web.'),
      ));
    }
  }

  void _addEvent() {
    if (_eventController.text.isNotEmpty) {
      setState(() {
        _events.add({
          'event': _eventController.text,
          'image': _selectedImageBytes,
        });
        _eventController.clear();
        _selectedImageBytes = null;
        _saveEvents();
      });
    }
  }

  void _removeEvent(int index) {
    setState(() {
      _events.removeAt(index);
      _saveEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Color(0xFF00B0FF),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1B9BDA).withOpacity(0.9),
                    Colors.white.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Event description input field
                  TextField(
                    controller: _eventController,
                    decoration: InputDecoration(
                      hintText: 'Enter event description',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Image container
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        if (_selectedImageBytes != null)
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(_selectedImageBytes!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: Center(child: Text('No Image Selected')),
                          ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Upload Image'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addEvent,
                    child: Text('Add Event'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00B0FF),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Displaying the list of events
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_events[index]['event']),
                        leading: _events[index]['image'] != null
                            ? Image.memory(
                          _events[index]['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeEvent(index),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
