import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isEmployeeLogin = true;
  bool _showOTPField = false;
  bool _isLoading = false;
  String _otpButtonText = 'Send OTP';
  int _countdownSeconds = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.blueAccent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(flex: 1),
                // App logo/title
                Icon(Icons.medical_services, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Medical Record System',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                // Login form
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Login type toggle
                        Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEmployeeLogin = true;
                                      _showOTPField = false;
                                      _otpController.clear();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: _isEmployeeLogin
                                        ? Colors.blue
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Employee',
                                    style: TextStyle(
                                      color: _isEmployeeLogin
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEmployeeLogin = false;
                                      _showOTPField = false;
                                      _otpController.clear();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: !_isEmployeeLogin
                                        ? Colors.blue
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Mobile OTP',
                                    style: TextStyle(
                                      color: !_isEmployeeLogin
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mobile number field (for OTP login)
                        if (!_isEmployeeLogin)
                          Column(
                            children: [
                              TextFormField(
                                controller: _mobileController,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                keyboardType: TextInputType.phone,
                                enabled: _countdownSeconds == 0,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                    return 'Please enter a valid 10-digit mobile number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed:
                                      _countdownSeconds == 0 ? _sendOtp : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _countdownSeconds == 0
                                        ? Colors.blue
                                        : Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _countdownSeconds > 0
                                      ? Text('Resend OTP ($_countdownSeconds)')
                                      : Text(_otpButtonText),
                                ),
                              ),
                              if (_showOTPField) const SizedBox(height: 16),
                            ],
                          ),

                        // Username/Employee ID field (for employee login)
                        if (_isEmployeeLogin)
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Employee ID',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            enabled: !_isLoading,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your employee ID';
                              }
                              return null;
                            },
                          ),

                        if (_isEmployeeLogin) const SizedBox(height: 16),

                        // Password field (for both login types)
                        if (_isEmployeeLogin)
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            enabled: !_isLoading,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                        // OTP field (for mobile login)
                        if (!_isEmployeeLogin && _showOTPField)
                          Column(
                            children: [
                              TextFormField(
                                controller: _otpController,
                                decoration: InputDecoration(
                                  labelText: 'OTP',
                                  prefixIcon: const Icon(Icons.key),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                keyboardType: TextInputType.number,
                                enabled: !_isLoading,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the OTP';
                                  }
                                  if (value.length != 6) {
                                    return 'OTP must be 6 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),

                        const SizedBox(height: 8),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool success = await ApiService.sendOtp(_mobileController.text);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        setState(() {
          _showOTPField = true;
          _otpButtonText = 'Resend OTP';
          _countdownSeconds = 30; // 30 second cooldown
        });

        // Start countdown
        _startCountdown();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startCountdown() {
    const oneSec = Duration(seconds: 1);
    var timer = Stream.periodic(oneSec, (x) => x).take(_countdownSeconds);

    timer.listen(
      (int i) {
        setState(() {
          _countdownSeconds = _countdownSeconds - 1;
        });
      },
      onDone: () {
        setState(() {
          _countdownSeconds = 0;
        });
      },
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool loginSuccess = false;

      if (_isEmployeeLogin) {
        // Employee login
        var result = await ApiService.loginWithEmployee(
          _usernameController.text,
          _passwordController.text,
        );
        loginSuccess = result != null;
      } else {
        // Mobile OTP login
        if (_showOTPField) {
          var result = await ApiService.verifyOtp(
            _mobileController.text,
            _otpController.text,
          );
          loginSuccess = result != null;
        }
      }

      setState(() {
        _isLoading = false;
      });

      if (loginSuccess) {
        // Navigate to home page
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
