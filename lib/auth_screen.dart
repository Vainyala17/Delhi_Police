import 'dart:math';
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

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    _captchaCode = String.fromCharCodes(
      Iterable.generate(5, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                const Icon(Icons.security, size: 90, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  _isForgotPassword ? 'Forgot Password' : (_isLogin ? 'Welcome Back' : 'Create Account'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Card Container
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (!_isLogin && !_isForgotPassword) ...[
                        _buildTextField(_nameController, 'Full Name', Icons.person),
                        const SizedBox(height: 15),
                        _buildTextField(_emailController, 'Email', Icons.email),
                        const SizedBox(height: 15),
                      ],

                      _buildTextField(_mobileController, 'Mobile Number', Icons.phone, inputType: TextInputType.phone),

                      if (!_isForgotPassword) ...[
                        const SizedBox(height: 15),
                        _buildTextField(_otpController, 'OTP (Use: 123456)', Icons.sms),
                      ],

                      const SizedBox(height: 15),
                      // Captcha
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _captchaCode,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                            IconButton(
                              onPressed: _generateCaptcha,
                              icon: const Icon(Icons.refresh, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(_captchaController, 'Enter Captcha', Icons.lock),

                      const SizedBox(height: 25),

                      // Button
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.blue[700],
                          ),
                          child: Text(
                            _isForgotPassword
                                ? 'Send OTP'
                                : (_isLogin ? 'Login' : 'Register'),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Links
                      if (!_isForgotPassword) ...[
                        if (_isLogin) ...[
                          TextButton(
                            onPressed: () => setState(() => _isForgotPassword = true),
                            child: const Text('Forgot Password?'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              TextButton(
                                onPressed: () => setState(() => _isLogin = false),
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ] else ...[
                          TextButton(
                            onPressed: () => setState(() => _isLogin = true),
                            child: const Text('Back to Login'),
                          ),
                        ],
                      ] else ...[
                        TextButton(
                          onPressed: () => setState(() => _isForgotPassword = false),
                          child: const Text('Back to Login'),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
      ),
    );
  }
}
