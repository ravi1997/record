import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
      appBar: AppBar(
        title: const Text('Patient Entry'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // CRN Number
              TextFormField(
                controller: _crnController,
                decoration: const InputDecoration(
                  labelText: 'CRN Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CRN number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // UHID
              TextFormField(
                controller: _uhidController,
                decoration: const InputDecoration(
                  labelText: 'UHID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter UHID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Patient Name
              TextFormField(
                controller: _patientNameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date of Birth
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
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
                      _dobController.text = pickedDate.toString().split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // File Upload Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload Files (Max 5 files, Max 5MB each)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // File selection button
                      ElevatedButton.icon(
                        onPressed: _pickFiles,
                        icon: const Icon(Icons.upload),
                        label: const Text('Select File'),
                      ),

                      const SizedBox(height: 10),

                      // Selected files list
                      if (_selectedFiles.isNotEmpty)
                        Column(
                          children: [
                            const Divider(),
                            ..._selectedFiles.asMap().entries.map((entry) {
                              int index = entry.key;
                              PlatformFile file = entry.value;
                              return ListTile(
                                leading: const Icon(Icons.insert_drive_file),
                                title: Text(file.name),
                                subtitle: Text(
                                  '${(file.size / 1024 / 1024).toStringAsFixed(2)} MB',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _selectedFiles.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        ),

                      if (_selectedFiles.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'No files selected',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                    // For now, just show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Patient data submitted successfully!'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Submit'),
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

      // Pick multiple files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
        withData: true, // Include file bytes in the result
        onFileLoading: (FilePickerStatus status) {
          // Handle file loading status if needed
        },
        // Limit the number of files to remaining slots
        allowCompression: false,
      );

      if (result != null) {
        // Filter files by size (max 5MB each)
        List<PlatformFile> validFiles = [];
        List<PlatformFile> oversizedFiles = [];

        for (PlatformFile file in result.files) {
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
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
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
