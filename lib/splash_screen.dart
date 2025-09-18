import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'emergency_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmergencyAlertScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/delhiPolice.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              // Text(
              //   'Delhi Police',
              //   style: TextStyle(
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              // SizedBox(height: 10),
              // Text(
              //   'Serving & Protecting',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.blue[200],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}