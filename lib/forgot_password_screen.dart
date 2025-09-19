import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();

  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _obscureOtp = true;
  String _captchaCode = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  void _generateCaptcha() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    _captchaCode = String.fromCharCodes(
      Iterable.generate(5,
              (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
    setState(() {});
  }

  Future<void> _sendOtp() async {
    if (_mobileController.text.length != 10) {
      _showSnackBar('Please enter a valid 10-digit mobile number', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isOtpSent = true;
    });

    _showSnackBar(
        'Password reset OTP sent to ${_mobileController.text}. Use: 123456',
        Colors.green);
  }

  Future<void> _resetPassword() async {
    if (_mobileController.text.isEmpty ||
        _otpController.text.isEmpty ||
        _captchaController.text.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.red);
      return;
    }

    if (_otpController.text != '123456') {
      _showSnackBar('Invalid OTP. Use: 123456', Colors.red);
      return;
    }

    if (_captchaController.text.toUpperCase() != _captchaCode) {
      _showSnackBar('Invalid Captcha', Colors.red);
      _generateCaptcha();
      _captchaController.clear();
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    _showSnackBar(
        'Password reset successful! Please check your SMS for new password.',
        Colors.green);

    // Go back to login after success
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE65100),
              Color(0xFFF57C00),
              Color(0xFFF9A825),
              Color(0xFFFBC02D),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40),
                    Center(
                      child: Icon(
                        Icons.lock_reset,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: _mobileController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        counterText: "",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (_isOtpSent) ...[
                      SizedBox(height: 16),
                      TextField(
                        controller: _otpController,
                        obscureText: _obscureOtp,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter OTP",
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureOtp
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureOtp = !_obscureOtp;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _captchaController,
                              decoration: InputDecoration(
                                labelText: "Enter Captcha",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _captchaCode,
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 3,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh, color: Colors.white),
                            onPressed: _generateCaptcha,
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _isOtpSent
                          ? _resetPassword
                          : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.deepOrange,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        _isOtpSent ? "Reset Password" : "Send OTP",
                        style:
                        TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Back to Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
