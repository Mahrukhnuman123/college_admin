import 'package:flutter/material.dart';

class T_wednesday extends StatefulWidget {
  @override
  _MondayState createState() => _MondayState();
}

class _MondayState extends State<T_wednesday> {
  List<String> arrNames = [];
  List<String> number = [];

  TextEditingController subjectController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController teacherController = TextEditingController();

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
          backgroundColor:Color(0xFF333A56),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Center(
          child: Container(
            width:350,
            height: 350, // Adjust the width as needed
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
                      labelStyle: TextStyle(color: Color(0xFF333A56),),
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
                      labelStyle: TextStyle(color: Color(0xFF333A56),),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: teacherController,
                    decoration: InputDecoration(
                      labelText: 'Enter Teacher',
                      labelStyle: TextStyle(color:  Color(0xFF333A56),),
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
                    backgroundColor: Color(0xFF333A56),
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
                            color: Color(0xFF333A56),
                          ),
                        ),
                        subtitle: Text(
                          number[index],
                          style: TextStyle(
                            color: Color(0xFF333A56),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color:Color(0xFF333A56),
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
  home: T_wednesday(),
));
