// Offline API Service - Mock implementation for offline mode
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import '../constants/app_constants.dart';

class ApiService {
  // Mock login with employee credentials
  static Future<Map<String, dynamic>?> loginWithEmployee(
    String employeeId,
    String password,
  ) async {
    // Simulate successful login in offline mode
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Return mock user data
    return {
      'success': true,
      'user': {
        'id': 1,
        'employee_id': employeeId,
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'role': 'Administrator',
      },
      'token': 'mock_token_for_offline_mode',
    };
  }

  // Mock send OTP to mobile number
  static Future<bool> sendOtp(String mobileNumber) async {
    // Simulate sending OTP in offline mode
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // In offline mode, always return true to simulate successful sending
    return true;
  }

  // Mock verify OTP
  static Future<Map<String, dynamic>?> verifyOtp(
    String mobileNumber,
    String otp,
  ) async {
    // Simulate OTP verification in offline mode
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Return mock success response
    return {
      'success': true,
      'user': {
        'id': 1,
        'mobile': mobileNumber,
        'name': 'John Doe',
        'role': 'Administrator',
      },
      'token': 'mock_token_for_offline_mode',
    };
  }

  // Mock submit patient data with files
  static Future<bool> submitPatientData({
    required String crn,
    required String uhid,
    required String patientName,
    required String dob,
    required List<PlatformFile> files,
  }) async {
    // Simulate patient data submission in offline mode
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // In offline mode, we assume the data was submitted successfully
    // (it's actually handled by local database in the app)
    return true;
  }

  // Mock search patient records
  static Future<List<Map<String, dynamic>>?> searchPatients({
    required String searchType,
    required String searchTerm,
  }) async {
    // Simulate patient search in offline mode
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Return empty list since we're using local database
    return [];
  }

  // Mock get patient details by ID
  static Future<Map<String, dynamic>?> getPatientDetails(
    String patientId,
  ) async {
    // Simulate getting patient details in offline mode
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Return null since we're using local database
    return null;
  }

  // Mock download a file
  static Future<dynamic> downloadFile(String fileId) async {
    // Simulate file download in offline mode
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Return null since we're using local database
    return null;
  }

  // Mock get the maximum file size limit from the backend
  static Future<int> getMaxFileSize() async {
    // Return default value for offline mode (5MB)
    return AppConstants.maxFileSize; // 5MB in bytes
  }

  // Mock sync local data with server
  static Future<Map<String, dynamic>?> syncData() async {
    // Simulate sync in offline mode
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Return mock sync result for offline mode
    return {
      'success': false,
      'message': AppConstants.offlineModeMessage,
      'synced_count': 0,
      'pending_count': 0,
      'error_count': 0,
    };
  }
}
