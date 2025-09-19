import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'emergency_screen.dart';
import 'onboarding_screen.dart';
import 'emergency_screen.dart';
import 'home_screen.dart'; // Your main home screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  _checkUserStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Splash delay

    // Always go to Emergency Screen first (common for all users)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EmergencyAlertScreen(isFromSplash: true)),
    );
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