import 'dart:typed_data';
import 'api_service.dart';
import 'local_db_service.dart';
import 'package:file_picker/file_picker.dart';

class DataService {
  final LocalDBService _localDB = LocalDBService();

  // Submit patient data - first save locally, then sync with server
  Future<bool> submitPatientData({
    required String crn,
    required String uhid,
    required String patientName,
    required String dob,
    required List<PlatformFile> files,
  }) async {
    try {
      // Insert patient into local database
      int patientId = await _localDB.insertPatient(
        crn: crn,
        uhid: uhid,
        patientName: patientName,
        dob: dob,
      );

      // Insert files into local database
      for (PlatformFile file in files) {
        if (file.bytes != null) {
          await _localDB.insertFile(
            patientId: patientId,
            filename: file.name,
            fileData: file.bytes!,
            fileSize: file.size,
          );
        }
      }

      // Attempt to sync with server immediately
      bool synced = await _syncWithServer();

      return true;
    } catch (e) {
      print('Error submitting patient data: $e');
      return false;
    }
  }

  // Search patients - first check local database, then server if needed
  Future<List<Map<String, dynamic>>?> searchPatients({
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

      // Try to get results from server as well
      try {
        List<Map<String, dynamic>>? serverResults =
            await ApiService.searchPatients(
              searchType: searchType,
              searchTerm: searchTerm,
            );

        if (serverResults != null) {
          // Add server results that aren't already in local results
          for (var serverPatient in serverResults) {
            bool exists = false;
            for (var localPatient in results) {
              if (localPatient['crn'] == serverPatient['crn']) {
                exists = true;
                break;
              }
            }

            if (!exists) {
              // Mark as server result
              serverPatient['source'] = 'server';
              results.add(serverPatient);
            }
          }
        }
      } catch (e) {
        print('Error searching on server: $e');
        // Still return local results if server fails
      }

      return results;
    } catch (e) {
      print('Error searching patients: $e');
      return null;
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
      print('Error getting patient details: $e');
      return null;
    }
  }

  // Sync all local data with server
  Future<bool> syncWithServer() async {
    return await _syncWithServer();
  }

  // Internal method to sync with server
  Future<bool> _syncWithServer() async {
    try {
      bool success = true;

      // Get all unsynced patients
      List<Map<String, dynamic>> unsyncedPatients = await _localDB
          .getUnsyncedPatients();

      // Sync each patient and its files
      for (var patient in unsyncedPatients) {
        // Get unsynced files for this patient
        List<Map<String, dynamic>> unsyncedFiles = await _localDB
            .getUnsyncedFiles();

        // Filter files that belong to this patient
        List<Map<String, dynamic>> patientFiles = [];
        for (var file in unsyncedFiles) {
          if (file['patient_id'] == patient['id']) {
            patientFiles.add(file);
          }
        }

        // Convert PlatformFile format for API
        List<PlatformFile> platformFiles = [];
        for (var file in patientFiles) {
          platformFiles.add(
            PlatformFile(
              name: file['filename'],
              size: file['file_size'],
              bytes: file['file_data'],
              path: null, // Path is null since we're using bytes
            ),
          );
        }

        // Submit to server
        bool result = await ApiService.submitPatientData(
          crn: patient['crn'],
          uhid: patient['uhid'],
          patientName: patient['patient_name'],
          dob: patient['dob'],
          files: platformFiles,
        );

        if (result) {
          // Mark as synced
          await _localDB.markPatientAsSynced(patient['id']);
          for (var file in patientFiles) {
            await _localDB.markFileAsSynced(file['id']);
          }
        } else {
          success = false;
        }
      }

      return success;
    } catch (e) {
      print('Error syncing with server: $e');
      return false;
    }
  }

  // Close the local database
  Future<void> close() async {
    await _localDB.close();
  }
}
