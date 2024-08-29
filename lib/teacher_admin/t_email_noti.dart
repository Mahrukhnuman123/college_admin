import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmailSenderPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EmailSenderPage extends StatefulWidget {
  @override
  _EmailSenderPageState createState() => _EmailSenderPageState();
}

class _EmailSenderPageState extends State<EmailSenderPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<Map<String, String>> sentEmails = []; // List to store sent email data

  Future<void> _composeEmail() async {
    final String subject = 'Your Account Information';
    final String body = '''
    Name: ${_nameController.text}
    ID: ${_idController.text}
    Password: ${_passwordController.text}
    ''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
      // Add the sent email data to the list
      setState(() {
        sentEmails.add({
          'name': _nameController.text,
          'id': _idController.text,
          'password': _passwordController.text,
        });
      });
      _clearFields(); // Clear fields after sending the email
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email client')),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _idController.clear();
    _passwordController.clear();
  }

  void _deleteEmail(int index) {
    setState(() {
      sentEmails.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF333A56),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20), // Add some top margin
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF333A56).withOpacity(0.9),
                      Colors.white.withOpacity(0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 3.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText: 'ID',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _composeEmail,
                      child: Text('Send Email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        disabledBackgroundColor: Color(0xFF333A56),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (sentEmails.isNotEmpty) ...[
                Text(
                  'Sent Emails:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: sentEmails.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF333A56).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text('Name: ${sentEmails[index]['name']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${sentEmails[index]['id']}'),
                            Text('Password: ${sentEmails[index]['password']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteEmail(index),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
