// ignore: file_names
import 'package:flutter/material.dart';

class DisplayScreen extends StatelessWidget {
  final String username;
  final String password;

  const DisplayScreen({super.key, required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Information"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Username: $username"),
            Text("Password: $password"),
          ],
        ),
      ),
    );
  }
}
