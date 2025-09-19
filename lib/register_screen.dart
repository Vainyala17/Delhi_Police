import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'emergency_screen.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();

  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _obscureOtp = true;
  bool _agreeToTerms = false;
  String _captchaCode = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
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
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  void _generateCaptcha() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    _captchaCode = String.fromCharCodes(
      Iterable.generate(5, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
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

    _showSnackBar('OTP sent to ${_mobileController.text}. Use: 123456', Colors.green);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleRegister() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your full name', Colors.red);
      return;
    }

    if (_emailController.text.trim().isEmpty || !_isValidEmail(_emailController.text.trim())) {
      _showSnackBar('Please enter a valid email address', Colors.red);
      return;
    }

    if (_mobileController.text.length != 10) {
      _showSnackBar('Please enter a valid 10-digit mobile number', Colors.red);
      return;
    }

    if (!_isOtpSent) {
      _showSnackBar('Please send OTP first', Colors.red);
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

    if (!_agreeToTerms) {
      _showSnackBar('Please accept Terms & Conditions', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 3));

    _showSnackBar('Registration successful!', Colors.green);

    // Navigate to home after a short delay
    await Future.delayed(Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setBool('has_completed_onboarding', true);

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => EmergencyAlertScreen(isFromSplash: true),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
          (route) => false,
    );
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
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF6A1B9A),
              Color(0xFF8E24AA),
              Color(0xFFAB47BC),
              Color(0xFFBA68C8),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        padding: EdgeInsets.zero,
                      ),

                      SizedBox(height: 20),

                      // Header
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                              ),
                              child: Icon(
                                Icons.person_add,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Join us today and get started',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),

                      // Register Card
                      Container(
                        padding: EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Name
                            _buildInputLabel('Full Name'),
                            SizedBox(height: 8),
                            _buildTextField(
                              controller: _nameController,
                              hintText: 'Enter your full name',
                              prefixIcon: Icons.person_outline,
                            ),

                            SizedBox(height: 20),

                            // Email
                            _buildInputLabel('Email Address'),
                            SizedBox(height: 8),
                            _buildTextField(
                              controller: _emailController,
                              hintText: 'Enter your email address',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            SizedBox(height: 20),

                            // Mobile Number
                            _buildInputLabel('Mobile Number'),
                            SizedBox(height: 8),
                            _buildTextField(
                              controller: _mobileController,
                              hintText: 'Enter your mobile number',
                              prefixIcon: Icons.phone_android,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              suffixWidget: !_isOtpSent
                                  ? TextButton(
                                onPressed: _isLoading ? null : _sendOtp,
                                child: Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    color: Colors.purple[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                                  : Icon(Icons.check_circle, color: Colors.green),
                            ),

                            if (_isOtpSent) ...[
                              SizedBox(height: 20),
                              _buildInputLabel('OTP Verification'),
                              SizedBox(height: 8),
                              _buildTextField(
                                controller: _otpController,
                                hintText: 'Enter 6-digit OTP',
                                prefixIcon: Icons.sms,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                obscureText: _obscureOtp,
                                suffixWidget: IconButton(
                                  onPressed: () => setState(() => _obscureOtp = !_obscureOtp),
                                  icon: Icon(
                                    _obscureOtp ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],

                            SizedBox(height: 20),

                            // Captcha
                            _buildInputLabel('Security Code'),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: Text(
                                        _captchaCode,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 4,
                                          color: Colors.grey[700],
                                          fontFamily: 'monospace',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.purple[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      onPressed: _generateCaptcha,
                                      icon: Icon(Icons.refresh, color: Colors.purple[700]),
                                      tooltip: 'Refresh Captcha',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 12),
                            _buildTextField(
                              controller: _captchaController,
                              hintText: 'Enter security code',
                              prefixIcon: Icons.security,
                            ),

                            SizedBox(height: 24),

                            // Terms & Conditions
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                                    activeColor: Colors.purple[700],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'I agree to the ',
                                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Terms & Conditions',
                                          style: TextStyle(
                                            color: Colors.purple[700],
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: Colors.purple[700],
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 32),

                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32),

                      // Login Link
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool obscureText = false,
    Widget? suffixWidget,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        inputFormatters: maxLength != null
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(prefixIcon, color: Colors.grey[600]),
          suffixIcon: suffixWidget,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.purple[400]!, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: '',
        ),
      ),
    );
  }
}