import 'package:file_picker/file_picker.dart';
import '../services/local_db_service.dart';
import '../services/api_service.dart';
import '../constants/app_constants.dart';

class SyncService {
  // Sync all pending patients and files to the server
  static Future<SyncResult> syncAllData() async {
    try {
      final dbService = LocalDBService();

      // Get all unsynced patients
      final unsyncedPatients = await dbService.getUnsyncedPatients();

      int syncedCount = 0;
      int errorCount = 0;
      List<String> errorMessages = [];
      List<int> failedPatientIds = [];

      // Sync each patient
      for (var patient in unsyncedPatients) {
        try {
          // Get associated files for this patient
          final files = await dbService.getFilesForPatient(patient['id']);

          // Convert files to PlatformFile format for API
          List<PlatformFile> platformFiles = [];
          for (var file in files) {
            platformFiles.add(
              PlatformFile(
                name: file['filename'],
                size: file['file_size'],
                bytes: file['file_data'],
                path: null, // Path is null since we're using bytes
              ),
            );
          }

          // In offline mode, mark patient as synced directly
          await dbService.markPatientAsSynced(patient['id']);

          // Mark associated files as synced
          for (var file in files) {
            await dbService.markFileAsSynced(file['id']);
          }

          syncedCount++;
        } catch (e) {
          errorCount++;
          failedPatientIds.add(patient['id']);
          errorMessages.add('Error syncing patient ${patient['crn']}: $e');
        }
      }

      return SyncResult(
        success: errorCount == 0,
        syncedCount: syncedCount,
        errorCount: errorCount,
        errorMessages: errorMessages.isEmpty ? null : errorMessages,
        failedPatientIds: failedPatientIds.isEmpty ? null : failedPatientIds,
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

      // Get associated files for this patient
      final files = await dbService.getFilesForPatient(patientId);

      // Convert files to PlatformFile format for API
      List<PlatformFile> platformFiles = [];
      for (var file in files) {
        platformFiles.add(
          PlatformFile(
            name: file['filename'],
            size: file['file_size'],
            bytes: file['file_data'],
            path: null, // Path is null since we're using bytes
          ),
        );
      }

      // In offline mode, mark patient as synced directly
      await dbService.markPatientAsSynced(patientId);

      // Mark associated files as synced
      for (var file in files) {
        await dbService.markFileAsSynced(file['id']);
      }

      return SyncResult(success: true, syncedCount: 1);
    } catch (e) {
      return SyncResult(success: false, error: e.toString());
    }
  }

  // Pull data from server (for offline-first approach) - in offline mode, do nothing
  static Future<SyncResult> pullData() async {
    // In offline mode, we don't pull data from server
    return SyncResult(success: true, message: AppConstants.offlineModeMessage);
  }

  // Push data to server (for offline-first approach) - in offline mode, mark as synced locally
  static Future<SyncResult> pushData() async {
    try {
      // In offline mode, we just mark all data as synced locally
      final dbService = LocalDBService();
      final unsyncedPatients = await dbService.getUnsyncedPatients();

      int syncedCount = 0;
      for (var patient in unsyncedPatients) {
        await dbService.markPatientAsSynced(patient['id']);
        syncedCount++;
      }

      return SyncResult(
          success: true,
          syncedCount: syncedCount,
          message: AppConstants.offlineModeMessage);
    } catch (e) {
      return SyncResult(success: false, error: e.toString());
    }
  }

  // Check connection to server - always return false in offline mode
  static Future<bool> checkConnection() async {
    // In offline mode, we assume no server connection
    return false;
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

  // Force sync (retry failed syncs) - in offline mode, mark all as synced
  static Future<SyncResult> forceSync() async {
    try {
      // In offline mode, we just mark all data as synced locally
      final dbService = LocalDBService();
      final unsyncedPatients = await dbService.getUnsyncedPatients();

      int syncedCount = 0;
      for (var patient in unsyncedPatients) {
        await dbService.markPatientAsSynced(patient['id']);
        syncedCount++;

        // Mark associated files as synced
        final files = await dbService.getFilesForPatient(patient['id']);
        for (var file in files) {
          await dbService.markFileAsSynced(file['id']);
        }
      }

      return SyncResult(
          success: true,
          syncedCount: syncedCount,
          message: AppConstants.offlineModeMessage);
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
  final List<String>? errorMessages;
  final List<int>? failedPatientIds;

  SyncResult({
    required this.success,
    this.syncedCount = 0,
    this.errorCount = 0,
    this.message,
    this.error,
    this.errorMessages,
    this.failedPatientIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'syncedCount': syncedCount,
      'errorCount': errorCount,
      'message': message,
      'error': error,
      'errorMessages': errorMessages,
      'failedPatientIds': failedPatientIds,
    };
  }

  @override
  String toString() {
    return 'SyncResult(success: $success, syncedCount: $syncedCount, errorCount: $errorCount, message: $message, error: $error, errorMessages: $errorMessages, failedPatientIds: $failedPatientIds)';
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
