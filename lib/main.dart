import 'package:flutter/material.dart';
import 'package:puzzle/screens/home/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.pink[100],
        buttonColor: Colors.pink[300],
      ),
      home: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}