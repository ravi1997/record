import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';

class ApiService {
  // Base URL for the Flask backend
  static String baseUrl =
      'http://192.168.1.8:5000'; // Adjust this to your Flask server URL

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

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('OTP verification failed: ${response.statusCode}');
        print('Response: ${response.body}');
        // In case of failure, we could implement local database fallback
        // For now, return null
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

      // Add compressed files
      for (var file in files) {
        if (file.bytes != null) {
          // Compress the file data using gzip
          List<int> originalData = file.bytes!;
          List<int> compressedData = GZipEncoder().encode(originalData)!;

          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              compressedData,
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
        Uri.parse(
          '$baseUrl/patients/search?search_type=$searchType&search_term=$searchTerm',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
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

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get patient details failed: ${response.statusCode}');
        print('Response: ${response.body}');
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
        print('Download file failed: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  // Get the maximum file size limit from the backend
  static Future<int> getMaxFileSize() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/config'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['max_file_size'] ??
            (5 * 1024 * 1024); // Default to 5MB if not provided
      } else {
        // Return default value if API call fails
        return 5 * 1024 * 1024; // 5MB in bytes
      }
    } catch (e) {
      print('Error fetching config: $e');
      // Return default value if there's an error
      return 5 * 1024 * 1024; // 5MB in bytes
    }
  }

  // Sync local data with server
  static Future<Map<String, dynamic>?> syncData() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sync'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Sync failed: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during sync: $e');
      return null;
    }
  }
}
