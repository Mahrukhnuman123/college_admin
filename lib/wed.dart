import 'package:flutter/material.dart';

class Wednesday extends StatefulWidget {
  @override
  _MondayState createState() => _MondayState();
}

class _MondayState extends State<Wednesday> {
  List<String> arrNames = [];
  List<String> number = [];

  TextEditingController subjectController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  void addEntry() {
    setState(() {
      arrNames.add(subjectController.text);
      number.add(timeController.text);
      subjectController.clear();
      timeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Wednesday',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1B9BDA),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5, // Adjust the width as needed
            margin: EdgeInsets.symmetric(vertical: 20.0), // Add vertical margin to center the container
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      labelText: 'Enter Subject',
                      labelStyle: TextStyle(color: const Color(0xFF1B9BDA)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: 'Enter Time',
                      labelStyle: TextStyle(color: const Color(0xFF1B9BDA)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: addEntry,
                  child: Text('Add Entry', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B9BDA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          arrNames[index],
                          style: TextStyle(
                            color: const Color(0xFF1B9BDA),
                          ),
                        ),
                        subtitle: Text(
                          number[index],
                          style: TextStyle(
                            color: const Color(0xFF1B9BDA),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: const Color(0xFF1B9BDA),
                        height: 20,
                        thickness: 2,
                      );
                    },
                    itemCount: arrNames.length,
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

void main() => runApp(MaterialApp(
  home: Wednesday(),
));
