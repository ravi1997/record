import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class UtilityService {
  // Format file size in human readable format
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (log(bytes) / log(1024)).floor();
    if (i >= suffixes.length) i = suffixes.length - 1;

    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  // Format date in human readable format
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format date and time in human readable format
  static String formatDateTime(DateTime dateTime) {
    final date = formatDate(dateTime);
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  // Validate email format
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate phone number format (10 digits)
  static bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  // Validate password strength
  static bool isValidPassword(String password) {
    // At least 6 characters
    return password.length >= 6;
  }

  // Generate a random patient ID
  static String generatePatientId() {
    final random = Random.secure();
    final randomString = base64UrlEncode(
            Uint8List.fromList(List.generate(6, (_) => random.nextInt(256))))
        .substring(0, 6);
    return 'PAT$randomString';
  }

  // Generate a random CRN (Case Record Number)
  static String generateCRN() {
    final now = DateTime.now();
    final random = Random.secure();
    final randomSuffix = (random.nextInt(90000) + 10000).toString();
    final prefix =
        '${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return '$prefix$randomSuffix';
  }

  // Generate a random UHID (Unique Health Identifier)
  static String generateUHID() {
    final random = Random.secure();
    final randomString = base64UrlEncode(
            Uint8List.fromList(List.generate(8, (_) => random.nextInt(256))))
        .substring(0, 8);
    return 'UH$randomString';
  }

  // Open a file with the default application
  static Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);

      switch (result.type) {
        case ResultType.done:
          // File opened successfully
          break;
        case ResultType.error:
          throw Exception('Error opening file: ${result.message}');
        case ResultType.noAppToOpen:
          throw Exception('No application found to open this file type');
        case ResultType.fileNotFound:
          throw Exception('File not found: $filePath');
        case ResultType.permissionDenied:
          throw Exception('Permission denied to open file');
      }
    } catch (e) {
      throw Exception('Failed to open file: $e');
    }
  }

  // Get application documents directory
  static Future<String> getDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get application cache directory
  static Future<String> getCacheDirectory() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  // Create a directory if it doesn't exist
  static Future<void> createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  // Delete a file
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Check if a file exists
  static Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }

  // Copy a file
  static Future<void> copyFile(
    String sourcePath,
    String destinationPath,
  ) async {
    final sourceFile = File(sourcePath);
    final destinationFile = File(destinationPath);

    if (await sourceFile.exists()) {
      // Create destination directory if it doesn't exist
      final destinationDir = destinationFile.parent;
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
      }

      await sourceFile.copy(destinationPath);
    } else {
      throw Exception('Source file does not exist: $sourcePath');
    }
  }

  // Move a file
  static Future<void> moveFile(
    String sourcePath,
    String destinationPath,
  ) async {
    final sourceFile = File(sourcePath);
    final destinationFile = File(destinationPath);

    if (await sourceFile.exists()) {
      // Create destination directory if it doesn't exist
      final destinationDir = destinationFile.parent;
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
      }

      await sourceFile.rename(destinationPath);
    } else {
      throw Exception('Source file does not exist: $sourcePath');
    }
  }

  // Get file extension
  static String getFileExtension(String fileName) {
    try {
      return fileName.split('.').last.toLowerCase();
    } catch (e) {
      return '';
    }
  }

  // Check if file type is supported
  static bool isSupportedFileType(String fileName) {
    final extension = getFileExtension(fileName);
    return AppConstants.allowedFileExtensions.contains(extension);
  }

  // Show a snackbar with a message
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
      ),
    );
  }

  // Show a success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green[700]);
  }

  // Show an error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.red[700]);
  }

  // Show a warning snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.orange[700]);
  }

  // Show an info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.blue[700]);
  }

  // Calculate age from date of birth
  static int calculateAge(String dobString) {
    try {
      final dob = DateTime.parse(dobString);
      final today = DateTime.now();
      int age = today.year - dob.year;

      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }

      return age;
    } catch (e) {
      return 0;
    }
  }

  // Validate date format (YYYY-MM-DD)
  static bool isValidDateFormat(String dateString) {
    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get days difference between two dates
  static int getDaysDifference(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate);
    return difference.inDays;
  }

  // Check if date is in the future
  static bool isFutureDate(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now);
  }

  // Check if date is in the past
  static bool isPastDate(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  // Get start of week
  static DateTime startOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    final daysToSubtract = dayOfWeek - 1; // Monday is 1, Sunday is 7
    return startOfDay(date.subtract(Duration(days: daysToSubtract)));
  }

  // Get end of week
  static DateTime endOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    final daysToAdd = 7 - dayOfWeek; // Sunday is 7
    return endOfDay(date.add(Duration(days: daysToAdd)));
  }

  // Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get end of month
  static DateTime endOfMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return endOfDay(lastDay);
  }

  // Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  // Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59);
  }
}
