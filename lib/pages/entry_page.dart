import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/data_service.dart';
import '../constants/app_constants.dart';
import '../utils/ui_components.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _crnController = TextEditingController();
  final _uhidController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _dobController = TextEditingController();

  List<PlatformFile> _selectedFiles = [];
  int _maxFiles = 5;
  double _maxFileSizeMB = 5.0; // 5MB

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIComponents.buildAppBar(
        title: 'Patient Entry',
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // CRN Number
              TextFormField(
                controller: _crnController,
                decoration: InputDecoration(
                  labelText: 'CRN Number',
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  // This will be validated in the form submission instead
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // UHID
              TextFormField(
                controller: _uhidController,
                decoration: InputDecoration(
                  labelText: 'UHID',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  // This will be validated in the form submission instead
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Patient Name
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  // This will be validated in the form submission instead
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date of Birth (Optional)
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth (Optional)',
                  prefixIcon: const Icon(Icons.cake),
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
                validator: (value) {
                  // Date of birth is optional, but if provided, validate format
                  if (value != null && value.isNotEmpty) {
                    try {
                      DateTime.parse(value);
                    } catch (e) {
                      return 'Please enter a valid date in YYYY-MM-DD format';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // File Upload Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.upload_file, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Upload Files',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Max: 5 files, 5MB each',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // File selection button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _pickFiles,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Files'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.blue[200]!),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Selected files list
                    if (_selectedFiles.isNotEmpty)
                      Column(
                        children: [
                          ..._selectedFiles.asMap().entries.map((entry) {
                            int index = entry.key;
                            PlatformFile file = entry.value;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.blue,
                                  ),
                                ),
                                title: Text(
                                  file.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  '${(file.size / 1024 / 1024).toStringAsFixed(2)} MB',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedFiles.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),

                    if (_selectedFiles.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No files selected',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitPatientData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Patient Record',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickFiles() async {
    try {
      // Check if we've reached the max number of files
      if (_selectedFiles.length >= _maxFiles) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum number of files reached (5)')),
        );
        return;
      }

      // Calculate how many more files we can select
      int remainingSlots = _maxFiles - _selectedFiles.length;

      // Pick multiple files with limit
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
        withData: true, // Include file bytes in the result
        onFileLoading: (FilePickerStatus status) {
          // Handle file loading status if needed
        },
        // Limit the number of files to remaining slots
        allowCompression: false,
        // Note: FilePicker doesn't directly support limiting count, we'll handle it after selection
      );

      if (result != null) {
        // Limit to remaining slots
        List<PlatformFile> filesToProcess = result.files;
        if (filesToProcess.length > remainingSlots) {
          filesToProcess = filesToProcess.sublist(0, remainingSlots);
        }

        // Filter files by size (max 5MB each)
        List<PlatformFile> validFiles = [];
        List<PlatformFile> oversizedFiles = [];

        for (PlatformFile file in filesToProcess) {
          double fileSizeMB = file.size / 1024 / 1024; // Convert bytes to MB

          if (fileSizeMB > _maxFileSizeMB) {
            oversizedFiles.add(file);
          } else {
            validFiles.add(file);
          }
        }

        // Check if adding valid files would exceed the limit
        int totalFilesAfterAdd = _selectedFiles.length + validFiles.length;
        if (totalFilesAfterAdd > _maxFiles) {
          int excess = totalFilesAfterAdd - _maxFiles;
          // Remove excess files from the end
          validFiles = validFiles.sublist(0, validFiles.length - excess);
        }

        setState(() {
          _selectedFiles.addAll(validFiles);
        });

        // Show message about oversized files if any
        if (oversizedFiles.isNotEmpty) {
          String msg =
              'The following files were too large (>5MB) and not added: ';
          msg += oversizedFiles.map((f) => f.name).join(', ');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
          );
        }

        // Show message if we hit the file limit
        if (_selectedFiles.length >= _maxFiles) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Maximum number of files reached (5)')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
    }
  }

  void _submitPatientData() async {
    // Validate that at least one of CRN, UHID, or Patient Name is entered
    if (_crnController.text.isEmpty &&
        _uhidController.text.isEmpty &&
        _patientNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'At least one of CRN, UHID, or Patient Name must be entered.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              const Text("Saving patient data..."),
            ],
          ),
        );
      },
    );

    try {
      // Use data service to store data
      final dataService = DataService();

      // Submit patient data
      bool success = await dataService.submitPatientData(
        crn: _crnController.text,
        uhid: _uhidController.text,
        patientName: _patientNameController.text,
        dob: _dobController.text.isNotEmpty ? _dobController.text : null,
        files: _selectedFiles,
      );

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success message
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient data saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the form
        _formKey.currentState!.reset();
        _crnController.clear();
        _uhidController.clear();
        _patientNameController.clear();
        _dobController.clear();
        setState(() {
          _selectedFiles = [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving patient data. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close the loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving patient data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _crnController.dispose();
    _uhidController.dispose();
    _patientNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
