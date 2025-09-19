import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_screen.dart';
import 'model/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<OnboardingData> _slides = [
    OnboardingData(
      title: 'Delhi Police',
      subtitle: 'Serving & Protecting',
      description: 'Your safety is our priority. Connect with Delhi Police for emergency services and assistance.',
      icon: Icons.security,
      color: Colors.blue,
    ),
    OnboardingData(
      title: 'Emergency Services',
      subtitle: '24/7 Support',
      description: 'Quick access to emergency services. Report crimes, accidents, and get immediate help.',
      icon: Icons.warning,
      color: Colors.red,
    ),
    OnboardingData(
      title: 'Crime Reporting',
      subtitle: 'Easy & Secure',
      description: 'Report crimes online with complete privacy and security. Track your complaint status.',
      icon: Icons.report,
      color: Colors.green,
    ),
    OnboardingData(
      title: 'Police Services',
      subtitle: 'All in One Place',
      description: 'Access various police services including NOC, verification, and other citizen services.',
      icon: Icons.people,
      color: Colors.purple,
    ),
    OnboardingData(
      title: 'Stay Connected',
      subtitle: 'Real-time Updates',
      description: 'Get real-time updates about traffic, safety alerts, and important announcements.',
      icon: Icons.notifications,
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < _slides.length - 1) {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _currentIndex = 0;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Mark onboarding as completed
  _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
  }

  _navigateToAuth() async {
    _timer?.cancel();
    await _completeOnboarding();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _navigateToAuth,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _slides[index].icon,
                                size: 80,
                                color: _slides[index].color,
                              ),
                              SizedBox(height: 30),
                              Text(
                                _slides[index].title,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                _slides[index].subtitle,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _slides[index].color,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Text(
                                _slides[index].description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                    (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentIndex ? Colors.blue[600] : Colors.grey[300],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Navigation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_currentIndex > 0) {
                        _currentIndex--;
                        _pageController.animateToPage(
                          _currentIndex,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.blue[600]),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (_currentIndex == _slides.length - 1) {
                        _navigateToAuth();
                      } else {
                        _currentIndex++;
                        _pageController.animateToPage(
                          _currentIndex,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    backgroundColor: Colors.blue[600],
                    child: Icon(Icons.arrow_forward, color: Colors.white),
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