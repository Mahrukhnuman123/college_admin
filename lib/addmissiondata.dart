import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdmissionData extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Admission Data',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff06d4c3),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('admissions').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }
      
            var documents = snapshot.data!.docs;
      
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      title: Center(
                        child: Text(
                          '${data['firstName'] ?? 'No First Name'} ${data['lastName'] ?? 'No Last Name'}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () => _showDetails(context, data),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Student Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16.0),
                Table(
                  border: TableBorder.all(),
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    _buildTableRow('First Name:', data['firstName']),
                    _buildTableRow('Last Name:', data['lastName']),
                    _buildTableRow('Father Name:', data['fatherName']),
                    _buildTableRow('Email:', data['email']),
                    _buildTableRow('Phone Number:', data['phoneNumber']),
                    _buildTableRow('Address:', data['address']),
                    _buildTableRow('Course:', data['course']),
                    _buildTableRow('Date of Birth:', data['dob']),
                    _buildTableRow('Picture:', data['pictureUrl']),
                    _buildTableRow('Document:', data['documents']),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TableRow _buildTableRow(String label, dynamic value) {
    if (value is List) {
      // If the value is a List, display each item in a new line
      value = value.join(', '); // Combine list items into a single string
    }

    // Logging to check the value being processed
    print('Processing $label with value: $value');

    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: value != null
                ? (label == 'Picture:'
                        ? Image.network(
                            value,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error,
                                  color: Colors.red); // Display an error icon
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) {
                                return child;
                              } else {
                                return Center(
                                    child:
                                        CircularProgressIndicator()); // Show a loading spinner
                              }
                            },
                          )
                        : (label == 'Document:'
                            ? GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(value)) {
                                    await launch(
                                        value); // Open the document link
                                  } else {
                                    throw 'Could not launch $value';
                                  }
                                },
                                child: Text(
                                  'View Document',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            : Text(value)) // Display other text values
                    )
                : Text('N/A'),
          ),
        ),
      ],
    );
  }
}
