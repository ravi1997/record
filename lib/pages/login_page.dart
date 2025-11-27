import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/theme_constants.dart';
import '../services/user_provider.dart';
import '../utils/ui_components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
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
  late StreamSubscription<int>? _otpCountdownSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
            child: Column(
              children: [
                const Spacer(flex: 1),
                // App logo/title
                const Icon(Icons.medical_services,
                    size: AppConstants.largeIconSize, color: Colors.white),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppConstants.spacingExtraLarge + 16),
                // Login form
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
                  decoration: BoxDecoration(
                    color: ThemeConstants.lightColorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
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
                            color: ThemeConstants
                                .lightColorScheme.surfaceContainerHighest,
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
                                        ? ThemeConstants
                                            .lightColorScheme.primary
                                        : Colors.transparent,
                                    foregroundColor: _isEmployeeLogin
                                        ? ThemeConstants
                                            .lightColorScheme.onPrimary
                                        : ThemeConstants
                                            .lightColorScheme.onSurfaceVariant,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Employee',
                                    style: TextStyle(
                                      color: _isEmployeeLogin
                                          ? ThemeConstants
                                              .lightColorScheme.onPrimary
                                          : ThemeConstants.lightColorScheme
                                              .onSurfaceVariant,
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
                                        ? ThemeConstants
                                            .lightColorScheme.primary
                                        : Colors.transparent,
                                    foregroundColor: !_isEmployeeLogin
                                        ? ThemeConstants
                                            .lightColorScheme.onPrimary
                                        : ThemeConstants
                                            .lightColorScheme.onSurfaceVariant,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Mobile OTP',
                                    style: TextStyle(
                                      color: !_isEmployeeLogin
                                          ? ThemeConstants
                                              .lightColorScheme.onPrimary
                                          : ThemeConstants.lightColorScheme
                                              .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: AppConstants.defaultPadding * 1.5),

                        // Mobile number field (for OTP login)
                        if (!_isEmployeeLogin)
                          Column(
                            children: [
                              UIComponents.buildInputField(
                                controller: _mobileController,
                                labelText: 'Mobile Number',
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                enabled: _countdownSeconds == 0,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppConstants.requiredFieldMessage;
                                  }
                                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                    return AppConstants.invalidPhoneMessage;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                  height: AppConstants.defaultPadding),
                              UIComponents.buildButton(
                                text: _countdownSeconds > 0
                                    ? 'Resend OTP ($_countdownSeconds)'
                                    : _otpButtonText,
                                onPressed:
                                    _countdownSeconds == 0 ? _sendOtp : null,
                                backgroundColor: _countdownSeconds == 0
                                    ? null // Use theme default
                                    : null,
                              ),
                              if (_showOTPField)
                                const SizedBox(
                                    height: AppConstants.defaultPadding),
                            ],
                          ),

                        // Username/Employee ID field (for employee login)
                        if (_isEmployeeLogin)
                          UIComponents.buildInputField(
                            controller: _usernameController,
                            labelText: 'Employee ID',
                            prefixIcon: Icons.person,
                            enabled: !_isLoading,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppConstants.requiredFieldMessage;
                              }
                              return null;
                            },
                          ),

                        if (_isEmployeeLogin)
                          const SizedBox(height: AppConstants.defaultPadding),

                        // Password field (for both login types)
                        if (_isEmployeeLogin)
                          UIComponents.buildInputField(
                            controller: _passwordController,
                            labelText: 'Password',
                            prefixIcon: Icons.lock,
                            obscureText: true,
                            enabled: !_isLoading,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppConstants.requiredFieldMessage;
                              }
                              if (value.length < 6) {
                                return AppConstants.invalidPasswordMessage;
                              }
                              return null;
                            },
                          ),

                        // OTP field (for mobile login)
                        if (!_isEmployeeLogin && _showOTPField)
                          Column(
                            children: [
                              UIComponents.buildInputField(
                                controller: _otpController,
                                labelText: 'OTP',
                                prefixIcon: Icons.key,
                                keyboardType: TextInputType.number,
                                enabled: !_isLoading,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppConstants.requiredFieldMessage;
                                  }
                                  if (value.length != AppConstants.otpLength) {
                                    return AppConstants.invalidOtpMessage;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                  height: AppConstants.spacingMedium),
                            ],
                          ),

                        const SizedBox(height: AppConstants.spacingSmall),

                        // Login button
                        UIComponents.buildButton(
                          text: 'Login',
                          onPressed: _handleLogin,
                          isLoading: _isLoading,
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

      // Simulate sending OTP (offline)
      bool success = true; // Always succeed in offline mode

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
          SnackBar(
            content: const Text('OTP sent successfully! (Offline mode)'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _startCountdown() {
    const oneSec = Duration(seconds: 1);
    var timer = Stream.periodic(oneSec, (x) => x).take(_countdownSeconds);

    _otpCountdownSubscription = timer.listen(
      (int i) {
        setState(() {
          _countdownSeconds = _countdownSeconds - 1;
        });
      },
      onDone: () {
        setState(() {
          _countdownSeconds = 0;
          _otpCountdownSubscription = null;
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
        // Employee login - bypass API call in offline mode
        loginSuccess = true; // Always succeed in offline mode
      } else {
        // Mobile OTP login - bypass API call in offline mode
        if (_showOTPField) {
          // Verify OTP locally (just check if it's a 6-digit number)
          if (_otpController.text.length == 6 &&
              RegExp(r'^[0-9]{6}$').hasMatch(_otpController.text)) {
            loginSuccess = true;
          } else {
            loginSuccess = false;
          }
        }
      }

      setState(() {
        _isLoading = false;
      });

      if (loginSuccess) {
        // Load user data
        Provider.of<UserProvider>(context, listen: false).loadUser();
        // Navigate to home page
        Navigator.pushNamed(context, AppConstants.homeRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login failed. Please check your credentials.'),
            backgroundColor: AppColors.error,
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
    _otpCountdownSubscription?.cancel();
    super.dispose();
  }
}
