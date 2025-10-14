import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  String _searchType = 'CRN';
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Records'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search type selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Search by',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ToggleButtons(
                      isSelected: [
                        _searchType == 'CRN',
                        _searchType == 'UHID',
                        _searchType == 'Patient Name',
                      ],
                      onPressed: (index) {
                        setState(() {
                          switch (index) {
                            case 0:
                              _searchType = 'CRN';
                              break;
                            case 1:
                              _searchType = 'UHID';
                              break;
                            case 2:
                              _searchType = 'Patient Name';
                              break;
                          }
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('CRN'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('UHID'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Name'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search input and button
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Enter $_searchType',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _performSearch();
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Search'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Results section
            Expanded(
              child: _searchResults.isEmpty
                  ? _buildEmptyState()
                  : _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Enter search criteria above',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final record = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(record['patientName']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CRN: ${record['crn']}'),
                Text('UHID: ${record['uhid']}'),
                Text('DOB: ${record['dob']}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to view details page
              _viewRecordDetails(record);
            },
          ),
        );
      },
    );
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
      _searchResults = []; // Clear previous results
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock search results
    setState(() {
      _searchResults = [
        {
          'crn': 'CRN001',
          'uhid': 'UHID001',
          'patientName': 'John Doe',
          'dob': '1985-05-15',
        },
        {
          'crn': 'CRN002',
          'uhid': 'UHID002',
          'patientName': 'Jane Smith',
          'dob': '1990-12-03',
        },
        {
          'crn': 'CRN003',
          'uhid': 'UHID003',
          'patientName': 'Robert Johnson',
          'dob': '1978-08-22',
        },
      ];
      _isLoading = false;
    });
  }

  void _viewRecordDetails(Map<String, dynamic> record) {
    // Navigate to record details page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordDetailsPage(record: record),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class RecordDetailsPage extends StatelessWidget {
  final Map<String, dynamic> record;

  const RecordDetailsPage({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                    _buildInfoRow('Patient Name:', record['patientName']),
                    _buildInfoRow('CRN:', record['crn']),
                    _buildInfoRow('UHID:', record['uhid']),
                    _buildInfoRow('Date of Birth:', record['dob']),
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
                    // Mock file list
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text('Document_$index.pdf'),
                          trailing: const Icon(Icons.download),
                          onTap: () {
                            // Handle file download
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
