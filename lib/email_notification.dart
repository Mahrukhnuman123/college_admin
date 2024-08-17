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
      appBar: AppBar(title: Text('Send Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _composeEmail,
              child: Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
