import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ApiService {
  // Base URL for the Flask backend
  static const String baseUrl =
      'http://localhost:5000'; // Adjust this to your Flask server URL

  // Login with employee credentials
  static Future<Map<String, dynamic>?> loginWithEmployee(
    String employeeId,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/employee'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'employee_id': employeeId, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Login failed: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during employee login: $e');
      return null;
    }
  }

  // Send OTP to mobile number
  static Future<bool> sendOtp(String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobileNumber}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>?> verifyOtp(
    String mobileNumber,
    String otp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobileNumber, 'otp': otp}),
      );

      if (response.statusCode == 20) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return null;
    }
  }

  // Submit patient data with files
  static Future<bool> submitPatientData({
    required String crn,
    required String uhid,
    required String patientName,
    required String dob,
    required List<PlatformFile> files,
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/patients'),
      );

      // Add form fields
      request.fields['crn'] = crn;
      request.fields['uhid'] = uhid;
      request.fields['patient_name'] = patientName;
      request.fields['dob'] = dob;

      // Add files
      for (var file in files) {
        if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              file.bytes!,
              filename: file.name,
            ),
          );
        }
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Upload response: ${response.statusCode}');
      print('Upload body: $responseBody');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error submitting patient data: $e');
      return false;
    }
  }

  // Search patient records
  static Future<List<Map<String, dynamic>>?> searchPatients({
    required String searchType,
    required String searchTerm,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/search?$searchType=$searchTerm'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 20) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        return null;
      }
    } catch (e) {
      print('Error searching patients: $e');
      return null;
    }
  }

  // Get patient details by ID
  static Future<Map<String, dynamic>?> getPatientDetails(
    String patientId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$patientId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 20) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting patient details: $e');
      return null;
    }
  }

  // Download a file
  static Future<http.Response?> downloadFile(String fileId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/files/$fileId'));

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }
}
