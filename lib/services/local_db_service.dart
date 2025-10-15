import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class LocalDBService {
  static Database? _database;

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medical_records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Create patients table
    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        crn TEXT UNIQUE NOT NULL,
        uhid TEXT NOT NULL,
        patient_name TEXT NOT NULL,
        dob TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Create files table
    await db.execute('''
      CREATE TABLE files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER,
        filename TEXT NOT NULL,
        file_data BLOB,
        file_size INTEGER,
        upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (patient_id) REFERENCES patients (id)
      )
    ''');
  }

  // Upgrade database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    // For now, we'll just recreate the tables
    await db.execute('DROP TABLE IF EXISTS files');
    await db.execute('DROP TABLE IF EXISTS patients');
    await _onCreate(db, newVersion);
  }

  // Insert a new patient
  Future<int> insertPatient({
    required String crn,
    required String uhid,
    required String patientName,
    required String dob,
  }) async {
    final db = await database;
    return await db.insert('patients', {
      'crn': crn,
      'uhid': uhid,
      'patient_name': patientName,
      'dob': dob,
      'synced': 0, // Mark as not synced initially
    });
  }

  // Insert a file
  Future<int> insertFile({
    required int patientId,
    required String filename,
    required Uint8List fileData,
    required int fileSize,
  }) async {
    final db = await database;
    return await db.insert('files', {
      'patient_id': patientId,
      'filename': filename,
      'file_data': fileData,
      'file_size': fileSize,
      'synced': 0, // Mark as not synced initially
    });
  }

  // Get all patients
  Future<List<Map<String, dynamic>>> getAllPatients() async {
    final db = await database;
    return await db.query('patients');
  }

  // Get patients by search criteria
  Future<List<Map<String, dynamic>>> searchPatients({
    required String searchType,
    required String searchTerm,
  }) async {
    final db = await database;

    String column;
    switch (searchType.toLowerCase()) {
      case 'crn':
        column = 'crn';
        break;
      case 'uhid':
        column = 'uhid';
        break;
      case 'patient_name':
        column = 'patient_name';
        break;
      default:
        column = 'patient_name';
    }

    return await db.query(
      'patients',
      where: "$column LIKE ?",
      whereArgs: ['%$searchTerm%'],
    );
  }

  // Get patient by ID
  Future<Map<String, dynamic>?> getPatientById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Get files for a patient
  Future<List<Map<String, dynamic>>> getFilesForPatient(int patientId) async {
    final db = await database;
    return await db.query(
      'files',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
  }

  // Mark a patient as synced
  Future<void> markPatientAsSynced(int patientId) async {
    final db = await database;
    await db.update(
      'patients',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [patientId],
    );
  }

  // Mark a file as synced
  Future<void> markFileAsSynced(int fileId) async {
    final db = await database;
    await db.update(
      'files',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [fileId],
    );
  }

  // Get unsynced patients
  Future<List<Map<String, dynamic>>> getUnsyncedPatients() async {
    final db = await database;
    return await db.query('patients', where: 'synced = ?', whereArgs: [0]);
  }

  // Get unsynced files
  Future<List<Map<String, dynamic>>> getUnsyncedFiles() async {
    final db = await database;
    return await db.query('files', where: 'synced = ?', whereArgs: [0]);
  }

  // Get patient count
  Future<int> getPatientCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM patients');
    return result.first['count'] as int;
  }

  // Get synced patient count
  Future<int> getSyncedPatientCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM patients WHERE synced = 1',
    );
    return result.first['count'] as int;
  }

  // Get file count
  Future<int> getFileCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM files');
    return result.first['count'] as int;
  }

  // Get synced file count
  Future<int> getSyncedFileCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM files WHERE synced = 1',
    );
    return result.first['count'] as int;
  }

  // Reset all sync status
  Future<void> resetAllSyncStatus() async {
    final db = await database;
    await db.rawUpdate('UPDATE patients SET synced = 0');
    await db.rawUpdate('UPDATE files SET synced = 0');
  }

  // Update the synced status of patients after successful sync
  Future<void> updateSyncedPatients(List<int> patientIds) async {
    final db = await database;
    Batch batch = db.batch();

    for (int id in patientIds) {
      batch.update('patients', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
    }

    await batch.commit();
  }

  // Update the synced status of files after successful sync
  Future<void> updateSyncedFiles(List<int> fileIds) async {
    final db = await database;
    Batch batch = db.batch();

    for (int id in fileIds) {
      batch.update('files', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
    }

    await batch.commit();
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
