import 'package:flutter/material.dart';
import 'dart:math';
import '../constants/app_constants.dart';
import '../utils/ui_components.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isGridView = true;
  int _selectedTimeRange = 0; // 0: Today, 1: Week, 2: Month, 3: Year

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIComponents.buildAppBar(
        title: 'Advanced Dashboard',
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Show notifications
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'export') {
                _exportData();
              } else if (value == 'refresh') {
                _refreshData();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'export', child: Text('Export Data')),
              const PopupMenuItem(value: 'refresh', child: Text('Refresh')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Range Selector
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
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

              // Key Metrics
              Text(
                'Key Metrics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              _buildMetricsGrid(),
              const SizedBox(height: 24),

              // Charts Section
              Text(
                'Analytics Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              _buildChartSection(),
              const SizedBox(height: 24),

              // Recent Activity
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
                    color: color.withOpacity(0.1),
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
                  onTap: () {
                    // View record details
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to full activity log
                },
                child: const Text('View All Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      UIComponents.buildSnackBar(
        message: 'Exporting data...',
        backgroundColor: Colors.blue[700]!,
        icon: Icons.file_download,
      ),
    );

    // Simulate export process
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        UIComponents.buildSnackBar(
          message: 'Data exported successfully!',
          backgroundColor: Colors.green[700]!,
          icon: Icons.check_circle,
        ),
      );
    });
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      UIComponents.buildSnackBar(
        message: 'Refreshing data...',
        backgroundColor: Colors.blue[700]!,
        icon: Icons.sync,
      ),
    );

    // Simulate refresh process
    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        UIComponents.buildSnackBar(
          message: 'Data refreshed successfully!',
          backgroundColor: Colors.green[700]!,
          icon: Icons.check_circle,
        ),
      );
    });
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

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Vertical grid lines
    for (int i = 0; i <= 6; i++) {
      final x = (size.width / 6) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Generate random data points for demonstration
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

    // Draw blue line (New Records)
    for (int i = 0; i < bluePoints.length - 1; i++) {
      canvas.drawLine(bluePoints[i], bluePoints[i + 1], bluePaint);
    }

    // Draw green line (Synced)
    for (int i = 0; i < greenPoints.length - 1; i++) {
      canvas.drawLine(greenPoints[i], greenPoints[i + 1], greenPaint);
    }

    // Draw orange line (Pending)
    for (int i = 0; i < orangePoints.length - 1; i++) {
      canvas.drawLine(orangePoints[i], orangePoints[i + 1], orangePaint);
    }

    // Draw data points
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
