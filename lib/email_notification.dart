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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email client')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email'),
        backgroundColor: Color(0xff1b9bda), // Optional: Match with the container's color
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
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
            mainAxisSize: MainAxisSize.min, // To fit the content snugly
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white), // White text
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white), // White input text
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(color: Colors.white), // White text
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white), // White input text
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white), // White text
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white), // White input text
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _composeEmail,
                child: Text('Send Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button color
                  disabledBackgroundColor: Color(0xff1b9bda), // Text color on button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
