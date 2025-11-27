import 'package:flutter/material.dart';
import '../services/local_db_service.dart';
import '../utils/ui_components.dart';
import 'record_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // Changed to default to showing all records
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  int _currentPage = 0;
  int _pageSize = 20;
  bool _hasMoreResults = true;

  @override
  void initState() {
    super.initState();
    // Initialize scroll controller
    _scrollController.addListener(_scrollListener);
    // Load all records when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIComponents.buildAppBar(
        title: 'Search Records',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory,
                      color: Colors.blue[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Medical Records',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'Local database records',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search input field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search records (name, CRN, UHID)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performLocalSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                _performLocalSearch(value);
              },
            ),
            const SizedBox(height: 16),

            // Action buttons row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _loadAllRecords,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _syncWithServer,
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Results section
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  return true;
                },
                child: _searchResults.isEmpty
                    ? _buildEmptyState()
                    : _buildResultsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, size: 60, color: Colors.blue),
          ),
          const SizedBox(height: 24),
          const Text(
            'No records found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? 'Enter a search term or click refresh to load records'
                : 'No records match your search',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _searchResults.length + (_hasMoreResults ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _searchResults.length) {
          // Loading indicator for pagination
          return _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink();
        }

        final record = _searchResults[index];
        bool isSynced =
            record['synced'] == 1; // 1 means synced, 0 means not synced
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSynced ? Colors.green[100]! : Colors.orange[100]!,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        record['patient_name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSynced ? Colors.green[100]! : Colors.orange[100]!,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSynced ? Icons.cloud_done : Icons.cloud_off,
                            size: 16,
                            color: isSynced
                                ? Colors.green[700]!
                                : Colors.orange[700]!,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isSynced ? 'Synced' : 'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSynced
                                  ? Colors.green[700]!
                                  : Colors.orange[700]!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: UIComponents.buildInfoChip('CRN', record['crn'])),
                    const SizedBox(width: 8),
                    Expanded(child: UIComponents.buildInfoChip('UHID', record['uhid'])),
                  ],
                ),
                const SizedBox(height: 8),
                UIComponents.buildInfoChip('DOB', record['dob']),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _viewRecordDetails(record),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _loadAllRecords() async {
    setState(() {
      _isLoading = true;
      _searchResults = []; // Clear previous results
      _currentPage = 0;
      _hasMoreResults = true;
    });

    try {
      // Load paginated records from local database
      final dbService = LocalDBService();
      List<Map<String, dynamic>> results = await dbService.getPatientsPaginated(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      setState(() {
        _isLoading = false;
        _searchResults = results;
        _hasMoreResults = results.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 8),
                Text('Error loading records: ${e.toString()}'),
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

  void _performLocalSearch(String searchTerm) async {
    if (searchTerm.isEmpty) {
      _loadAllRecords();
      return;
    }

    setState(() {
      _isLoading = true;
      _searchResults = [];
      _currentPage = 0;
      _hasMoreResults = true;
    });

    try {
      final dbService = LocalDBService();
      List<Map<String, dynamic>> results = [];

      // Try searching by all fields in sequence
      // First try searching by patient_name
      results = await dbService.searchPatients(
        searchType: 'patient_name',
        searchTerm: searchTerm,
      );

      // If no results found, try searching by CRN
      if (results.isEmpty) {
        results = await dbService.searchPatients(
          searchType: 'crn',
          searchTerm: searchTerm,
        );
      }

      // If still no results, try searching by UHID
      if (results.isEmpty) {
        results = await dbService.searchPatients(
          searchType: 'uhid',
          searchTerm: searchTerm,
        );
      }

      // If still no results, perform a more general search across all fields
      if (results.isEmpty && searchTerm.isNotEmpty) {
        List<Map<String, dynamic>> allRecords =
            await dbService.getAllPatients();
        String searchLower = searchTerm.toLowerCase();
        results = allRecords.where((record) {
          return record['patient_name'].toLowerCase().contains(searchLower) ||
              record['crn'].toLowerCase().contains(searchLower) ||
              record['uhid'].toLowerCase().contains(searchLower) ||
              record['dob'].toLowerCase().contains(searchLower);
        }).toList();
      }

      setState(() {
        _isLoading = false;
        _searchResults = results;
        _hasMoreResults = results.length >= _pageSize;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                Text('Error searching records: ${e.toString()}'),
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

  void _syncWithServer() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Syncing with server...",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulate sync operation in offline mode
    await Future.delayed(const Duration(seconds: 2));

    // Close the loading dialog
    Navigator.of(context).pop();

    if (mounted) {
      // Show offline sync message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.cloud_off, color: Colors.white),
              const SizedBox(width: 8),
              const Text('App is in offline mode. Data will sync when online.'),
            ],
          ),
          backgroundColor: Colors.orange[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
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

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMoreResults) {
      _loadMoreRecords();
    }
  }

  void _loadMoreRecords() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final dbService = LocalDBService();
      List<Map<String, dynamic>> results = await dbService.getPatientsPaginated(
        offset: (_currentPage + 1) * _pageSize,
        limit: _pageSize,
      );

      if (results.isEmpty) {
        setState(() {
          _hasMoreResults = false;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _currentPage++;
        _searchResults.addAll(results);
        _hasMoreResults = results.length == _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 8),
                Text('Error loading more records: ${e.toString()}'),
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
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}