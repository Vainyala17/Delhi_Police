import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:delhi_police/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'emergency_screen.dart';
import 'model/onboarding_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int activeIndex = 0;

  final List<String> images = [
    'assets/111.jpg',
    'assets/222.jpg',
    'assets/333.jpg',
  ];

  final List<ServiceItem> _recentlyUsed = [
    ServiceItem('Emergency', Icons.warning, Colors.red),
    ServiceItem('Traffic', Icons.traffic, Colors.blue),
    ServiceItem('NOC', Icons.description, Colors.green),
    ServiceItem('Verification', Icons.verified_user, Colors.purple),
    ServiceItem('Lost & Found', Icons.search, Colors.orange),
    ServiceItem('Complaint', Icons.report_problem, Colors.indigo),
    ServiceItem('Helpline', Icons.phone, Colors.teal),
    ServiceItem('Services', Icons.home_repair_service, Colors.brown),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[600]),
              child: Text(
                'Delhi Police Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Home')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(leading: Icon(Icons.info), title: Text('About')),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context); // close dialog
                          },
                        ),
                        TextButton(
                          child: Text("Yes"),
                          onPressed: () {
                            Navigator.pop(context); // close dialog
                            _logout(context); // call logout function
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.blue[600],
          elevation: 0,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10,
                left: 60, right: 16, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/delhiPolice.png',
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Delhi Police',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'SHANTI SEWA NYAYA',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 17),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Recently Used
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recently Used',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 15),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: _recentlyUsed.length,
                      itemBuilder: (context, index) {
                        final service = _recentlyUsed[index];
                        return GestureDetector(
                          onTap: () {
                            if (service.name == 'Emergency') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EmergencyScreen()),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  service.icon,
                                  color: service.color,
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  service.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // How to Use
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'How to Use',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.grey[800],
                    //   ),
                    // ),
                    const SizedBox(height: 15),

                    // Carousel
                    CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) =>
                            setState(() => activeIndex = index),
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index, realIndex) {
                        final imagePath = images[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Dots Indicator
                    Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: activeIndex,
                        count: images.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.blue,
                          dotColor: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Latest Updates
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Updates',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Update 1
                    _buildUpdateCard(
                      image: "assets/update1.jpg",
                      title: "Sh. Satish Golchha, IPS takes charge as Commissioner of Police, Delhi",
                      date: "22 Aug 2025",
                      description: "He has previously served in CBI for more than 9 years and held several important positions...",
                    ),

                    const SizedBox(height: 10),

                    // Update 2
                    _buildUpdateCard(
                      image: "assets/update2.jpg",
                      title: "Inauguration of Etiquette and Skill Training Session and Unveiling of Two Handbooks",
                      date: "18 Aug 2025",
                      description: "Commissioner inaugurated training and unveiled handbooks for Duty Officers...",
                    ),

                    const SizedBox(height: 10),

                    // Update 3
                    _buildUpdateCard(
                      image: "assets/update3.png",
                      title: "Independence Day Celebrations at Police Headquarters, Delhi",
                      date: "15 Aug 2025",
                      description: "Tricolour was hoisted at Police HQ, CP Delhi congratulated officers and praised arrangements...",
                    ),

                    const SizedBox(height: 15),

                    // View More button
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          // TODO: Navigate to 'all updates' page
                        },
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text("View More"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });

            if (index == 1) { // Services
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComingSoonScreen("Services")),
              );
            }
            else if (index == 2) { // SOS
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmergencyScreen()),
              );
            }
            else if (index == 3) { // Contact
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComingSoonScreen("Contact")),
              );
            }
            else if (index == 4) { // More
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComingSoonScreen("More")),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[600],
          unselectedItemColor: Colors.grey[500],
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[350],
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/home_sos.png',
                  height: 50,
                  width: 50,
                ),
              ),
              label: 'SOS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Contact',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.setBool('has_completed_onboarding', false);

    // Clear navigation stack & restart at Splash
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => SplashScreen()),
          (route) => false,
    );
  }


  Widget _buildUpdateCard({
    required String image,
    required String title,
    required String date,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left - Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.image, color: Colors.grey[600]),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Right - Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ComingSoonScreen extends StatelessWidget {
  final String title;
  ComingSoonScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[600],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20),
            Text(
              "🚧 $title - Coming Soon 🚧",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We're working hard to bring you this feature!",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder EmergencyScreen
class EmergencyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency'),
        backgroundColor: Colors.red[600],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              "Emergency Services",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Emergency call logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling emergency services...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'CALL NOW',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}