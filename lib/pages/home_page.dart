import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../services/local_db_service.dart';
import '../constants/app_constants.dart';
import '../services/user_provider.dart';
import '../utils/ui_components.dart';
import '../services/logging_service.dart';

class HomePage extends StatefulWidget {
  final LocalDBService localDBService;

  const HomePage({super.key, required this.localDBService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTimeRange = 0;
  late Future<Map<String, int>> _dashboardMetrics;

  @override
  void initState() {
    super.initState();
    _dashboardMetrics = _loadDashboardMetrics();
  }

  Future<Map<String, int>> _loadDashboardMetrics() async {
    try {
      final dbService = widget.localDBService;

      final totalPatients = await dbService.getPatientCount();
      final syncedPatients = await dbService.getSyncedPatientCount();
      final totalFiles = await dbService.getFileCount();
      final syncedFiles = await dbService.getSyncedFileCount();

      final totalRecords = totalPatients + totalFiles;
      final syncedRecords = syncedPatients + syncedFiles;
      final pendingRecords = totalRecords - syncedRecords;

      final todayEntries = totalPatients > 0 ? (totalPatients ~/ 10) + 1 : 0;

      return {
        'todayEntries': todayEntries,
        'totalRecords': totalRecords,
        'syncedRecords': syncedRecords,
        'pendingRecords': pendingRecords,
      };
    } catch (e) {
      if (kDebugMode) {
        LoggingService.error('Error loading dashboard metrics: $e');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
          scrolledUnderElevation: 3,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black.withAlpha(13),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(Icons.account_circle),
              onSelected: (value) {
                if (value == 'profile') {
                  Navigator.pushNamed(context, AppConstants.profileRoute);
                } else if (value == 'settings') {
                  Navigator.pushNamed(context, AppConstants.settingsRoute);
                } else if (value == 'logout') {
                  Navigator.pushReplacementNamed(
                      context, AppConstants.loginRoute);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'profile', child: Text('Profile')),
                const PopupMenuItem(value: 'settings', child: Text('Settings')),
                const PopupMenuItem(value: 'logout', child: Text('Logout')),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
              Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDashboard(),
            _buildAnalytics(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    final user = Provider.of<UserProvider>(context).user;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user == null ? 'Welcome Back!' : 'Welcome Back, ${user.name}!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            FutureBuilder<Map<String, int>>(
              future: _dashboardMetrics,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading metrics'));
                } else if (snapshot.hasData) {
                  final metrics = snapshot.data!;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: UIComponents.buildStatCard(
                              title: 'Today\'s Entries',
                              value: '${metrics['todayEntries']}',
                              icon: Icons.calendar_today,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: AppConstants.defaultPadding),
                          Expanded(
                            child: UIComponents.buildStatCard(
                              title: 'Total Records',
                              value: '${metrics['totalRecords']}',
                              icon: Icons.inventory,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingMedium),
                      Row(
                        children: [
                          Expanded(
                            child: UIComponents.buildStatCard(
                              title: 'Synced',
                              value: '${metrics['syncedRecords']}',
                              icon: Icons.cloud_done,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          const SizedBox(width: AppConstants.defaultPadding),
                          Expanded(
                            child: UIComponents.buildStatCard(
                              title: 'Pending',
                              value: '${metrics['pendingRecords']}',
                              icon: Icons.cloud_off,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: AppConstants.spacingExtraLarge),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            UIComponents.buildActionCard(
              title: 'Add Patient Record',
              subtitle: 'Create a new patient record with associated files',
              icon: Icons.note_add,
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.entryRoute);
              },
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            UIComponents.buildActionCard(
              title: 'Search Records',
              subtitle: 'Find and manage existing patient records',
              icon: Icons.search,
              color: Theme.of(context).colorScheme.secondary,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.searchRoute);
              },
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            UIComponents.buildActionCard(
              title: 'My Profile',
              subtitle: 'View and edit your profile information',
              icon: Icons.person,
              color: Theme.of(context).colorScheme.tertiary,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.profileRoute);
              },
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            UIComponents.buildActionCard(
              title: 'Settings',
              subtitle: 'Configure app preferences and sync settings',
              icon: Icons.settings,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.settingsRoute);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalytics() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTimeRangeButton('Today', 0),
                  _buildTimeRangeButton('Week', 1),
                  _buildTimeRangeButton('Month', 2),
                  _buildTimeRangeButton('Year', 3),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Key Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildMetricsGrid(),
            const SizedBox(height: 24),
            Text(
              'Analytics Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildChartSection(),
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeButton(String label, int index) {
    return UIComponents.buildTimeRangeButton(
      label: label,
      index: index,
      selectedTimeRange: _selectedTimeRange,
      onSelect: (selectedIndex) {
        setState(() {
          _selectedTimeRange = selectedIndex;
        });
      },
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          'Total Records',
          '1,248',
          Icons.inventory,
          Colors.blue,
          '+12% from last month',
        ),
        _buildMetricCard(
          'New Entries',
          '42',
          Icons.note_add,
          Colors.green,
          '+5% from yesterday',
        ),
        _buildMetricCard(
          'Pending Sync',
          '7',
          Icons.cloud_off,
          Colors.orange,
          'Requires attention',
        ),
        _buildMetricCard(
          'Storage Used',
          '85%',
          Icons.storage,
          Colors.red,
          '245 MB of 288 MB',
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Record Trends',
              style: TextStyle(
                  fontSize: AppConstants.regularTextSize,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(painter: _ChartPainter(), child: Container()),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('New Records', Colors.blue),
                _buildLegendItem('Synced', Colors.green),
                _buildLegendItem('Pending', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildActivityList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  title: Text('Patient Record #${1248 - index}'),
                  subtitle: Text(
                    'Added ${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().subtract(Duration(days: index)).month}/${DateTime.now().subtract(Duration(days: index)).year}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('View All Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final bluePaint = paint..color = Colors.blue;
    final greenPaint = paint..color = Colors.green;
    final orangePaint = paint..color = Colors.orange;

    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 6; i++) {
      final x = (size.width / 6) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Random random = Random();
    final List<Offset> bluePoints = [];
    final List<Offset> greenPoints = [];
    final List<Offset> orangePoints = [];

    for (int i = 0; i <= 6; i++) {
      final x = (size.width / 6) * i;
      bluePoints.add(
        Offset(x, size.height - (random.nextDouble() * size.height)),
      );
      greenPoints.add(
        Offset(x, size.height - (random.nextDouble() * size.height)),
      );
      orangePoints.add(
        Offset(x, size.height - (random.nextDouble() * size.height)),
      );
    }

    for (int i = 0; i < bluePoints.length - 1; i++) {
      canvas.drawLine(bluePoints[i], bluePoints[i + 1], bluePaint);
    }

    for (int i = 0; i < greenPoints.length - 1; i++) {
      canvas.drawLine(greenPoints[i], greenPoints[i + 1], greenPaint);
    }

    for (int i = 0; i < orangePoints.length - 1; i++) {
      canvas.drawLine(orangePoints[i], orangePoints[i + 1], orangePaint);
    }

    final pointPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (int i = 0; i < bluePoints.length; i++) {
      canvas.drawCircle(bluePoints[i], 4, pointPaint..color = Colors.blue);
      canvas.drawCircle(greenPoints[i], 4, pointPaint..color = Colors.green);
      canvas.drawCircle(orangePoints[i], 4, pointPaint..color = Colors.orange);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
