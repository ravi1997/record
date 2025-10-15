import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../services/local_db_service.dart';

class ExportService {
  // Export patient data to CSV
  static Future<String> exportToCSV() async {
    try {
      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/patient_records_${DateTime.now().millisecondsSinceEpoch}.csv';

      // Get all patients from database
      final dbService = LocalDBService();
      final patients = await dbService.getAllPatients();

      // Prepare CSV data
      List<List<dynamic>> csvData = [];

      // Add headers
      csvData.add([
        'ID',
        'CRN',
        'UHID',
        'Patient Name',
        'Date of Birth',
        'Created At',
        'Synced',
      ]);

      // Add patient data
      for (var patient in patients) {
        csvData.add([
          patient['id'],
          patient['crn'],
          patient['uhid'],
          patient['patient_name'],
          patient['dob'],
          patient['created_at'],
          patient['synced'] == 1 ? 'Yes' : 'No',
        ]);
      }

      // Convert to CSV string
      final csvString = const ListToCsvConverter().convert(csvData);

      // Write to file
      final file = File(filePath);
      await file.writeAsString(csvString);

      return filePath;
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  // Export patient data to PDF
  static Future<String> exportToPDF() async {
    try {
      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/patient_records_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Get all patients from database
      final dbService = LocalDBService();
      final patients = await dbService.getAllPatients();

      // Create PDF document
      final pdf = pw.Document();

      // Add content to PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  'Patient Records Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Generated on: ${DateTime.now()}',
                  style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: [
                    'ID',
                    'CRN',
                    'UHID',
                    'Patient Name',
                    'DOB',
                    'Created At',
                    'Synced',
                  ],
                  data: patients.map((patient) {
                    return [
                      patient['id'],
                      patient['crn'],
                      patient['uhid'],
                      patient['patient_name'],
                      patient['dob'],
                      patient['created_at'],
                      patient['synced'] == 1 ? 'Yes' : 'No',
                    ];
                  }).toList(),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.blue,
                  ),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellStyle: const pw.TextStyle(fontSize: 10),
                ),
              ],
            );
          },
        ),
      );

      // Save PDF to file
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return filePath;
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  // Export patient data to JSON
  static Future<String> exportToJSON() async {
    try {
      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/patient_records_${DateTime.now().millisecondsSinceEpoch}.json';

      // Get all patients from database
      final dbService = LocalDBService();
      final patients = await dbService.getAllPatients();

      // Convert to JSON string
      final jsonString = jsonEncode(patients);

      // Write to file
      final file = File(filePath);
      await file.writeAsString(jsonString);

      return filePath;
    } catch (e) {
      throw Exception('Failed to export JSON: $e');
    }
  }

  // Export specific patient with files
  static Future<String> exportPatientWithFiles(int patientId) async {
    try {
      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final exportDir = '${directory.path}/patient_$patientId';

      // Create export directory
      await Directory(exportDir).create(recursive: true);

      // Get patient data
      final dbService = LocalDBService();
      final patient = await dbService.getPatientById(patientId);

      if (patient == null) {
        throw Exception('Patient not found');
      }

      // Get patient files
      final files = await dbService.getFilesForPatient(patientId);

      // Create patient info file
      final infoFile = File('$exportDir/patient_info.txt');
      await infoFile.writeAsString('''
Patient Information
====================

ID: ${patient['id']}
CRN: ${patient['crn']}
UHID: ${patient['uhid']}
Patient Name: ${patient['patient_name']}
Date of Birth: ${patient['dob']}
Created At: ${patient['created_at']}
Synced: ${patient['synced'] == 1 ? 'Yes' : 'No'}

Files (${files.length})
=================
${files.map((f) => '- ${f['filename']} (${(f['file_size'] / 1024 / 1024).toStringAsFixed(2)} MB)').join('\n')}
''');

      // Copy files to export directory
      for (var file in files) {
        final originalFilePath = file['filepath'];
        final newFilePath = '$exportDir/${file['filename']}';

        // Copy file
        await File(originalFilePath).copy(newFilePath);
      }

      return exportDir;
    } catch (e) {
      throw Exception('Failed to export patient with files: $e');
    }
  }

  // Export all data as backup
  static Future<String> exportBackup() async {
    try {
      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/medical_records_backup_${DateTime.now().millisecondsSinceEpoch}.db';

      // In a real app, you would copy the actual database file
      // For this example, we'll just create a placeholder
      final file = File(filePath);
      await file.writeAsString('''
Medical Records Backup
=======================

This is a placeholder for a database backup file.
In a real application, this would contain the actual SQLite database.

Generated on: ${DateTime.now()}
''');

      return filePath;
    } catch (e) {
      throw Exception('Failed to export backup: $e');
    }
  }
}
