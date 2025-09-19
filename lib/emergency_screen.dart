import 'package:flutter/material.dart';
import 'home_screen.dart'; // Your main home screen
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

class EmergencyAlertScreen extends StatelessWidget {
  final bool isFromSplash;

  EmergencyAlertScreen({this.isFromSplash = false});

  Future<void> _handleSOS(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (hasCompletedOnboarding && isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[600],
      body: SafeArea(
        child: Column(
          children: [
            // Always show top bar with close button
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => _handleSOS(context),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/sos.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'EMERGENCY',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tap SOS for immediate help',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      // SOS functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Emergency services contacted!'),
                          backgroundColor: Colors.white,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      // After SOS → go directly to HomeScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        'SOS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'This will immediately connect you to Delhi Police Emergency Services',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red[200],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
