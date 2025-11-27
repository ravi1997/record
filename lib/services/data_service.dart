import 'package:sqflite/sqflite.dart';
import '../exceptions/data_exception.dart';
import 'local_db_service.dart';
import 'package:file_picker/file_picker.dart';

class DataService {
  final LocalDBService _localDB = LocalDBService();

  // Submit patient data - first save locally in a transaction, then sync with server
  Future<bool> submitPatientData({
    required String crn,
    required String uhid,
    required String patientName,
    required String? dob,
    required List<PlatformFile> files,
  }) async {
    try {
      final db = await _localDB.database;
      int patientId = -1;

      // Wrap patient and file inserts in a single transaction
      await db.transaction((txn) async {
        // Insert patient into local database
        patientId = await txn.insert(
          'patients',
          {
            'crn': crn,
            'uhid': uhid,
            'patient_name': patientName,
            'dob': dob ?? '',
            'synced': 0, // Mark as not synced initially
          },
          conflictAlgorithm:
              ConflictAlgorithm.abort, // Throw error on duplicate CRN
        );

        // Insert files into local database
        for (PlatformFile file in files) {
          if (file.bytes != null) {
            await txn.insert(
              'files',
              {
                'patient_id': patientId,
                'filename': file.name,
                'file_data': file.bytes!,
                'file_size': file.size,
                'synced': 0, // Mark as not synced initially
              },
            );
          }
        }
      });

      // Attempt to sync with server immediately
      bool synced = await _syncWithServer();
      return synced; // Propagate sync status
    } on Exception catch (e) {
      // Handle database-specific errors like duplicate CRN
      throw DataException('Error submitting patient data: $e');
    }
  }

  // Search patients - first check local database, then server if needed
  Future<List<Map<String, dynamic>>> searchPatients({
    required String searchType,
    required String searchTerm,
  }) async {
    try {
      // First search in local database
      List<Map<String, dynamic>> localResults = await _localDB.searchPatients(
        searchType: searchType,
        searchTerm: searchTerm,
      );

      // Convert local results to the format expected by the UI
      List<Map<String, dynamic>> results = [];
      for (var patient in localResults) {
        // Get associated files for this patient
        List<Map<String, dynamic>> files = await _localDB.getFilesForPatient(
          patient['id'],
        );

        results.add({
          'id': patient['id'],
          'crn': patient['crn'],
          'uhid': patient['uhid'],
          'patientName': patient['patient_name'],
          'dob': patient['dob'],
          'files': files,
          'source': 'local', // Indicate this is from local DB
        });
      }

      // In offline mode, we only return local results
      // No server search is performed

      return results;
    } catch (e) {
      throw DataException('Error searching patients: $e');
    }
  }

  // Get patient details by ID
  Future<Map<String, dynamic>?> getPatientDetails(int patientId) async {
    try {
      // Get patient from local database
      Map<String, dynamic>? patient = await _localDB.getPatientById(patientId);
      if (patient != null) {
        // Get associated files
        List<Map<String, dynamic>> files = await _localDB.getFilesForPatient(
          patientId,
        );

        return {
          'id': patient['id'],
          'crn': patient['crn'],
          'uhid': patient['uhid'],
          'patientName': patient['patient_name'],
          'dob': patient['dob'],
          'files': files,
          'source': 'local',
        };
      }

      return null;
    } catch (e) {
      throw DataException('Error getting patient details: $e');
    }
  }

  // Sync all local data with server
  Future<bool> syncWithServer() async {
    return await _syncWithServer();
  }

  // Internal method to sync with server - in offline mode, just mark as synced
  Future<bool> _syncWithServer() async {
    try {
      // In offline mode, we just mark all local records as synced
      // since there's no server to sync with
      final unsyncedPatients = await _localDB.getUnsyncedPatients();
      for (var patient in unsyncedPatients) {
        await _localDB.markPatientAsSynced(patient['id']);

        // Mark all files for this patient as synced
        final files = await _localDB.getFilesForPatient(patient['id']);
        for (var file in files) {
          await _localDB.markFileAsSynced(file['id']);
        }
      }

      return true;
    } catch (e) {
      throw DataException('Error in offline sync: $e');
    }
  }

  // Close the local database
  Future<void> close() async {
    await _localDB.close();
  }
}
