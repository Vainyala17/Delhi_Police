import 'package:delhi_police/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DelhiPoliceApp());
}

class DelhiPoliceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delhi Police',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
