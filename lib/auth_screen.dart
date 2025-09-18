import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isForgotPassword = false;
  String _captchaCode = '';

  // Controllers
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    _captchaCode = String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
    setState(() {});
  }

  void _handleLogin() {
    if (_mobileController.text.isNotEmpty &&
        _otpController.text == '123456' &&
        _captchaController.text == _captchaCode) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials. Use OTP: 123456')),
      );
    }
  }

  void _handleRegister() {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _mobileController.text.isNotEmpty &&
        _otpController.text == '123456' &&
        _captchaController.text == _captchaCode) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly. Use OTP: 123456')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 50),
                // Logo and Title
                Icon(
                  Icons.security,
                  size: 80,
                  color: Colors.blue[600],
                ),
                SizedBox(height: 20),
                Text(
                  _isForgotPassword ? 'Forgot Password' : (_isLogin ? 'Login' : 'Register'),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 40),
                // Form
                Container(
                  padding: EdgeInsets.all(30),
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
                      if (!_isLogin && !_isForgotPassword) ...[
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                      TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      if (!_isForgotPassword) ...[
                        SizedBox(height: 20),
                        TextField(
                          controller: _otpController,
                          decoration: InputDecoration(
                            labelText: 'OTP (Use: 123456)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.sms),
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                      // CAPTCHA
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _captchaCode,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                                fontFamily: 'monospace',
                              ),
                            ),
                            IconButton(
                              onPressed: _generateCaptcha,
                              icon: Icon(Icons.refresh, color: Colors.blue[600]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _captchaController,
                        decoration: InputDecoration(
                          labelText: 'Enter CAPTCHA',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.security),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isForgotPassword
                              ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('OTP sent to your mobile')),
                            );
                          }
                              : (_isLogin ? _handleLogin : _handleRegister),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _isForgotPassword
                                ? 'Send OTP'
                                : (_isLogin ? 'Login' : 'Register'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Navigation Links
                      if (!_isForgotPassword) ...[
                        if (_isLogin) ...[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isForgotPassword = true;
                              });
                            },
                            child: Text('Forgot Password?'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = false;
                                  });
                                },
                                child: Text('Register'),
                              ),
                            ],
                          ),
                        ] else ...[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = true;
                              });
                            },
                            child: Text('Back to Login'),
                          ),
                        ],
                      ] else ...[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isForgotPassword = false;
                            });
                          },
                          child: Text('Back to Login'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}