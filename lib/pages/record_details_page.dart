import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart' show PlatformException;
import '../services/local_db_service.dart';
import '../constants/app_constants.dart';
import '../utils/ui_components.dart';

class RecordDetailsPage extends StatefulWidget {
  final Map<String, dynamic> record;

  const RecordDetailsPage({super.key, required this.record});

  @override
  State<RecordDetailsPage> createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  List<Map<String, dynamic>> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  void _loadFiles() async {
    try {
      final dbService = LocalDBService();
      List<Map<String, dynamic>> files = await dbService.getFilesForPatient(
        widget.record['id'],
      );
      setState(() {
        _files = files;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 8),
                Text('Error loading files: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSynced = widget.record['synced'] == 1;
    return Scaffold(
      appBar: UIComponents.buildAppBar(
        title: 'Record Details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Patient Name:',
                      widget.record['patient_name'],
                    ),
                    _buildInfoRow('CRN:', widget.record['crn']),
                    _buildInfoRow('UHID:', widget.record['uhid']),
                    _buildInfoRow('Date of Birth:', widget.record['dob']),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Sync Status:',
                      isSynced ? 'Uploaded to Server' : 'Not Uploaded',
                    ),
                    if (!isSynced)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'This record has not been uploaded to the server yet',
                          style: TextStyle(
                            color: Colors.orange[800]!,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attached Files',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _files.isEmpty
                            ? const Text('No files attached to this record')
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _files.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> file = _files[index];
                                  return ListTile(
                                    leading:
                                        const Icon(Icons.insert_drive_file),
                                    title: Text(file['filename']),
                                    subtitle: Text(
                                      '${(file['file_size'] / 1024 / 1024).toStringAsFixed(2)} MB',
                                    ),
                                    trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'view',
                                          child: Text('View'),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'view') {
                                          _viewFile(file);
                                        }
                                      },
                                    ),
                                    onTap: () {
                                      _viewFile(file);
                                    },
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewFile(Map<String, dynamic> file) async {
    try {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${file['filename']}';

      // Write the file data to the device
      final fileToSave = File(filePath);
      if (file['file_data'] != null) {
        await fileToSave.writeAsBytes(file['file_data']);
      } else {
        throw Exception('File data is null');
      }

      // Open the file
      final result = await OpenFile.open(filePath);

      if (mounted) {
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Error opening file: ${result.message}'),
                ],
              ),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } on PlatformException catch (e) {
      // Handle platform-specific errors (like the path_provider error)
      if (mounted) {
        if (e.code == 'channel-error') {
          // This typically means the plugin isn't properly initialized
          // (often happens when app hasn't been rebuilt after adding plugins)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Plugin not initialized. Please rebuild the app after adding new plugins.',
                  ),
                ],
              ),
              backgroundColor: Colors.orange[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Platform error: ${e.message}'),
                ],
              ),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 8),
                Text('Error viewing file: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
