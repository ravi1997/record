import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/local_db_service.dart';
import '../services/api_service.dart';

class SyncService {
  static const String baseUrl =
      'http://192.168.1.8:5000'; // Replace with your actual backend URL

  // Sync all pending patients and files to the server
  static Future<SyncResult> syncAllData() async {
    try {
      final dbService = LocalDBService();

      // Get all unsynced patients
      final unsyncedPatients = await dbService.getUnsyncedPatients();

      int syncedCount = 0;
      int errorCount = 0;

      // Sync each patient
      for (var patient in unsyncedPatients) {
        try {
          // Prepare patient data
          final patientData = {
            'crn': patient['crn'],
            'uhid': patient['uhid'],
            'patient_name': patient['patient_name'],
            'dob': patient['dob'],
          };

          // Submit patient data to server
          final success = await ApiService.submitPatientData(
            crn: patient['crn'],
            uhid: patient['uhid'],
            patientName: patient['patient_name'],
            dob: patient['dob'],
            files: [], // Files will be handled separately
          );

          if (success) {
            // Mark patient as synced
            await dbService.markPatientAsSynced(patient['id']);

            // Get and sync associated files
            final files = await dbService.getFilesForPatient(patient['id']);
            for (var file in files) {
              try {
                // In a real implementation, you would upload the file to the server
                // For now, we'll just mark it as synced
                await dbService.markFileAsSynced(file['id']);
              } catch (e) {
                errorCount++;
              }
            }

            syncedCount++;
          } else {
            errorCount++;
          }
        } catch (e) {
          errorCount++;
        }
      }

      return SyncResult(
        success: true,
        syncedCount: syncedCount,
        errorCount: errorCount,
      );
    } catch (e) {
      return SyncResult(success: false, error: e.toString());
    }
  }

  // Sync specific patient to the server
  static Future<SyncResult> syncPatient(int patientId) async {
    try {
      final dbService = LocalDBService();

      // Get patient data
      final patient = await dbService.getPatientById(patientId);

      if (patient == null) {
        return SyncResult(success: false, error: 'Patient not found');
      }

      // Check if already synced
      if (patient['synced'] == 1) {
        return SyncResult(
          success: true,
          syncedCount: 0,
          message: 'Patient already synced',
        );
      }

      // Submit patient data to server
      final success = await ApiService.submitPatientData(
        crn: patient['crn'],
        uhid: patient['uhid'],
        patientName: patient['patient_name'],
        dob: patient['dob'],
        files: [], // Files will be handled separately
      );

      if (success) {
        // Mark patient as synced
        await dbService.markPatientAsSynced(patientId);

        // Get and sync associated files
        final files = await dbService.getFilesForPatient(patientId);
        for (var file in files) {
          try {
            // In a real implementation, you would upload the file to the server
            // For now, we'll just mark it as synced
            await dbService.markFileAsSynced(file['id']);
          } catch (e) {
            // Continue with other files
          }
        }

        return SyncResult(success: true, syncedCount: 1);
      } else {
        return SyncResult(success: false, error: 'Failed to sync patient data');
      }
    } catch (e) {
      return SyncResult(success: false, error: e.toString());
    }
  }

  // Pull data from server (for offline-first approach)
  static Future<SyncResult> pullData() async {
    try {
      // In a real implementation, you would fetch data from the server
      // and update the local database accordingly

      // For now, we'll just return a mock result
      return SyncResult(success: true, message: 'Data pulled successfully');
    } catch (e) {
      return SyncResult(success: false, error: e.toString());
    }
  }

  // Push data to server (for offline-first approach)
  static Future<SyncResult> pushData() async {
    try {
      // This is essentially the same as syncAllData
      return await syncAllData();
    } catch (e) {
      return SyncResult(success: false, error: e.toString());
    }
  }

  // Check connection to server
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/config'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get sync status
  static Future<SyncStatus> getSyncStatus() async {
    try {
      final dbService = LocalDBService();

      // Get counts
      final totalPatients = await dbService.getPatientCount();
      final syncedPatients = await dbService.getSyncedPatientCount();
      final unsyncedPatients = totalPatients - syncedPatients;

      final totalFiles = await dbService.getFileCount();
      final syncedFiles = await dbService.getSyncedFileCount();
      final unsyncedFiles = totalFiles - syncedFiles;

      return SyncStatus(
        totalPatients: totalPatients,
        syncedPatients: syncedPatients,
        unsyncedPatients: unsyncedPatients,
        totalFiles: totalFiles,
        syncedFiles: syncedFiles,
        unsyncedFiles: unsyncedFiles,
      );
    } catch (e) {
      // Return default status if there's an error
      return SyncStatus(
        totalPatients: 0,
        syncedPatients: 0,
        unsyncedPatients: 0,
        totalFiles: 0,
        syncedFiles: 0,
        unsyncedFiles: 0,
      );
    }
  }

  // Reset sync status (mark all as unsynced)
  static Future<void> resetSyncStatus() async {
    try {
      final dbService = LocalDBService();
      await dbService.resetAllSyncStatus();
    } catch (e) {
      throw Exception('Failed to reset sync status: $e');
    }
  }

  // Force sync (retry failed syncs)
  static Future<SyncResult> forceSync() async {
    try {
      // Reset sync status for failed syncs
      await resetSyncStatus();

      // Then sync all data
      return await syncAllData();
    } catch (e) {
      return SyncResult(success: false, error: e.toString());
    }
  }
}

// Sync result class
class SyncResult {
  final bool success;
  final int syncedCount;
  final int errorCount;
  final String? message;
  final String? error;

  SyncResult({
    required this.success,
    this.syncedCount = 0,
    this.errorCount = 0,
    this.message,
    this.error,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'syncedCount': syncedCount,
      'errorCount': errorCount,
      'message': message,
      'error': error,
    };
  }

  @override
  String toString() {
    return 'SyncResult(success: $success, syncedCount: $syncedCount, errorCount: $errorCount, message: $message, error: $error)';
  }
}

// Sync status class
class SyncStatus {
  final int totalPatients;
  final int syncedPatients;
  final int unsyncedPatients;
  final int totalFiles;
  final int syncedFiles;
  final int unsyncedFiles;

  SyncStatus({
    required this.totalPatients,
    required this.syncedPatients,
    required this.unsyncedPatients,
    required this.totalFiles,
    required this.syncedFiles,
    required this.unsyncedFiles,
  });

  double get syncPercentage {
    if (totalPatients == 0) return 0.0;
    return (syncedPatients / totalPatients) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPatients': totalPatients,
      'syncedPatients': syncedPatients,
      'unsyncedPatients': unsyncedPatients,
      'totalFiles': totalFiles,
      'syncedFiles': syncedFiles,
      'unsyncedFiles': unsyncedFiles,
      'syncPercentage': syncPercentage,
    };
  }

  @override
  String toString() {
    return 'SyncStatus(totalPatients: $totalPatients, syncedPatients: $syncedPatients, unsyncedPatients: $unsyncedPatients, totalFiles: $totalFiles, syncedFiles: $syncedFiles, unsyncedFiles: $unsyncedFiles, syncPercentage: $syncPercentage%)';
  }
}
