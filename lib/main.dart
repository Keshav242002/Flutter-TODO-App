import 'package:flutter/material.dart';
import 'landing_page.dart'; // Import the LandingPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
